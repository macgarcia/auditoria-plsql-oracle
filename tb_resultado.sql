create table tb_resultado (
    id number,
    nome_tabela varchar2(50),
    qtde_colunas number,
    qtde_total_registros number,
    data_auditoria date,
    descricao varchar2(2000),
    pontuacao number,
    erro varchar2(500),
    constraint pk_resultado primary key(id)
);
/

create sequence tb_resultado_seq
start with 1
increment by 1
nominvalue
nomaxvalue
nocycle
nocache
/
