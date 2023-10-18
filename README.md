# Projeto de auditoria em base de dados Oracle

## Indice
1. [Contexto](#contexto)
1. [Processamento](#processamento)
1. [Execução](#execucao)
*******

<div id='contexto' />

## Contexto
Proposta inical de TCC de pós graduação em Engenharia e administração de banco de dados.

<div id='processamento' />

## Processamento
A execução do software visa a partir de uma métrica definida, definir pesos para campos em uma tabela que contem valores nulos.

Definido esses conceitos temos a busca dos registros da tabela em questão para avaliação. O processamento se dá avaliando um conjunto de registros, definido inicialmente de 50 em 50 registros por vez em uma estrutura de repetição, até que se acabe toda avaliação na tabela.

Serão somados os pontos e depois divididos pelo numero total de registros contido na tabela.

### Formula
    1 * peso para cada campo nulo no registro / pelo numero total de registros da tabela alvo

### Exemplo

Vamos definir que iremos intervir em tabelas no qual o resultado nos mostrar um numero de pontos maior que 6, quando avaliar os registros.

|Id|nome|Descrição|
|-|-|-|
|1|Teste 01|null|
|2|Teste 02|Testes
|3|null|null

Neste exemplo temos o seguinte resultado, levando em consideração que temos o peso sendo de valor 10:

|Registro|Pontuação|
|-|-|
|01|10 pontos|
|02|0 pontos|
|03|20 pontos|

    Logo calculamos: (10 + 0 + 20) / 3 = 10


<div id='execucao' />

## Execução

```sql
set serveroutput on;

declare
    --
    auditoria auditoria_de_tabela;
    --
begin
    --
    /*
        Aqui definimos o valor do peso para colunas do registro que contem valores nulos.
        Definição da tabela alvo da auditoria.
    */
    auditoria := auditoria_de_tabela(10, 'nome_da_tabela_desejada');
    auditoria.iniciar;
    --
end;
/
```