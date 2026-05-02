
Questões Práticas

/* 1. Criação de um Trigger BEFORE: Crie um trigger que valide, antes de inserir um pedido na tabela pedidos, 
se a quantidade solicitada de um produto é menor ou igual ao estoque disponível. */

CREATE TRIGGER trg_valida_estoque
BEFORE INSERT ON pedido_produto
FOR EACH ROW

    DECLARE v_estoque INT;
    
    SELECT quantidade_estoque INTO v_estoque 
    FROM produtos 
    WHERE id_produto = NEW.id_produto;
    
    IF NEW.quantidade > v_estoque THEN
        SIGNAL STATE '45000' 
        SET MESSAGE_TEXT = 'Erro: Quantidade solicitada é maior que o estoque disponível.';
     IF;


/* 2. Criação de um Trigger AFTER: Desenvolva um trigger que atualize o estoque na tabela produtos sempre que um novo pedido for registrado na 
tabela pedido_produto. */


CREATE TRIGGER trg_atualiza_estoque
AFTER INSERT ON pedido_produto
FOR EACH ROW

    UPDATE produtos 
    SET quantidade_estoque = quantidade_estoque - NEW.quantidade
    WHERE id_produto = NEW.id_produto;


/* 3. Registro de Logs: Crie um trigger que registre em uma tabela log_acoes toda vez que um registro for excluído da tabela clientes. 
O log deve incluir a data/hora e a identificação do cliente excluído. */

CREATE TRIGGER trg_log_exclusao_cliente
AFTER DELETE ON clientes
FOR EACH ROW

    INSERT INTO log_acoes (acao, id_cliente_afetado, data_hora)
    VALUES ('Exclusão', OLD.id_cliente, NOW());

/* 4. Exclusão de um Trigger: Exclua o trigger que registra exclusões de clientes na tabela log_acoes. */

DROP TRIGGER IF EXISTS trg_log_exclusao_cliente;

/* 5. Limpeza Automática com Eventos: Crie um evento que limpe registros da tabela log_acoes que tenham mais de 60 dias, 
executado diariamente às 23h59. */

CREATE EVENT ev_limpeza_logs
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 23 HOUR + INTERVAL 59 MINUTE)
DO
    DELETE FROM log_acoes 
    WHERE data_hora < NOW() - INTERVAL 60 DAY;

/* 6. Geração Automática de Relatórios: Configure um evento que gere relatórios mensais de vas, 
inserindo informações na tabela relatorios todo dia 1º de cada mês, à meia-noite. */

CREATE EVENT ev_relatorio_mensal
ON SCHEDULE EVERY 1 MONTH
STARTS '2026-06-01 00:00:00'
DO
    INSERT INTO relatorios (mes_referencia, total_vas)
    SELECT CURRENT_DATE, SUM(valor_total) 
    FROM pedidos 
    WHERE MONTH(data_pedido) = MONTH(NOW() - INTERVAL 1 MONTH);

/* 7. Ativação do Agador de Eventos: Ative o agador de eventos no My e verifique se ele está funcionando corretamente. */

SET GLOBAL event_scheduler = ON;

SHOW VARIABLES LIKE 'event_scheduler';

/* 8. Modificação de um Trigger Existente: Altere um trigger existente para incluir a validação de um novo campo antes de realizar a inserção. */

DROP TRIGGER IF EXISTS trg_valida_estoque;

CREATE TRIGGER trg_valida_estoque
BEFORE INSERT ON pedido_produto
FOR EACH ROW

    DECLARE v_estoque INT;
    
    SELECT quantidade_estoque INTO v_estoque FROM produtos WHERE id_produto = NEW.id_produto;
    
    IF NEW.quantidade > v_estoque THEN
        SIGNAL STATE '45000' SET MESSAGE_TEXT = 'Erro: Estoque insuficiente.';
     IF;

    IF NEW.valor_unitario <= 0 THEN
        SIGNAL STATE '45000' SET MESSAGE_TEXT = 'Erro: Valor unitário deve ser maior que zero.';
     IF;

/* 9. Teste de Performance de um Trigger: 
Execute um teste de performance em um trigger que é acionado frequentemente. Proponha melhorias para otimizar sua execução. */

-- Para testar a performance, faríamos uma inserção em massa e analisaríamos o tempo.
-- INSERT INTO pedido_produto (id_pedido, id_produto, quantidade) VALUES (...), (...), (...);

/* Propostas de melhoria (texto):
1. Otimizar as consultas internas do trigger garantindo que a coluna usada no WHERE (ex: id_produto) tenha um ÍNDICE (Primary Key ou Index).
2. Evitar usar JOINs complexos ou subconsultas pesadas dentro do corpo do trigger.
3. Se o trigger faz muitos cálculos, considerar mover essa lógica para a aplicação (código back) em vez de onerar o banco a cada inserção. */

/* 10. Documentação de um Evento: Documente detalhadamente um evento que gere relatórios automáticos, explicando sua finalidade, 
comportamento esperado e benefícios para o sistema. */

-- DOCUMENTAÇÃO DO EVENTO: ev_relatorio_mensal
-- Finalidade: Automatizar a consolidação do faturamento do mês anterior, sem necessidade de intervenção humana.
-- Comportamento: Roda automaticamente no dia 1º de cada mês, exatamente às 00:00. Ele calcula a soma das vas (`valor_total`) 
-- de todos os pedidos realizados no mês anterior e insere uma nova linha na tabela `relatorios`.
-- Benefícios: Alivia a carga do servidor durante o dia, pois o cálculo pesado é feito de madrugada. 
-- Além disso, garante que a diretoria sempre tenha o relatório fechado logo na manhã do primeiro dia útil, mitigando falhas de esquecimento por parte da equipe.

Questões Teóricas

/* Conceito de Triggers: Explique o que são triggers no My e cite pelo menos duas vantagens do seu uso. */
-- Triggers (Gatilhos) são blocos de código  que o banco de dados executa automaticamente quando um evento específico ocorre 
-- em uma tabela (INSERT, UPDATE ou DELETE).
-- Vantagem 1: Garantia de Integridade. O trigger roda no nível do banco, então mesmo que uma aplicação tenha um bug e tente 
-- inserir algo errado, o trigger barra.
-- Vantagem 2: Automação de tarefas. Permite automatizar registros de log ou atualizações de estoque sem precisar escrever 
-- códigos adicionais na aplicação.

/* Tipos de Triggers: Qual a diferença entre triggers BEFORE e AFTER? Cite exemplos de situações em que cada um seria utilizado. */
-- Triggers BEFORE são executados antes da operação ser gravada no disco. Exemplo: Validar se um salário é negativo antes de 
-- aceitar o cadastro de um funcionário, abortando a ação se for inválido.
-- Triggers AFTER são executados logo após a operação ser gravada no disco. Exemplo: Inserir uma linha em uma tabela de 
-- auditoria (log) dizo "O usuário X foi excluído", ou seja, só registra a auditoria se a exclusão realmente funcionou.

/* Vantagens dos Eventos: Liste três vantagens de usar eventos no My em vez de cron jobs externos. */
-- 1. Os eventos rodam nativamente dentro do servidor My, não depo do sistema operacional (Linux/Windows) para funcionar.
-- 2. Eles têm acesso direto e imediato às tabelas, o que torna a execução de comandos  mais rápida e segura do que um 
-- script externo fazo conexão com o banco.
-- 3. Ficam salvos no backup do próprio banco de dados, facilitando a migração de servidor sem esquecer de reconfigurar 
-- scripts de agamento (cron) no SO novo.

/* Validação com Triggers: Como um trigger pode ser usado para validar dados antes de uma operação ser realizada? 
Explique com um exemplo teórico. */
-- O trigger BEFORE pode inspecionar os dados recebidos usando a palavra-chave NEW. Se o dado não passar na regra, 
-- ele emite um erro (SIGNAL STATE) que cancela a transação inteira.
-- Exemplo: Um cliente não pode ter idade menor que 18 anos. O trigger BEFORE INSERT verifica `IF NEW.idade < 18`. 
-- Se for verdadeiro, ele lança um erro e o cliente não é cadastrado.

/* Impacto de Triggers na Performance: Quais são os cuidados a serem tomados ao criar triggers para evitar impactos 
negativos na performance do banco de dados? */
-- Triggers rodam linha por linha (FOR EACH ROW). Se você fizer um UPDATE em 10.000 registros, o trigger será disparado 10.000 vezes. 
-- O principal cuidado é evitar colocar lógicas pesadas, loops ou SELECTs complexos (sem índice) dentro deles. 
-- Um trigger lento atrasará todas as inserções e atualizações da tabela, criando gargalos massivos.

/* Automatização de Tarefas com Eventos: Explique como eventos podem ser usados para automatizar a manutenção do banco de dados. 
Dê um exemplo prático. */
-- Eventos funcionam como alarmes no relógio do banco de dados para rodar scripts de limpeza, cálculos ou manutenções 
-- sem precisar de comandos manuais.
-- Exemplo prático: E-commerces usam eventos rodando a cada hora para deletar da tabela "carrinho_compras" todos os 
-- carrinhos abandonados por usuários há mais de 24 horas, liberando o estoque travado.

/* Ativação do Agador de Eventos: Por que o agador de eventos pode estar desativado por padrão no My? Como ativá-lo? */
-- Ele costuma vir desativado por padrão para economizar recursos de processamento (CPU/Memória) do servidor e por 
-- questões de segurança (evitar que códigos rodem escondidos caso o banco não precise disso).
-- Para ativá-lo temporariamente até o reinício, roda-se: `SET GLOBAL event_scheduler = ON;`. 
-- Para manter ativado permanentemente, edita-se o arquivo my.cnf.

/* Exclusão de Triggers: Qual é a sintaxe para excluir um trigger no My? O que acontece com os dados afetados por triggers excluídos? */
-- A sintaxe é `DROP TRIGGER nome_do_trigger;`.
-- Os dados que já foram criados, alterados ou deletados por esse trigger no passado permanecem exatamente como estão. 
-- O banco de dados não "desfaz" as ações do trigger; ele apenas para de executá-las em ações futuras.

/* Melhores Práticas para Triggers: Quais são as melhores práticas para a criação de triggers? Explique como elas podem 
beneficiar a manutenção do banco de dados. */
-- 1. Documentar exaustivamente: Triggers são "invisíveis" no código da aplicação e podem causar confusão.
-- 2. Não criar triggers em cascata (um trigger que atualiza uma tabela, que dispara outro trigger, etc), 
-- pois isso gera loops infinitos e deadlocks.
-- Isso beneficia a manutenção pois facilita a localização de bugs quando os dados mudam de forma inesperada.

/* Planejamento de Eventos: Por que é importante planejar eventos no banco de dados? Cite situações em que um evento mal 
configurado pode gerar problemas. */
-- É importante porque eventos consomem processamento e podem travar tabelas inteiras durante sua execução. Eles devem ser 
-- planejados para ocorrer em momentos de baixo tráfego (madrugada).
-- Situação problema: Se um evento que recalcula o estoque inteiro rodar às 14h durante a Black Friday, 
-- ele vai bloquear a tabela de produtos, e ninguém conseguirá comprar nada no site até o evento terminar.