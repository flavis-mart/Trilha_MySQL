Questões Práticas
/* Manipulação de Strings:
Crie uma consulta que utilize a função CONCAT para gerar um identificador único combinando o nome e o ID de um cliente. */
SELECT CONCAT(nome, ' - ', id_cliente) AS identificador_unico 
FROM clientes;
/* Função SUBSTRING:
Extraia os três primeiros caracteres do nome de um produto na tabela produtos. */
SELECT SUBSTRING(nome_produto, 1, 3) AS tres_primeiros_caracteres 
FROM produtos;
/* Uso de LOWER e UPPER:
Converta todos os nomes de clientes para letras maiúsculas em uma consulta SQL. */
SELECT UPPER(nome) AS nome_maiusculo 
FROM clientes;
/* Funções de Data e Hora:
Escreva uma consulta que utilize NOW para exibir a data e hora atuais, formatando a saída para o formato DD/MM/AAAA HH:MM:SS com DATE_FORMAT. */
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y %H:%i:%s') AS data_hora_atual;
/* Diferença de Datas:
Calcule o número de dias entre a data de hoje e a data de um pedido na tabela pedidos usando a função DATEDIFF. */
SELECT id_pedido, DATEDIFF(CURDATE(), data_pedido) AS dias_passados 
FROM pedidos;
/* Arredondamento:
Arredonde o valor de um campo de preço para duas casas decimais usando a função ROUND. */
SELECT ROUND(preco, 2) AS preco_arredondado 
FROM produtos;
/* Arredondar para Cima/Para Baixo:
Use FLOOR para arredondar para baixo e CEIL para arredondar para cima o valor de um campo de total de vendas. */
SELECT 
    total_vendas, 
    FLOOR(total_vendas) AS arredondado_baixo, 
    CEIL(total_vendas) AS arredondado_cima 
FROM vendas;
/* Criação de Procedimentos Armazenados:
Crie um procedimento armazenado que insira um novo pedido na tabela pedidos, recebendo como entrada o ID do cliente e a data do pedido. */
DELIMITER //

CREATE PROCEDURE InserirPedido(IN p_id_cliente INT, IN p_data_pedido DATE)
BEGIN
    INSERT INTO pedidos (id_cliente, data_pedido) 
    VALUES (p_id_cliente, p_data_pedido);
END //

DELIMITER ;
/* Execução de Procedimentos Armazenados:
Execute o procedimento criado no exercício anterior para adicionar um pedido com seus parâmetros. */
CALL InserirPedido(1, '2026-05-05');
/* Criação de Funções Definidas pelo Usuário (UDFs):
Crie uma função que calcule o valor total de um pedido aplicando um desconto percentual e use-a em uma consulta. */
DELIMITER //

CREATE FUNCTION CalcularDesconto(valor_total DECIMAL(10,2), percentual DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE valor_com_desconto DECIMAL(10,2);
    SET valor_com_desconto = valor_total - (valor_total * (percentual / 100));
    RETURN valor_com_desconto;
END //

DELIMITER ;

-- Como usar a função em uma consulta:
SELECT id_pedido, CalcularDesconto(valor, 10) AS valor_final 
FROM pedidos;

Questões Teóricas
/* Definição de Funções:
O que são funções no MySQL e quais os tipos mais comuns? */
-- Funções são blocos de código pré-programados que recebem um dado, 
-- fazem uma operação e retornam um resultado imediatamente. Os tipos mais comuns são:
-- Strings: Manipulam textos (ex: CONCAT, UPPER, SUBSTRING).
-- Numéricas/Matemáticas: Fazem cálculos (ex: ROUND, ABS, SQRT).
-- Data/Hora: Manipulam tempo (ex: NOW, DATEDIFF, YEAR).
-- Agregação: Resumem vários registros (ex: SUM, COUNT, AVG).

/* Função CONCAT:
Explique como a função CONCAT pode ser usada para manipular dados em relatórios. */
-- Ela é excelente para formatar a visualização dos dados para o usuário final sem alterar a estrutura da tabela. 
-- Por exemplo, em vez de mostrar duas colunas separadas para nome e sobrenome, 
-- você pode usar CONCAT(nome, ' ', sobrenome) para o relatório exibir uma coluna elegante chamada "Nome Completo". 
-- Também é útil para montar endereços completos com rua, número e cidade em uma única string.

/* Funções de Data e Hora:
Qual a diferença entre NOW e CURDATE? Cite exemplos de suas aplicações. */
-- NOW(): Retorna a data e a hora exatas do momento (ex: 2026-05-05 20:27:32). 
-- Usado para carimbos de tempo precisos, como registrar a hora exata que um cliente finalizou uma compra.

-- CURDATE(): Retorna apenas a data atual (ex: 2026-05-05). 
-- Usado quando a hora não importa, como para verificar aniversariantes do dia ou filtrar vendas diárias.

/* Arredondamento:
Qual é a diferença entre as funções ROUND, FLOOR e CEIL? Em que situações cada uma é mais adequada? */
-- ROUND: Arredonda para o número mais próximo pelas regras matemáticas convencionais (0.5 sobe, 0.4 desce). 
-- Ideal para cálculos financeiros e preços.

-- FLOOR (Chão): Força o arredondamento sempre para baixo, ignorando os decimais. 
-- Ideal para calcular idades (se a pessoa tem 20.9 anos, ela tem 20 anos, não 21).

-- CEIL (Teto): Força o arredondamento sempre para cima. 
-- Ideal para paginação em sistemas (se você tem 10.1 páginas de produtos, você precisa criar 11 páginas inteiras para mostrar tudo).

/* Vantagens dos Procedimentos Armazenados:
Liste três vantagens de usar procedimentos armazenados em um banco de dados MySQL. */
-- Reutilização e Padronização: A lógica de negócio fica salva no banco. 
-- Qualquer sistema (um site em PHP, um app em Python) pode simplesmente chamar a Procedure, garantindo que a regra seja igual para todos.

-- Segurança: Você pode dar permissão para um usuário apenas rodar a Procedure (EXECUTE), mas não dar permissão para ele apagar tabelas diretamente. 
-- Também previne ataques de SQL Injection.

-- Performance e Redução de Tráfego: Como o código já está no servidor, 
-- você não precisa enviar centenas de linhas de código SQL pela rede toda vez. Basta enviar o comando CALL.

/* Parâmetros de Procedimentos:
Qual a diferença entre os tipos de parâmetros IN, OUT e INOUT em procedimentos armazenados? */
-- IN (Entrada): O valor é passado para dentro da procedure. Ela pode ler o valor, mas não pode alterá-lo e devolvê-lo (é o padrão).

-- -OUT (Saída): A procedure devolve um valor para fora. Você passa uma variável vazia, e a procedure a preenche com um resultado.

-- INOUT (Entrada e Saída): Faz as duas coisas. Você envia um valor inicial, a procedure o processa/altera e devolve a mesma variável modificada.

/* Execução de Procedimentos:
Qual comando é usado para executar um procedimento armazenado e como ele funciona? */
-- É usado o comando CALL seguido do nome do procedimento e seus parâmetros entre parênteses. Exemplo: CALL FecharPedido(123). 
-- Ele diz ao motor do banco de dados para localizar aquele bloco de código salvo na memória e executá-lo com as variáveis fornecidas.

/* Funções Definidas pelo Usuário (UDFs):
O que são UDFs e como elas diferem de procedimentos armazenados? */
-- UDFs (User-Defined Functions) são funções personalizadas criadas por você. A diferença principal é o comportamento: 
-- uma UDF obrigatoriamente deve retornar um único valor e pode ser usada livremente no meio de instruções SQL normais (como SELECT ou WHERE). 
-- Já a Procedure não precisa retornar nada (pode apenas dar um INSERT e finalizar) e não pode ser embutida dentro de um SELECT.

/* Aplicações de Funções Personalizadas:
Explique uma situação prática onde a criação de uma função definida pelo usuário seria mais vantajosa do que o uso de uma função padrão. */
-- Situações onde o banco não tem uma função nativa para sua necessidade local. Por exemplo: criar uma UDF 
-- chamada CalcularImpostoBR(valor) que embute toda a complexidade de alíquotas do Brasil, ou uma função FormatarCPF(numero) 
-- que pega 11 dígitos no banco e os devolve no formato visual 000.000.000-00 diretamente na consulta do relatório.

/* Funções e Procedimentos:
Compare as funções e os procedimentos armazenados em termos de retorno de valores e uso em consultas. */
-- Retorno: Funções precisam ter a cláusula RETURN e devolver exatamente um valor (como um número ou string). 
-- Procedimentos não usam RETURN de valor único; eles apenas terminam a execução ou devolvem variáveis através do parâmetro OUT.

-- Uso em Consultas: Funções podem ser usadas inline em consultas (ex: SELECT nome, MinhaFuncao(salario) FROM tabela). 
-- Procedimentos não podem. Eles devem ser chamados sozinhos através do comando CALL MeuProcedimento().