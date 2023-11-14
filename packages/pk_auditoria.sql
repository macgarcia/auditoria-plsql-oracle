create or replace package pk_auditoria is
    --
    procedure iniciar_auditoria(p_peso in number, p_nome_tabela in varchar2);
    --
end pk_auditoria;
/

create or replace package body pk_auditoria is
    --
    procedure iniciar_auditoria(p_peso in number, p_nome_tabela in varchar2) is
        --
        auditoria auditoria_de_tabela;
        --
    begin
        --
        auditoria := auditoria_de_tabela(p_peso, p_nome_tabela);
        auditoria.iniciar;
        --
    end iniciar_auditoria;
    --
end pk_auditoria;
/