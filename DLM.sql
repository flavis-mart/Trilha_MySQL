/*Crie uma tabela chamada funcionarios com as colunas: id_funcionario (INT, chave primária), nome (VARCHAR), email (VARCHAR) e cargo (VARCHAR).*/

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cargo VARCHAR(50)
);

/*Insira três registros nesta tabela usando o comando INSERT INTO.*/
INSERT INTO funcionarios (id_funcionario, nome, email, cargo) 
VALUES 
(1, 'Ana Silva', 'ana@empresa.com', 'Analista'),
(2, 'João Souza', 'joao@empresa.com', 'Desenvolvedor'),
(3, 'Maria Oliveira', 'maria@empresa.com', 'Gerente');

/*Na tabela funcionarios, insira de uma só vez cinco registros adicionais com dados fictícios.*/
INSERT INTO funcionarios (id_funcionario, nome, email, cargo) 
VALUES 
(4, 'Carlos Santos', 'carlos@empresa.com', 'Analista'),
(5, 'Fernanda Lima', 'fernanda@empresa.com', 'Designer'),
(6, 'Pedro Alves', 'pedro@empresa.com', 'Desenvolvedor'),
(7, 'Lucas Mendes', 'lucas@empresa.com', 'Suporte'),
(8, 'Juliana Costa', 'juliana@empresa.com', 'Analista');

/*Adicione uma coluna cidade à tabela funcionarios com o valor padrão "Não Informado".*/
ALTER TABLE funcionarios 
ADD cidade VARCHAR(100) DEFAULT 'Não Informado';

/*Insira um registro omitindo o valor da coluna cidade e verifique o resultado.*/
INSERT INTO funcionarios (id_funcionario, nome, email, cargo) 
VALUES (9, 'Roberto Dias', 'roberto@empresa.com', 'Assistente');

/*Crie uma consulta para selecionar todos os funcionários cujo cargo seja "Analista".*/
SELECT * FROM funcionarios 
WHERE cargo = 'Analista';

/*Liste todos os funcionários ordenados por nome em ordem alfabética.*/
SELECT * FROM funcionarios 
ORDER BY nome ASC;

/*Exiba os três primeiros registros da tabela funcionarios.*/
SELECT * FROM funcionarios 
LIMIT 3;

/*Liste todas as cidades únicas presentes na tabela funcionarios.*/
SELECT DISTINCT cidade 
FROM funcionarios;

/*Agrupe os funcionários por cargo e conte quantos funcionários existem em cada cargo.*/
SELECT cargo, COUNT(*) AS total_funcionarios 
FROM funcionarios 
GROUP BY cargo;

/*Atualize o cargo de todos os funcionários com o nome "João" para "Coordenador".*/
UPDATE funcionarios 
SET cargo = 'Coordenador' 
WHERE nome = 'João';

/*Remova todos os funcionários que tenham "Analista" como cargo.*/
DELETE FROM funcionarios 
WHERE cargo = 'Analista';


Questões Teóricas

1. Explique a diferença entre INSERT INTO e UPDATE. Em que situações cada um deve ser usado?
-- INSERT INTO: Cria novos registros (linhas) em uma tabela. Usado quando um novo dado precisa ser cadastrado
-- UPDATE: Modifica registros que já existem na tabela.
2. Qual a função do comando DELETE e como ele se diferencia do comando TRUNCATE?
-- O DELETE é usado para remover linhas específicas de uma tabela. 
-- O TRUNCATE é um comando de estrutura que "esvazia" a tabela inteira de uma vez de forma muito mais rápida.
3. Por que é importante usar a cláusula WHERE em comandos como UPDATE e DELETE?
-- Se você rodar um UPDATE ou DELETE sem o WHERE, o comando será aplicado a todas as linhas da tabela. 
-- Você pode atualizar todos os dados para um mesmo valor acidentalmente ou apagar o banco de dados inteiro.
4. Descreva a utilidade da cláusula ORDER BY e como ela pode ser aplicada em consultas.
-- ORDER BY serve para organizar os resultados de uma consulta de forma ascendente ou descendente. 
-- É útil para exibir dados em ordem alfabética, cronológica ou de grandeza.
5. O que significa a palavra-chave DEFAULT no contexto de inserção de dados? Dê um exemplo de uso.
-- DEFAULT define um valor padrão que será automaticamente preenchido em uma coluna caso o usuário não informe nenhum valor no momento do INSERT.
6. Qual a finalidade da cláusula DISTINCT e em que situações ela é útil?
-- O DISTINCT remove resultados duplicados de uma consulta, retornando apenas valores únicos.
7. Explique como a cláusula GROUP BY funciona e cite um exemplo prático de sua aplicação.
-- O GROUP BY agrupa linhas que têm os mesmos valores em determinadas colunas.
8. Qual é o impacto de não usar índices no banco de dados durante consultas que utilizam filtros (WHERE)?
-- Sem índices, o banco de dados precisa fazer um Full Table Scan. Ele lê linha por linha da tabela inteira para encontrar a informação filtrada. 
-- Em tabelas com muitos registros, a consulta ficará extremamente lenta e consumirá muito processamento.
9. Cite dois operadores de comparação e dois operadores lógicos em SQL, explicando como funcionam.
-- =: Verifica se um valor é exatamente igual ao outro (ex: idade = 30).
-- >: Verifica se o valor da esquerda é maior que o da direita (ex: preco > 100).
-- AND: Exige que múltiplas condições sejam verdadeiras ao mesmo tempo (ex: cargo = 'Analista' AND cidade = 'São Paulo').
-- OR: Exige que apenas uma das condições seja verdadeira (ex: cargo = 'Gerente' OR cargo = 'Diretor').
10. Qual a diferença entre HAVING e WHERE? Por que o HAVING é usado em conjunto com o GROUP BY?
-- O WHERE filtra as linhas antes de qualquer agrupamento ser feito.
-- O HAVING filtra os grupos depois que o GROUP BY já os formou e calculou as funções de agregação.