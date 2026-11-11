# E-commerce Sales Analysis — MySQL

Projeto pessoal de análise de dados com MySQL, utilizando uma base fictícia de uma loja virtual. O objetivo é praticar exploração, consultas analíticas e transformação de dados em indicadores úteis para o negócio.

> **Aviso:** todos os dados são sintéticos e foram criados exclusivamente para fins educacionais.

## Objetivos
- Explorar um banco relacional com múltiplas tabelas.
- Praticar `JOIN`, agregações, subconsultas, CTEs e Window Functions.
- Investigar vendas, produtos, clientes e formas de pagamento.
- Documentar consultas, raciocínio e principais resultados.

## Tecnologias
- MySQL 8.0+
- MySQL Workbench (ou outro cliente SQL)
- Git e GitHub

## Modelo relacional
`clientes 1:N pedidos 1:N itens_pedido N:1 produtos N:1 categorias`
`pedidos 1:1 pagamentos`

## Tabelas
| Tabela | Descrição |
|---|---|
| `clientes` | Nome, cidade, estado e data de cadastro. |
| `categorias` | Categorias disponíveis na loja. |
| `produtos` | Produtos, categoria, preço atual e custo unitário. |
| `pedidos` | Cliente, data e status de cada pedido. |
| `itens_pedido` | Produtos, quantidades e preço praticado em cada pedido. |
| `pagamentos` | Forma, status e valor do pagamento de cada pedido. |

## Como executar
1. Instale MySQL 8.0+ e abra o MySQL Workbench.
2. Abra `database.sql`.
3. Execute o script completo: ele cria o banco `ecommerce_analytics`, as tabelas e os dados.
4. Atualize a lista de schemas e selecione `ecommerce_analytics`.
5. Comece pelos desafios em [`docs/desafios.md`](docs/desafios.md).

**Atenção:** o script apaga e recria as tabelas deste banco para permitir uma carga limpa. Não o execute em um banco que contenha dados importantes.

## Estrutura do repositório
```text
mysql-ecommerce-analysis/
├──base_de_dados/ 
│   └──database.sql
├── README.md
├── docs/
│   └── desafios.md
└── queries/
    ├── 01_exploracao.sql
    ├── 02_analises_intermediarias.sql
    ├── 03_analises_avancadas.sql
    └── 04_interpretacao_de_negocio.sql
```

## Decisões e limitações da base
- Os dados são fictícios.
- Um pedido pode conter vários itens.
- `itens_pedido.preco_unitario` representa o preço no momento da compra; pode diferir de `produtos.preco_atual`.
- Cada pedido possui um registro de pagamento.
- Foram incluídos pedidos cancelados e pagamentos pendentes, estornados ou recusados para permitir análises de status.
- O custo atual do produto é apenas uma aproximação para análises históricas de margem; não existe histórico de custos.

## Progresso
- [x] Modelo relacional e carga de dados fictícios.
- [x] Exploração inicial e validação dos dados.
- [x] Consultas básicas e intermediárias.
- [x] CTEs e Window Functions.
- [ ] Principais descobertas e limitações.
- [ ] Revisão final e publicação.

## Resultados
Será feito após a conclusão do projeto
