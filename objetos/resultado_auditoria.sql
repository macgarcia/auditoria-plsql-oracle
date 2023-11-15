create or replace type resultado_auditoria as object (
    r_nome_tabela varchar2(100),
    numero_de_registros number,
    qtde_colunas number,
    data_auditoria date,
    descricao varchar2(500),
    pontos number,
    peso_utilizado number,
    erro varchar2(500),

    member procedure imprimir_resultado,
    member procedure imprimir_erro,
    member procedure gravar_resultado
);
/

create or replace type body resultado_auditoria as
    --
    member procedure imprimir_resultado is
        --
        --
    begin
        --
        dbms_output.put_line('Nome da tabela auditada: ' || r_nome_tabela);
        dbms_output.put_line('Numero de registros na tabela: '|| numero_de_registros);
        dbms_output.put_line('-------------------------------------------------------');
        dbms_output.put_line('Info: ' || descricao);
        dbms_output.put_line('-------------------------------------------------------');
        dbms_output.put_line('Total de pontos gerados: '|| ltrim(to_char(pontos, '999.99')));
        dbms_output.put_line('Data: ' || data_auditoria);
        --
        if (erro is not null) then
            --
            dbms_output.put_line('Erro: ' || erro);
            --
        end if;
        --
    end;
    --
    member procedure imprimir_erro is
        --
        --
    begin
        --
        dbms_output.put_line('Nome da tabela auditada: ' || r_nome_tabela);
        dbms_output.put_line('Data: ' || data_auditoria);
        dbms_output.put_line('Erro: ' || erro);
        --
    end;
    --
    member procedure gravar_resultado is
        --
        --
    begin
        --
        delete from tb_resultado a where a.nome_tabela = r_nome_tabela;
        --
        insert into tb_resultado(id, nome_tabela, qtde_colunas, qtde_total_registros, data_auditoria, descricao, pontuacao, peso_utilizado, erro)
        values(tb_resultado_seq.nextval, r_nome_tabela, qtde_colunas, numero_de_registros, sysdate, descricao, pontos, peso_utilizado, erro);
        --
        commit;
        --
    end;
    --
end;
/
