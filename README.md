# Controle de Estoque — CD Aparecida

Sistema web de controle de estoque para cadastro de produtos, entradas, saídas, ajustes, consulta de saldos e relatórios.

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

## Recursos disponíveis na versão 1.2
- Painel com indicadores e gráfico de movimentações dos últimos 7 dias.
- Alertas para lotes vencidos e com vencimento nos próximos 30 dias, conforme validade informada nas entradas.
- Filtros do histórico por produto, documento, tipo e período.
- Exportação CSV de saldos e de movimentações.
- Exportação Excel (`.xlsx`) com abas separadas para saldos e movimentações.
- Modelo Excel para cadastro em lote de produtos e saldos iniciais.
- Leitura de código de barras pela câmera do celular no cadastro e na seleção de produtos para movimentação.
- Importação de planilhas `.xlsx`, `.xls` e `.csv` (primeira aba/planilha), com validação de código, unidade e quantidades; os produtos existentes não são sobrescritos.
- Impressão do relatório de saldos.
- Backup e restauração em JSON.

## Próximas etapas
- Banco de dados central e autenticação.
- Perfis de acesso e trilha de auditoria.
- Integração mais ampla com banco de dados e importação estruturada de notas fiscais.
- Relatórios por período, produto, lote e centro de distribuição.


## Importação e exportação Excel
- Para importar produtos, baixe o **Modelo Excel**, preencha Código, Produto e Unidade. Estoque mínimo e Saldo inicial são opcionais.
- Unidades aceitas: `kg`, `un`, `cx`, `pct` e `L`.
- A importação adiciona produtos novos; códigos já cadastrados ou repetidos são rejeitados. O saldo inicial é lançado como ajuste com a data da importação.
- A exportação gera um arquivo `.xlsx` com as abas **Saldos** e **Movimentacoes**.
- A biblioteca Excel é carregada por CDN; a importação/exportação `.xlsx` requer conexão com a internet. As funções principais do sistema continuam disponíveis sem essa biblioteca.
- Antes de importar, confira os dados e faça um backup JSON. Não importe dados reais sem conferência.


## Leitor de código de barras pelo celular
- Abra o sistema por HTTPS e permita o acesso à câmera do navegador.
- No cadastro, use **Ler código** para preencher o código de barras do produto.
- Na movimentação, use **Ler código** para localizar e selecionar um produto já cadastrado.
- O código lido precisa estar salvo no campo Código do produto. A leitura não cria um cadastro automaticamente.
- A leitura usa a câmera do dispositivo e uma biblioteca carregada pela internet. Se a câmera não abrir, confira a permissão do navegador e a conexão.
