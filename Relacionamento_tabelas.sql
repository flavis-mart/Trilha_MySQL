/*1. Chave Primária e Estrangeira: Crie duas tabelas chamadas clientes e pedidos. Configure:
○ id_cliente como chave primária na tabela clientes.
○ id_cliente como chave estrangeira na tabela pedidos, referenciando clientes. Qual a importância de definir essas chaves corretamente?*/
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATE NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Definir a Chave Primária (PK) garante que cada cliente seja único. 
-- A Chave Estrangeira (FK) cria o vínculo estrutural entre as tabelas, impedindo que um pedido seja registrado para um "id_cliente" que não existe.

/*2. Integridade Referencial: Configure a tabela pedidos para que a exclusão de um cliente também exclua automaticamente os pedidos associados 
(ON DELETE CASCADE). Explique como isso ajuda a manter a integridade dos dados.*/
CREATE TABLE pedidos_cascade (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

/*3. Tipos de Relacionamentos: Desenvolva um relacionamento 1:N entre clientes e pedidos. 
Insira 10 registros em cada tabela e demonstre como listar todos os pedidos de um cliente específico usando uma consulta SQL.*/
-- Inserindo Clientes
INSERT INTO clientes (nome) VALUES ('Ana'), ('Bruno'), ('Carlos'), ('Diana'), ('Edu'), ('Fernanda'), ('Gabi'), ('Hugo'), ('Igor'), ('Julia');

-- Inserindo Pedidos (10 pedidos distribuídos)
INSERT INTO pedidos (data_pedido, id_cliente) VALUES 
('2023-10-01', 1), ('2023-10-02', 1), ('2023-10-03', 2),
('2023-10-04', 3), ('2023-10-05', 4), ('2023-10-06', 5),
('2023-10-07', 6), ('2023-10-08', 7), ('2023-10-09', 8), ('2023-10-10', 9);

-- Consultar pedidos de um cliente específico (Ex: Ana, id_cliente = 1)
SELECT * FROM pedidos WHERE id_cliente = 1;

/*4. Relacionamento N:N: Crie as tabelas produtos, pedidos e a tabela intermediária pedido_produto. 
Insira registros nas tabelas e demonstre como listar todos os produtos de um pedido.*/
CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(50)
);

CREATE TABLE pedido_produto (
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Inserindo produtos e relacionamento
INSERT INTO produtos (nome_produto) VALUES ('Notebook'), ('Mouse');
INSERT INTO pedido_produto (id_pedido, id_produto, quantidade) VALUES (1, 1, 1), (1, 2, 2);

-- Listar produtos do pedido 1
SELECT p.nome_produto, pp.quantidade 
FROM produtos p
JOIN pedido_produto pp ON p.id_produto = pp.id_produto
WHERE pp.id_pedido = 1;

/*5. Consulta com JOIN: Realize uma consulta SQL para retornar os nomes dos clientes, os produtos comprados e a quantidade de cada 
produto em um pedido.*/
SELECT c.nome AS Cliente, pr.nome_produto AS Produto, pp.quantidade AS Qtd
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN pedido_produto pp ON p.id_pedido = pp.id_pedido
JOIN produtos pr ON pp.id_produto = pr.id_produto
WHERE p.id_pedido = 1;

/*6. Exclusão em Cascata: Demonstre o comportamento de uma exclusão em cascata na tabela clientes, excluindo um cliente e verificando se os pedidos
 relacionados foram removidos.*/
 DELETE FROM clientes WHERE id_cliente = 1;

/*7. Atualização em Cascata: Configure a tabela pedidos para que a alteração do id_cliente na tabela clientes atualize automaticamente 
os registros relacionados. Teste com um exemplo prático.*/
ALTER TABLE pedidos 
ADD CONSTRAINT fk_cliente 
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON UPDATE CASCADE;

-- Teste: Se mudarmos o ID do Bruno de 2 para 99.
UPDATE clientes SET id_cliente = 99 WHERE id_cliente = 2;
-- Os pedidos do Bruno agora estarão atrelados ao id_cliente 99 automaticamente.

/*8. Cardinalidades: Explique e configure exemplos práticos para os tipos de cardinalidades 1:1, 1:N e N:M, criando tabelas e inserindo registros.*/
-- Cardinalidade 1:1
-- Criação das Tabelas
CREATE TABLE pessoas (
    id_pessoa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE passaportes (
    id_passaporte INT PRIMARY KEY AUTO_INCREMENT,
    numero_passaporte VARCHAR(20) NOT NULL,
    id_pessoa INT UNIQUE, -- O 'UNIQUE' é o que transforma isso em 1:1
    FOREIGN KEY (id_pessoa) REFERENCES pessoas(id_pessoa)
);

-- Inserção de Dados
INSERT INTO pessoas (nome) VALUES ('Alice'), ('Beto');

-- Alice recebe o passaporte 1, Beto recebe o passaporte 2
INSERT INTO passaportes (numero_passaporte, id_pessoa) VALUES ('AB12345', 1);
INSERT INTO passaportes (numero_passaporte, id_pessoa) VALUES ('XY98765', 2);

-- Cardinalidade 1:N
-- Criação das Tabelas
CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nome_depto VARCHAR(50) NOT NULL
);

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    id_departamento INT, -- FK livre, sem UNIQUE (lado 'N')
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Inserção de Dados
INSERT INTO departamentos (nome_depto) VALUES ('TI'), ('RH');

-- Vários funcionários podem ser do mesmo departamento (Ex: TI = id 1)
INSERT INTO funcionarios (nome, id_departamento) VALUES 
('Carlos', 1),  -- TI
('Daniela', 1), -- TI
('Eduardo', 2); -- RH

-- Cardinalidade N:M
-- Criação das Tabelas Principais
CREATE TABLE alunos (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE disciplinas (
    id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
    nome_disciplina VARCHAR(100) NOT NULL
);

-- Criação da Tabela Intermediária
CREATE TABLE matriculas (
    id_aluno INT,
    id_disciplina INT,
    -- A chave primária aqui é composta pelas duas chaves estrangeiras juntas
    PRIMARY KEY (id_aluno, id_disciplina),
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_disciplina) REFERENCES disciplinas(id_disciplina)
);

-- Inserção de Dados nas tabelas principais
INSERT INTO alunos (nome) VALUES ('Felipe'), ('Gabriela');
INSERT INTO disciplinas (nome_disciplina) VALUES ('Banco de Dados'), ('Programação');

-- Inserção de Dados na tabela intermediária (fazendo os vínculos)
-- Felipe (1) cursa Banco de Dados (1) e Programação (2)
INSERT INTO matriculas (id_aluno, id_disciplina) VALUES (1, 1), (1, 2);

-- Gabriela (2) cursa apenas Programação (2)
INSERT INTO matriculas (id_aluno, id_disciplina) VALUES (2, 2);
/*9. Tabelas Intermediárias: Crie uma consulta para listar todos os pedidos contendo um produto específico 
usando a tabela intermediária pedido_produto.*/
-- Listar todos os pedidos que contêm o produto 2 (Mouse)
SELECT p.id_pedido, p.data_pedido
FROM pedidos p
JOIN pedido_produto pp ON p.id_pedido = pp.id_pedido
WHERE pp.id_produto = 2;

/*10. Boas Práticas em Relacionamentos: Analise um banco de dados existente (pode ser fictício) e identifique como os 
relacionamentos foram estruturados. Proponha melhorias para garantir integridade e eficiência.*/
-- Analisando um e-commerce fictício mal estruturado onde o "Nome do Cliente" e o "Endereço" ficam salvos na tabela de "Pedidos":
-- Melhoria 1 (Normalização): Extrair Cliente e Endereço para uma tabela clientes, deixando apenas o id_cliente no pedido.
-- Melhoria 2 (Índices): Criar INDEX nas colunas de chaves estrangeiras para que os JOINs sejam muito mais rápidos.
-- Melhoria 3 (Tipagem): Garantir que a PK na tabela de origem tenha exatamente o mesmo tipo de dado da FK na tabela de destino (ex: ambos INT ou ambos BIGINT).