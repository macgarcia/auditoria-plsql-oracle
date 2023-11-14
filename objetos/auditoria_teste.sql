create or replace type auditoria_teste as object (
    id number,
    member procedure teste_nome_de_tabela_invalido,
    member procedure teste_tabela_nao_existe,
    member procedure teste_argumento_invalido
);
/

create or replace type body auditoria_teste as
    --
    member procedure teste_nome_de_tabela_invalido is
        --
        type_auditoria auditoria_de_tabela;
        --
    begin
        --
        dbms_output.put_line('Identificador -> ' || id);
        dbms_output.put_line('teste_nome_de_tabela_invalido');
        --
        type_auditoria := auditoria_de_tabela(10, '');
        type_auditoria.iniciar;
        --
        dbms_output.put_line('***Fail***');
        --
    exception
      when others then
        --
        dbms_output.put_line('***Success***');
        --
    end;
    --
    member procedure teste_tabela_nao_existe is
        --
        type_auditoria auditoria_de_tabela;
        --
    begin
        --
        dbms_output.put_line('Identificador -> ' || id);
        dbms_output.put_line('teste_tabela_nao_existe');
        --
        type_auditoria := auditoria_de_tabela(10, 'AAA');
        type_auditoria.iniciar;
        --
        dbms_output.put_line('***Fail***');
        --
    exception
        when others then
            --
            dbms_output.put_line('***Success***');
            --
        --
    end;
    --
    member procedure teste_argumento_invalido is
        --
        type_auditoria auditoria_de_tabela;
        --
    begin
        --
        dbms_output.put_line('Identificador -> ' || id);
        dbms_output.put_line('teste_argumento_invalido');
        --
        type_auditoria := auditoria_de_tabela(10, 'teste');
        type_auditoria.iniciar;
        --
        dbms_output.put_line('***Fail***');
        --
    exception
        when others then
            --
            dbms_output.put_line('***Success***');
            --
    end;
    --
end;
/
