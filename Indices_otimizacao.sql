Questões Práticas

/*1. Criação de Índices: Crie um índice básico na coluna nome da tabela clientes e explique como esse índice 
pode melhorar a performance em uma consulta SELECT.*/
CREATE INDEX idx_cliente_nome ON clientes(nome);

-- O índice cria uma estrutura de dados à parte (geralmente uma Árvore-B / B-Tree) que mantém os nomes ordenados e aponta para as linhas originais 
-- na tabela. Em um SELECT * FROM clientes WHERE nome = 'Ana', 
-- em vez de ler a tabela inteira linha por linha, o banco vai direto na letra "A" do índice e encontra a Ana quase instantaneamente.

/*2. Índice Único: Crie um índice único na coluna email da tabela clientes para garantir que não existam emails duplicados. 
Explique a importância desse índice para a integridade dos dados.*/
CREATE UNIQUE INDEX idx_cliente_email ON clientes(email);

-- O UNIQUE INDEX acelera as buscas pelo e-mail (assim como um índice comum) e impõe uma restrição de integridade.
-- O banco de dados bloqueará qualquer comando INSERT ou UPDATE que tente inserir um e-mail que já existe, evitando duplicidades.

/*3. Índices Compostos: Crie um índice composto nas colunas nome e cidade da tabela clientes. 
Em seguida, explique como esse índice pode otimizar uma consulta que filtra clientes por nome e cidade simultaneamente.*/
CREATE INDEX idx_cliente_nome_cidade ON clientes(nome, cidade);

-- O banco consegue filtrar pelas duas condições simultaneamente navegando por uma única estrutura de índice, o que é muito mais rápido do
-- que usar um índice só para o nome e depois escanear os resultados na memória para achar a cidade.

/*4. Análise de Performance com EXPLAIN: Execute o comando EXPLAIN em uma consulta que utiliza um JOIN entre as tabelas clientes e pedidos. 
Interprete os seguintes campos da saída: type, key, rows e Extra.*/
EXPLAIN SELECT c.nome, p.valor 
FROM clientes c 
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- Interpretação da saída:
-- type: Mostra como o MySQL encontrou as linhas (ex: ALL = Full Table Scan; index = leu a árvore de índice inteira; 
-- ref ou eq_ref = usou o índice perfeitamente para achar a chave ).
-- key: Mostra qual índice o banco de dados efetivamente escolheu usar para aquela tabela. Se for NULL, nenhum índice foi usado.
-- rows: Uma estimativa de quantas linhas o banco precisou ler e examinar para entregar o resultado. Quanto menor, melhor.

/*5. Uso de Índices em JOINs: Crie um índice na coluna id_cliente da tabela pedidos e demonstre como ele melhora a performance de 
uma consulta que realiza um JOIN entre clientes e pedidos.*/
CREATE INDEX idx_pedido_cliente ON pedidos(id_cliente);

-- Sem esse índice, para cada cliente, o banco leria a tabela de pedidos inteira procurando coincidências. 
-- Com o índice na Chave Estrangeira, ele acha os pedidos daquele cliente em frações de segundo.

/*6. Evitar Full Table Scans: Crie um índice na coluna nome da tabela clientes e compare o plano de execução de uma 
consulta SELECT com e sem índice.*/
-- Consulta
EXPLAIN SELECT * FROM clientes WHERE nome = 'Carlos';

-- Sem o índice: A coluna type no EXPLAIN seria ALL (Full Table Scan). 
-- Se a tabela tivesse 1 milhão de clientes, a coluna rows mostraria ~1.000.000. O banco leu tudo.
-- Com o índice: A coluna type será ref e a key será idx_cliente_nome. 
-- A coluna rows mostrará apenas o número exato de pessoas chamadas Carlos.

/*7. Limitação de Registros com LIMIT: Execute uma consulta que retorne apenas os 5 primeiros clientes da tabela clientes, ordenados por nome. 
Explique como o uso de LIMIT pode melhorar a performance.*/
SELECT * FROM clientes 
ORDER BY nome ASC 
LIMIT 5;

-- O LIMIT diz ao banco de dados: "Assim que você encontrar os primeiros 5 resultados válidos, pare tudo". 
-- Isso economiza tempo de processamento da CPU, consumo de memória RAM do servidor e banda de rede, enviando apenas 5 linhas.

/*8. Evitar Operações em Colunas: Otimize uma consulta que filtra clientes usando UPPER(nome) para evitar operações que 
impeçam o uso de índices. Explique a mudança feita.*/
SELECT * FROM clientes WHERE UPPER(nome) = 'MARIA';

-- otimização
SELECT * FROM clientes WHERE nome = 'Maria';

--  A consulta otimizada permite que o banco vá direto ao índice.

/*9. Criação de Índices Apropriados: Crie índices nas colunas categoria e preco da tabela produtos. 
Explique como esses índices podem melhorar consultas que envolvem filtros nessas colunas.*/
CREATE INDEX idx_produto_categoria ON produtos(categoria);
CREATE INDEX idx_produto_preco ON produtos(preco);

-- O idx_produto_categoria otimiza buscas exatas de agrupamento.
-- O idx_produto_preco é essencial para filtros de intervalo.

/*10. Identificação de Gargalos com EXPLAIN: Analise uma consulta complexa utilizando EXPLAIN, 
identifique possíveis gargalos no desempenho e proponha melhorias usando índices ou reestruturação da consulta.*/
EXPLAIN SELECT categoria, COUNT(*) 
FROM produtos 
WHERE data_cadastro > '2023-01-01' 
GROUP BY categoria;

-- Possíveis gargalos e melhorias:

-- O erro é usar datas em aberto (como >). A solução é sempre delimitar o filtro usando BETWEEN, 
-- garantindo que o sistema leia apenas o intervalo exato de tempo que você precisa.
-- O erro é deixar milhões de registros de vários anos acumulados em uma única estrutura física de tabela, deixando qualquer busca lenta.
-- A solução é usar o Particionamento de Tabela (dividi-la por anos nos bastidores) para que o banco consulte apenas a "gaveta" do ano relevante.

