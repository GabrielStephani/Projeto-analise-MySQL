# Desafios de análise

Resolva sem consultar soluções prontas. Salve as consultas na pasta `queries/` e explique as decisões importantes em comentários.

## Etapa 1 — Exploração e SQL básico
1. Liste as categorias e quantos produtos existem em cada uma.
2. Mostre os 10 produtos com maior preço atual.
3. Conte quantos clientes existem por estado.
4. Liste os pedidos de 2025, do mais recente ao mais antigo.
5. Conte os pedidos por status.

## Etapa 2 — JOINs e agregações
6. Exiba cada pedido com nome do cliente, cidade e status.
7. Calcule o valor bruto de cada pedido (quantidade × preço unitário).
8. Calcule o faturamento mensal considerando apenas pagamentos aprovados.
9. Identifique as cinco categorias com maior faturamento aprovado.
10. Calcule o ticket médio dos pedidos com pagamento aprovado.
11. Liste clientes que nunca fizeram pedidos.
12. Identifique produtos que nunca apareceram em itens de pedido.

## Etapa 3 — Subconsultas e CTEs
13. Encontre produtos cujo preço atual está acima da média de sua categoria.
14. Identifique clientes cujo total comprado está acima da média dos clientes compradores.
15. Use CTEs para calcular faturamento mensal e comparar cada mês com o anterior.
16. Calcule a participação percentual de cada categoria no faturamento aprovado.

## Etapa 4 — Window Functions
17. Faça um ranking dos produtos por faturamento dentro de cada categoria.
18. Numere os pedidos de cada cliente em ordem cronológica.
19. Calcule o faturamento aprovado acumulado ao longo dos meses.
20. Compare o faturamento de cada mês com o mês anterior, em valor e percentual.

## Etapa 5 — Interpretação de negócio
21. Qual estado concentra o maior faturamento aprovado? E qual tem mais clientes?
22. Quais formas de pagamento são mais utilizadas? Compare quantidade e valor.
23. Quantos clientes fizeram dois ou mais pedidos aprovados?
24. Quais produtos têm maior margem bruta estimada? Explique a limitação de usar custo atual.
25. Escreva de três a cinco conclusões úteis para a gestão da loja.

## Critérios de qualidade
- Evite duplicação de valores em JOINs entre relações 1:N.
- Diferencie quantidade de pedidos, itens e clientes.
- Defina como tratar cancelamentos, estornos e pagamentos pendentes em cada métrica.
- Use nomes claros para colunas calculadas e comente consultas complexas.
- Não confunda correlação com causalidade.

## Documentação de cada análise
1. **Pergunta:** o que deseja descobrir?
2. **Abordagem:** tabelas e recursos SQL utilizados.
3. **Consulta:** SQL executado.
4. **Resultado:** o que encontrou?
5. **Interpretação:** por que importa?
6. **Limitação:** quais hipóteses ou restrições existem?
