/*1. Crie uma tabela produtos com as colunas id, nome, preco, quantidade_estoque e data_cadastro. 
Use as restrições adequadas (chave primária, not null, etc.). */
CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    data_cadastro DATE NOT NULL
);


/*2. Adicione uma coluna descricao à tabela produtos.*/
ALTER TABLE produtos
ADD descricao TEXT;

/*3. Altere o tipo de dados da coluna preco para DECIMAL(8, 2).*/
ALTER TABLE produtos
MODIFY preco DECIMAL(8, 2);

/*4. Exclua a coluna quantidade_estoque da tabela produtos.*/
ALTER TABLE produtos
DROP COLUMN quantidade_estoque;

/*5. Exclua a tabela produtos.*/