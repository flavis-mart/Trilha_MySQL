Questões Práticas
/*Criação de Usuários: Crie dois usuários no MySQL:
○ Um usuário chamado usuario_local com acesso apenas local (localhost).
○ Um usuário chamado usuario_remoto com acesso remoto (%).*/
-- Usuário com acesso apenas local
CREATE USER 'usuario_local'@'localhost' IDENTIFIED BY 'senha123';

-- Usuário com acesso remoto (o '%' funciona como um curinga para qualquer IP)
CREATE USER 'usuario_remoto'@'%' IDENTIFIED BY 'senha123';

/*Alteração de Usuários: Modifique a senha do usuário usuario_local para uma senha forte, seguindo as práticas recomendadas.*/
-- Atualizando para uma senha forte
ALTER USER 'usuario_local'@'localhost' IDENTIFIED BY 'S3nh@F0rt3_!2026';


/*Exclusão de Usuários: Exclua o usuário usuario_remoto do banco de dados.*/
DROP USER 'usuario_remoto'@'%';

/*Conceda permissão de leitura (SELECT) na tabela clientes para o usuário usuario_local.*/
GRANT SELECT ON empresa.clientes TO 'usuario_local'@'localhost';


/*Conceda todas as permissões em um banco de dados chamado loja para o usuário admin_user.*/
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_senha';
GRANT ALL PRIVILEGES ON loja.* TO 'admin_user'@'localhost';

/*Revogação de Permissões: Revogue a permissão de leitura (SELECT) na tabela clientes do usuário usuario_local.*/
REVOKE SELECT ON empresa.clientes FROM 'usuario_local'@'localhost';


/*Configuração de Permissões por Host: Crie um usuário chamado usuario_servidor com permissão de acessar o banco de dados apenas do servidor local.*/
-- O host '127.0.0.1' ou 'localhost' garante que a conexão só venha do próprio servidor
CREATE USER 'usuario_servidor'@'127.0.0.1' IDENTIFIED BY 'senha_servidor';

/*Princípio do Menor Privilégio: Configure um usuário chamado relatorio_user que tenha acesso somente à tabela relatorios com permissões de leitura
(SELECT).*/
CREATE USER 'relatorio_user'@'localhost' IDENTIFIED BY 'senha_relatorio';
GRANT SELECT ON empresa.relatorios TO 'relatorio_user'@'localhost';

/*Auditoria de Usuários: Liste todos os usuários criados no banco de dados e suas permissões utilizando os comandos adequados.*/
-- Listar todos os usuários do banco e seus respectivos hosts
SELECT user, host FROM mysql.user;

-- Ver as permissões específicas concedidas a um usuário
SHOW GRANTS FOR 'usuario_local'@'localhost';

/*Políticas de Senhas: Ative a política de senhas fortes no MySQL e aplique-a ao usuário usuario_local.*/

SET GLOBAL validate_password.policy = 'STRONG';

ALTER USER 'usuario_local'@'localhost' IDENTIFIED BY 'N0v@S3nh@_C0mpl3x4!';

/*Configuração em Ambientes de Produção: Configure dois usuários em um banco de dados de produção:*/
-- Criação dos usuários
CREATE USER 'user_leitura'@'%' IDENTIFIED BY 'senha_leitura';
CREATE USER 'user_operacional'@'%' IDENTIFIED BY 'senha_operacional';

/*Um usuário com permissões apenas de leitura (SELECT).*/
GRANT SELECT ON producao.* TO 'user_leitura'@'%';

/*Um usuário com permissões completas para inserção e alteração (INSERT, UPDATE e DELETE).*/
GRANT INSERT, UPDATE, DELETE ON producao.* TO 'user_operacional'@'%';


Questões Teóricas
/*Explique a diferença entre os comandos GRANT e REVOKE no MySQL.*/
-- GRANT: É o comando usado para conceder permissões a um usuário. 
-- REVOKE: É o comando usado para remover uma permissão que foi dada anteriormente.

/*Dê exemplos de situações em que cada comando seria usado.*/
-- Grant: Exemplo: Liberar o acesso para que um novo funcionário possa ler a tabela de clientes.
-- Revoke: Exemplo: Retirar a permissão de leitura quando o funcionário for transferido de setor e não precisar mais acessar esses dados.

/*O que é o princípio do menor privilégio? Por que ele é importante em sistemas de banco de dados?*/
-- É a prática de configurar a conta de um usuário apenas com as permissões que ele obrigatoriamente precisa para realizar seu trabalho. 
-- É importante porque limita os danos. Se a conta for invadida ou o usuário cometer um erro, o impacto ficará restrito apenas aos dados 
-- que ele tinha autorização para acessar.

/*Qual é a importância de usar senhas fortes em bancos de dados? Cite as características de uma senha segura.*/
-- Senhas fortes evitam que invasores utilizem programas automatizados para adivinhar a senha por tentativa e erro 
-- (ataques de força bruta). Uma senha segura deve ser longa (12 caracteres ou mais), misturar letras maiúsculas e minúsculas, 
-- incluir números e conter caracteres especiais, sem usar palavras comuns de dicionário ou dados pessoais.

/*Por que é recomendável evitar o uso de usuários compartilhados em bancos de dados?*/
-- Porque contas compartilhadas impossibilitam a responsabilização. Se várias pessoas usam o mesmo login e um dado é apagado acidentalmente, 
-- não há como rastrear no sistema qual daquelas pessoas executou o comando. Contas individuais permitem identificar todas as ações.

/*Quais são os riscos de conceder permissões desnecessárias a um usuário? Explique como evitar esses riscos.*/
-- O risco é permitir que o usuário altere ou exclua dados acidentalmente ou que um invasor cause danos graves caso roube essa conta. 
-- Se um usuário que apenas visualiza relatórios tiver a permissão de deletar dados, todo o sistema fica em risco. Para evitar isso, 
-- deve-se conceder apenas as permissões exigidas pela função da pessoa.

/*Explique como a restrição de acesso por host pode aumentar a segurança do banco de dados.*/
-- Ao configurar uma restrição por host, o banco de dados só aceita conexões vindas de um endereço IP específico. 
-- Isso aumenta a segurança porque impede o acesso de máquinas desconhecidas. Mesmo que alguém descubra a senha do banco de dados, 
-- o login será bloqueado se a pessoa não estiver utilizando o computador autorizado.

/*Descreva as permissões comuns em MySQL (SELECT, INSERT, UPDATE, DELETE) e dê exemplos de suas aplicações.*/
-- SELECT: Permite visualizar os dados. Exemplo: Consultar a lista de vendas do mês.

-- INSERT: Permite adicionar novos registros. Exemplo: Cadastrar um novo produto no sistema.

-- UPDATE: Permite modificar registros existentes. Exemplo: Corrigir o endereço de um cliente.

-- DELETE: Permite remover registros. Exemplo: Apagar o cadastro de um produto que não é mais vendido.

/*O que é uma auditoria de usuários e permissões? Por que é importante realizá-la regularmente em um banco de dados?*/
-- É o processo de revisar regularmente a lista de usuários do banco de dados e as permissões de cada um. 
-- É importante porque, com o tempo, funcionários mudam de cargo ou saem da empresa. A auditoria garante que contas inativas 
-- sejam desativadas e que permissões antigas sejam removidas, evitando acessos indevidos.

/*Quais práticas devem ser seguidas ao conceder permissões em um ambiente multiusuário?*/
-- Criar contas individuais exclusivas para cada pessoa.

-- Utilizar grupos de permissão (Roles) para padronizar os acessos por departamento, em vez de configurar cada permissão manualmente por pessoa.

-- Exigir atualizações periódicas de senhas.

-- Fazer revisões regulares (auditorias) das permissões ativas.

/*Considere um ambiente de produção onde há uma equipe de desenvolvedores e uma equipe de administradores. 
Como você configura os usuários e permissões para garantir segurança e eficiência?*/
-- Desenvolvedores: Devem ter apenas a permissão de leitura (SELECT). Isso permite que eles investiguem problemas no sistema usando dados reais, 
-- mas os impede de alterar ou deletar informações diretamente no banco.

-- Administradores: Têm permissões completas para modificar a estrutura e os dados. Porém, a prática correta é que eles não façam isso manualmente,0
-- mas sim através de códigos e processos automatizados para registrar as mudanças e evitar erros humanos na produção.