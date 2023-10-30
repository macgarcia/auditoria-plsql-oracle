create or replace type auditoria_de_tabela as object(
    peso number,
    nome_tabela varchar2(100),

    member procedure iniciar
);
/

create or replace type body auditoria_de_tabela as
    --
    member procedure iniciar is
        --
        resultado resultado_auditoria;
        --
        vn_quantidate_de_registros_por_vez constant number := 50;
        --
        vn_registro_inicial number := 1;
        --
        vv_query_sql    varchar2(1000);
        vv_query_count  varchar(50);
        vv_descricao    varchar2(2000);
        --
        vn_pontuacao            number := 0;
        vn_pontuacao_temp       number;
        vn_numero_de_colunas    number;
        vn_qdte_registros       number;
        vn_indice               number := 1;
        vn_qtde_colunas         number := 0;
        --
        exception_no_data_found exception;
        --
    begin
        --
        vv_query_count := 'select count(*) from '|| nome_tabela;
        execute immediate vv_query_count into vn_qdte_registros;
        --
        if (vn_qdte_registros = 0) then
            --
            raise exception_no_data_found;
            --
        end if;
        --
        loop
            --
            vv_query_sql := 'select sum(';
            --
            for colunas in (select column_name from user_tab_columns where table_name = nome_tabela) loop
                --
                vv_query_sql := vv_query_sql || ' case when ' || colunas.column_name || ' is null then 1 else 0 end * ' || peso || ' + ';
                --
                vn_qtde_colunas := vn_qtde_colunas + 1;
                --
            end loop;
            --
            vv_query_sql := rtrim(vv_query_sql, ' + ');
            --
            vv_query_sql := vv_query_sql || ') / '|| vn_qdte_registros || ' from (select a.* , rownum rnum from ' || nome_tabela 
                || ' a where rownum <= ' || (vn_registro_inicial + vn_quantidate_de_registros_por_vez - 1) || ') where rnum >= ' || vn_registro_inicial;
            --
            execute immediate vv_query_sql into vn_pontuacao_temp;
            --
            vv_descricao := vv_descricao || 'Rodada ' || vn_indice || ':' || CHR(10) 
                                         || ' numero de registros possiveis para analise: ' || vn_quantidate_de_registros_por_vez || CHR(10)
                                         || ' pontos gerados: ' || ltrim(to_char(vn_pontuacao_temp, '999.99')) || '.' || CHR(10);
            --
            vn_pontuacao := vn_pontuacao + vn_pontuacao_temp;
            --
            vn_registro_inicial := vn_registro_inicial + vn_quantidate_de_registros_por_vez;
            --
            vv_query_sql := null;
            --
            vn_indice := vn_indice + 1;
            --
            exit when vn_registro_inicial > vn_qdte_registros;
            --
        end loop;
        --
        resultado := resultado_auditoria(nome_tabela, vn_qdte_registros, vn_qtde_colunas, sysdate, vv_descricao, vn_pontuacao, null);
        resultado.gravar_resultado;
        resultado.imprimir_resultado;
        --
    exception
        when exception_no_data_found then
            --
            resultado := resultado_auditoria(nome_tabela, null, vn_qtde_colunas, sysdate, null, null,
                'Erro: Tabela: ' || nome_tabela || ' não contem registros.');
            --
            resultado.imprimir_erro;
            --
            raise_application_error(-20001, 'Erro: Tabela: ' || nome_tabela || ' não contem registros.');
            --
        when others then
            --
            resultado := resultado_auditoria(nome_tabela, null, vn_qtde_colunas, sysdate, null, null,'Erro: ' || sqlerrm);
            --
            resultado.imprimir_erro;
            --
            raise_application_error(-20001, 'Erro: ' || sqlerrm);
            --
        --
    end;
    --
end;
/

