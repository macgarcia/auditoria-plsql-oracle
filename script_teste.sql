set serveroutput on;

declare
    --
    teste auditoria_teste;
    --
begin
    --
    teste := auditoria_teste(1);
    teste.teste_nome_de_tabela_invalido;
    --
    dbms_output.put_line('-------------------------');
    --
    teste := auditoria_teste(2);
    teste.teste_tabela_nao_existe;
    --
    dbms_output.put_line('-------------------------');
    --
    teste := auditoria_teste(3);
    teste.teste_argumento_invalido;
    --
end;
/