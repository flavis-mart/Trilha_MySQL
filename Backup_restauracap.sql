/*1. Backup Completo de um Banco de Dados Realize um backup completo do banco de dados biblioteca e salve-o em um arquivo chamado 
biblioteca_backup.sql.*/
mysqldump -u usuario_aqui -p biblioteca > biblioteca_backup.sql

/*2. Backup de Tabelas Específicas Crie um backup que contenha apenas as tabelas livros e autores do banco de dados biblioteca.*/
mysqldump -u usuario_aqui -p biblioteca livros autores > backup_tabelas_biblioteca.sql

/*3. Backup de Todos os Bancos de Dados Utilize o comando apropriado para criar um backup de todos os bancos de dados do servidor 
e salve o arquivo como backup_total.sql.*/
mysqldump -u usuario_aqui -p biblioteca livros autores > backup_tabelas_biblioteca.sql

/*4. Backup Incremental Usando Logs Binários Habilite logs binários no MySQL e explique como usar o arquivo de log para criar um backup incremental.*/
mysqlbinlog /var/log/mysql/mysql-bin.000001 > backup_incremental.sql

/*5. Restauração de um Banco de Dados Restaure o banco de dados biblioteca a partir do arquivo biblioteca_backup.sql.*/
mysql -u usuario_aqui -p biblioteca < biblioteca_backup.sql

/*6. Restauração de Todos os Bancos de Dados Realize a restauração de todos os bancos de dados usando o arquivo backup_total.sql.*/
mysql -u usuario_aqui -p < backup_total.sql

/*7. Exportação de Dados para CSV Exporte os dados da tabela clientes para um arquivo CSV chamado clientes.csv, configurando 
corretamente os separadores, aspas e quebras de linha.*/
SELECT * FROM clientes 
INTO OUTFILE '/var/lib/mysql-files/clientes.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

/*8. Importação de Dados de um Arquivo CSV Importe os dados contidos no arquivo clientes.csv para a tabela clientes do banco de dados biblioteca.*/
LOAD DATA INFILE '/var/lib/mysql-files/clientes.csv'
INTO TABLE clientes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Usado caso o CSV tenha uma linha de cabeçalho

/*9. Automatização de Backups Configure um cron job para realizar backups automáticos do banco de dados biblioteca diariamente às 2h da manhã, 
salvando os arquivos em um diretório /backups.*/
0 2 * * * /usr/bin/mysqldump -u root -pSenhaAqui biblioteca > /backups/biblioteca_$(date +\%F).sql

/*10. Teste de Restauração em Ambiente de Desenvolvimento Faça o upload do backup do banco de dados biblioteca para um servidor 
de teste e restaure o banco de dados para verificar a integridade dos dados.*/
1º passo - Enviar o arquivo para o servidor de teste (ex: usando scp biblioteca_backup.sql user@servidor_teste:/tmp)

2º passo - Entrar no MySQL do servidor de teste e criar o banco: CREATE DATABASE biblioteca

3º passo - Sair do MySQL e restaurar os dados via terminal: mysql -u usuario -p biblioteca < /tmp/biblioteca_backup.sql

4º passo - Entrar novamente no banco e rodar alguns SELECT COUNT(*) para verificar se o número de linhas bate com a produção.

Atividades Teóricas

/*Definição de Backup e Restauração Explique a importância de realizar backups regulares em um banco de dados. 
Quais riscos estão associados à ausência de backups?*/
-- Importância: É a única linha de defesa definitiva contra a perda de dados.
-- Riscos da ausência: Sem backups, a empresa está vulnerável a falhas de hardware (HDs queimados), ataques maliciosos 
-- (Ransomware/Sequestro de dados), desastres naturais e, principalmente, erros humanos

/*Comando mysqldump Descreva o comando mysqldump, incluindo suas principais opções e quando ele deve ser utilizado.*/
-- É um utilitário de linha de comando do MySQL que gera backups lógicos. Ele cria um arquivo de texto longo contendo 
-- todas as instruções SQL (CREATE TABLE, INSERT INTO) necessárias para recriar o banco do zero.
-- Principais opções: -u (usuário), -p (pedir senha), --all-databases (todos os bancos), --routines (incluir funções e procedures).

/*Diferença entre Backup Completo e Backup Incremental Compare as características de um backup completo com um backup 
incremental. Quais as vantagens e desvantagens de cada um?*/
-- Completo (Full): Copia absolutamente tudo o que existe no banco de dados.
-- Vantagem: Fácil de restaurar (basta um arquivo).
-- Desvantagem: Demora muito e consome muito espaço em disco.
-- Incremental: Copia apenas os dados que foram alterados ou adicionados desde o último backup.
-- Vantagem: Muito rápido e consome pouquíssimo espaço.
-- Desvantagem: Restauração mais complexa (você precisa primeiro restaurar o último Full e, depois, aplicar os arquivos incrementais em ordem).

/*Logs Binários no MySQL O que são logs binários no MySQL e como eles podem ser utilizados para realizar backups incrementais?*/
-- Os logs binários são arquivos gerados pelo servidor MySQL que registram rigorosamente cada alteração feita nos dados 
-- (todos os INSERTs, UPDATEs e DELETEs). Eles são usados para backups incrementais: em vez de fazer um backup completo todo dia, 
-- você faz um no domingo e usa os binlogs para salvar apenas o que mudou na segunda, terça, etc.

/*Importação de Arquivos CSV Explique o comando LOAD DATA INFILE e as configurações necessárias para importar corretamente 
um arquivo CSV para uma tabela.*/
-- O LOAD DATA INFILE é o comando nativo do MySQL para ler arquivos de texto e injetá-los diretamente em uma tabela de 
-- forma extremamente rápida. As configurações necessárias dizem ao MySQL como "ler" o arquivo: FIELDS TERMINATED BY diz 
-- qual é o separador das colunas (geralmente vírgula ou ponto-e-vírgula) e LINES TERMINATED BY diz qual caractere representa 
-- a quebra de linha (geralmente \n).

/*Exportação de Dados com SELECT INTO OUTFILE Descreva o processo de exportação de dados usando o comando SELECT INTO OUTFILE. 
Quais são as principais opções disponíveis?*/
-- É o inverso do item anterior. Ele pega o resultado de um SELECT normal e, em vez de mostrar na tela, grava o resultado 
-- diretamente em um arquivo de texto no servidor onde o banco está instalado. Você precisa definir as mesmas opções de 
-- formato (TERMINATED BY, ENCLOSED BY) para organizar o arquivo gerado.

/*Boas Práticas de Backup Liste pelo menos três boas práticas relacionadas à realização e ao armazenamento de backups de bancos de dados.*/
-- Regra 3-2-1: Tenha 3 cópias dos seus dados, em 2 mídias diferentes, sendo 1 delas off-site (na nuvem ou em outro local geográfico).
-- Criptografia: Backups devem ser guardados criptografados. De nada adianta um banco seguro se o arquivo .sql jogado em um servidor de 
-- arquivos tiver senhas e dados de clientes visíveis em texto puro.
-- Retenção e Rotação: Não guarde backups para sempre, ou o disco lotará. Configure scripts para apagar backups com mais de X dias de idade.

/*Testes de Restauração Por que é importante realizar testes regulares de restauração de backups? O que pode ser identificado nesses testes?*/
-- O Teste de Restauração (ou "Restore Drill") é crucial porque um backup não testado não é um backup, 
-- é apenas uma esperança. Nesses testes identificamos: arquivos corrompidos, falta de espaço no servidor de destino, 
-- esquecimento de fazer o backup de triggers ou procedures, e calculamos quanto tempo a empresa levaria para voltar 
-- a operar após um desastre (RTO - Recovery Time Objective).

/*Formatos de Exportação e Integração com Outros Sistemas Explique por que o formato CSV é amplamente utilizado para exportação e 
integração de dados entre sistemas.*/
-- O CSV (Comma-Separated Values) é o formato mais utilizado porque é universal e agnóstico. Ele não depende do MySQL, 
-- da Microsoft ou da Apple. Praticamente qualquer sistema do mundo (Excel, Python, SAP, ERPs, sistemas legados) sabe ler 
-- um arquivo de texto onde as palavras são separadas por vírgulas.

/*Automatização de Backups Discuta as vantagens de automatizar backups utilizando ferramentas como cron jobs. 
Quais cuidados devem ser tomados para garantir que os backups automatizados sejam eficazes?*/
-- Vantagens: Remove o fator humano. O backup será feito sempre na hora certa (geralmente de madrugada, 
-- quando o uso do sistema é baixo), sem esquecimentos.
-- Cuidados: Automatizar não significa abandonar. É essencial criar sistemas de alerta/monitoramento que enviem um e-mail 
-- ou aviso caso o script do cron job falhe. Além disso, é preciso monitorar o espaço em disco do diretório /backups para 
-- que o servidor não trave por falta de armazenamento.