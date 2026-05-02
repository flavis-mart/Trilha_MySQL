/*1. INNER JOIN (1 ponto) Crie uma consulta que liste o nome dos clientes e os valores dos pedidos realizados, 
exibindo apenas aqueles que possuem pedidos registrados.*/
SELECT clientes.nome, pedidos.valor
FROM clientes
INNER JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;

/*2. LEFT JOIN (1 ponto) Escreva uma consulta que liste todos os clientes e os valores de seus pedidos. 
Caso o cliente não tenha realizado pedidos, exiba NULL na coluna do valor total.*/
SELECT clientes.nome, pedidos.valor
FROM clientes
LEFT JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;

/*3. RIGHT JOIN (1 ponto) Crie uma consulta para listar todos os pedidos e os nomes dos clientes que os realizaram. 
Se o pedido não estiver associado a um cliente, exiba NULL na coluna do nome do cliente.*/
SELECT pedidos.id_pedido, pedidos.valor, clientes.nome
FROM clientes
RIGHT JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;

/*4. FULL OUTER JOIN (1 ponto) Emule um FULL OUTER JOIN utilizando UNION, para exibir todos os clientes e pedidos, 
mesmo que não possuam correspondência.*/
SELECT clientes.nome, pedidos.valor
FROM clientes
LEFT JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente

UNION

SELECT clientes.nome, pedidos.valor
FROM clientes
RIGHT JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;

/*5. Subconsulta Simples em SELECT (1 ponto) Escreva uma consulta que recupere o nome do cliente que realizou o pedido de maior valor.*/
SELECT nome 
FROM clientes 
WHERE id_cliente = (
    SELECT id_cliente 
    FROM pedidos 
    ORDER BY valor DESC 
    LIMIT 1
);

/*6. Subconsulta Simples em INSERT (1 ponto) Adicione um novo pedido para o cliente que possui o pedido de maior valor. 
Utilize uma subconsulta para encontrar o cliente.*/
INSERT INTO pedidos (id_cliente, valor)
VALUES (
    (SELECT id_cliente FROM pedidos ORDER BY valor DESC LIMIT 1), 
    150.00
);

/*7. Subconsulta Correlacionada (1 ponto) Liste os nomes dos clientes e o total de valores de seus pedidos 
utilizando uma subconsulta correlacionada.*/
SELECT clientes.nome,
       (SELECT SUM(valor) 
        FROM pedidos 
        WHERE pedidos.id_cliente = clientes.id_cliente) AS total_pedidos
FROM clientes;

/*8. Função de Agregação COUNT (1 ponto) Crie uma consulta que conte o número total de pedidos realizados.*/
SELECT COUNT(*) AS total_de_pedidos 
FROM pedidos;

/*9. Função de Agregação com GROUP BY (1 ponto) Liste o total de vendas por cliente (nome e total vendido).*/
SELECT clientes.nome, SUM(pedidos.valor) AS total_vendido
FROM clientes
INNER JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
GROUP BY clientes.id_cliente, clientes.nome;

/*10. Função de Agregação com GROUP BY e HAVING (1 ponto) Liste os clientes que realizaram vendas superiores a 200, exibindo o nome do 
cliente e o total vendido.*/
SELECT clientes.nome, SUM(pedidos.valor) AS total_vendido
FROM clientes
INNER JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
GROUP BY clientes.id_cliente, clientes.nome
HAVING SUM(pedidos.valor) > 200;

Questões Teóricas

/*1. (1 ponto) Explique o que é um INNER JOIN e cite um exemplo prático onde ele seria utilizado.*/
-- O INNER JOIN é um comando utilizado para combinar linhas de duas ou mais tabelas, retornando apenas os registros que possuem correspondência em ambas. 
-- Se houver um registro em uma tabela que não tem um par correspondente na outra, ele é descartado do resultado.
SELECT clientes.nome, pedidos.valor
FROM clientes
INNER JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;

/*2. (1 ponto) Qual a diferença entre LEFT JOIN e RIGHT JOIN? Cite um exemplo prático para cada um.*/
-- A diferença principal está em qual tabela é considerada a "principal" (aquela da qual todos os dados serão trazidos).
-- LEFT JOIN: Retorna todos os registros da tabela da esquerda (a primeira declarada) e os correspondentes da tabela da direita. 
-- Se não houver correspondência, preenche com NULL.
-- RIGHT JOIN: O exato oposto. Retorna todos os registros da tabela da direita e os correspondentes da esquerda.

/*3. (1 ponto) Explique como o FULL OUTER JOIN pode ser emulado no MySQL. Por que ele não é nativo?*/
-- Como emular: Você o recria unindo o resultado de um LEFT JOIN com o de um RIGHT JOIN utilizando o operador UNION.
-- Por que não é nativo? É uma decisão arquitetural dos desenvolvedores do MySQL desde os primórdios. Como o uso de UNION resolve o 
--mproblema de forma eficaz e atende ao padrão SQL, a equipe do MySQL priorizou a otimização de outras áreas do motor 
-- de banco de dados em vez de implementar um comando específico para isso.

/*4. (1 ponto) O que são subconsultas simples? Dê um exemplo onde uma subconsulta seria mais eficiente do que um JOIN.*/
-- Uma subconsulta simples (ou aninhada) é uma consulta SELECT que fica dentro de outra consulta principal.
-- É mais eficiente ou prática que um JOIN quando você precisa apenas de um valor, sem precisar mesclar as colunas das tabelas.

/*5. (1 ponto) Qual a diferença entre uma subconsulta simples e uma subconsulta correlacionada?*/
-- Simples: É independente da consulta externa. O banco de dados a executa uma única vez, pega o resultado e o utiliza na consulta de fora.
-- Correlacionada: Depende de informações da consulta externa. O banco de dados precisa executá-la repetidas vezes (uma vez para cada 
-- linha que está sendo processada pela consulta principal), o que a torna muito mais pesada em termos de processamento.

/*6. (1 ponto) Explique o conceito de funções de agregação e liste as mais utilizadas no MySQL.*/
-- Funções de agregação pegam um conjunto de valores (várias linhas) e realizam um cálculo para retornar um único valor resumido.
-- As mais utilizadas são
-- COUNT(): Conta o número de linhas/registros.
-- SUM(): Soma os valores de uma coluna numérica.
-- AVG(): Calcula a média dos valores.
-- MAX(): Retorna o maior valor.
-- MIN(): Retorna o menor valor.

/*7. (1 ponto) Qual a função do GROUP BY em uma consulta SQL? Em quais casos ele deve ser utilizado?*/
-- O GROUP BY serve para agrupar linhas que possuem os mesmos valores em colunas específicas. 
-- Ele transforma múltiplos registros de uma mesma categoria em uma única linha de resumo.

/*8. (1 ponto) O que é a cláusula HAVING? Como ela difere da cláusula WHERE?*/
-- WHERE: Filtra as linhas brutas antes de qualquer agrupamento ser feito.
-- HAVING: Filtra os grupos depois que o GROUP BY e as funções de agregação já foram calculados.

/*9. (1 ponto) Cite dois cenários práticos onde você utilizaria a combinação de GROUP BY e funções de agregação.*/
-- Fechamento de Caixa: Somar o total faturado por cada método de pagamento no dia agrupado por metodo_pagamento).
-- Análise de RH: Contar quantos funcionários ativos existem em cada setor da empresa agrupado por departamento).

/*10. (1 ponto) Explique a importância dos JOINs em bancos de dados relacionais. Como eles contribuem para evitar 
redundâncias e promover eficiência?*/
-- Ele promove a eficiência porque permite que o banco armazene os dados ocupando o mínimo de espaço e 
-- garanta a integridade, mas ainda consiga entregar relatórios completos para o usuário final.