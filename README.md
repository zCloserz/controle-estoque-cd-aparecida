# Controle de Estoque — CD Aparecida

Primeira versão do sistema web para cadastro de produtos, registro de entradas, saídas e ajustes, consulta de saldos e exportação de relatórios.

## Como usar
1. Abra `index.html` no navegador ou publique o repositório com GitHub Pages.
2. Cadastre os produtos com código, nome, unidade e estoque mínimo.
3. Confira o saldo físico e registre um **Ajuste de saldo** para estabelecer o saldo inicial validado.
4. Registre entradas e saídas com data, documento, lote, validade e observação.
5. Exporte os saldos em CSV e faça backups JSON regularmente.

## Importante
- Os dados desta versão ficam no armazenamento local do navegador (`localStorage`).
- Não há login, banco de dados central ou sincronização entre dispositivos/usuários.
- Limpar os dados do navegador pode apagar os registros. Use **Baixar backup JSON**.
- O ajuste de saldo informa o saldo final desejado e registra a diferença como movimentação.
- Faça conferência física e validação antes de usar os números em processos oficiais.

## Próximas etapas
- Banco de dados central e autenticação.
- Perfis de acesso e trilha de auditoria.
- Importação de planilhas e notas fiscais.
- Relatórios por período, produto, lote e centro de distribuição.
