create or replace package auditoria_oracle is
    -- Variaveis
    type nome_tabelas is table of varchar2(40) index by binary_integer;
    tabelas nome_tabelas;
    
    type clazz is record (tabela varchar2(40), consulta varchar2(30000));
    type mapa_tabela_consulta is table of clazz index by binary_integer;
    mapp mapa_tabela_consulta;
    
    -- Processos
    procedure iniciar(nome_tabela in varchar2, peso in number);
end;
/

create or replace package body auditoria_oracle is
    
    /* Processo que recupera os nomes de todas as tabelas do schema */
    procedure verificar_quantidade_tabelas is
    begin
        select table_name
          bulk collect into tabelas
          from user_tab_columns
         where table_name not in ('TB_RESULTADO')
         group by table_name;
    end;
    
    /* Verificação para saber se a tabela informada existe */
    procedure validar_tabela_informada(nome_tabela in varchar2) is
        teste varchar2(40);
    begin
        select table_name
          into teste
          from user_tab_columns
         where table_name = upper(nome_tabela)
        group by table_name;
    exception
        when no_data_found then
            raise_application_error(-20001, 'Tabela não existe...');
    end;
    
    /* Processo que monta a query */
    procedure montar_query(peso in number) is
        cursor colunas(nome_tabela in varchar2) is
            select column_name as nome from user_tab_columns where table_name = upper(nome_tabela);
            
        consulta varchar2(30000);
    begin
        for i in tabelas.first .. tabelas.last loop
            consulta := null;
            consulta := 'select sum(';
            for coluna in colunas(tabelas(i)) loop
                consulta := consulta || 'case when ' || coluna.nome || ' is null then 1 else 0 end * ' || peso || ' + ';
            end loop;
            consulta := rtrim(consulta, ' + ');
            consulta := consulta || ') from ' || tabelas(i);
            
            mapp(i).tabela := tabelas(i);
            mapp(i).consulta := consulta;
        end loop;
    end;

    procedure finalizar is
    begin
        tabelas := nome_tabelas();
        mapp := mapa_tabela_consulta();
    end;
    
    procedure imprimir_query is
    begin
        for i in mapp.first .. mapp.last loop
            dbms_output.put_line('Tabela: ' || mapp(i).tabela);
            dbms_output.put_line('Consulta ' || mapp(i).consulta);
        end loop;
    end;
    
    /* Processo de auditoria */
    procedure iniciar(nome_tabela in varchar2, peso in number) is
    begin
        if nome_tabela is null then
            verificar_quantidade_tabelas;
        else
            validar_tabela_informada(nome_tabela);
            tabelas(0) := nome_tabela;
        end if;
        montar_query(peso);
        imprimir_query;
        finalizar;
    exception
        when others then
            raise_application_error(-20002, sqlerrm);
    end;
end;
/

/*
set serveroutput on;
begin
    auditoria_oracle.iniciar('');
end;
/
*/