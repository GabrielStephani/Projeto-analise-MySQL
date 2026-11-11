USE ecommerce_analytics;

-- 01) Qual estado concentra o maior faturamento aprovado? E qual tem mais clientes?
SELECT * FROM clientes; #id clientes e estado
SELECT * FROM pagamentos; #status pagamento e id pedido
SELECT * FROM pedidos; #id pedido e id cliente


#Estados com maior faturamento
SELECT cli.estado, SUM(pag.valor_pago) AS faturamento_total, ROUND(AVG(pag.valor_pago), 2) AS média_compra
FROM pagamentos pag
JOIN pedidos ped
	ON pag.id_pedido = ped.id_pedido
JOIN clientes cli
	ON ped.id_cliente = cli.id_cliente
WHERE pag.status_pagamento = 'aprovado'
GROUP BY cli.estado 
ORDER BY 2 DESC;


#Estados com mais clientes
SELECT estado, COUNT(DISTINCT id_cliente) AS qnt_clientes
FROM clientes
GROUP BY estado
ORDER BY 2 DESC;




-- 02) Quais formas de pagamento são mais utilizadas? Compare quantidade e valor.
SELECT * FROM pagamentos;

WITH faturamento_pagamento AS (
SELECT forma_pagamento, COUNT(DISTINCT id_pedido) AS qnt_transacoes ,
       ROUND(SUM(valor_pago), 2) AS faturamento,
	   ROUND(AVG(valor_pago), 2) AS gasto_medio
FROM pagamentos
WHERE status_pagamento = 'aprovado'
GROUP BY forma_pagamento
)
SELECT forma_pagamento, qnt_transacoes, faturamento, gasto_medio,
	  ROUND((faturamento / SUM(faturamento) OVER() * 100), 2) AS participacao_percentual
FROM faturamento_pagamento
ORDER BY faturamento DESC;



-- 03) Quantos clientes fizeram dois ou mais pedidos aprovados?
SELECT * FROM clientes; #id clientes e estado
SELECT * FROM pagamentos; #status pagamento e id pedido
SELECT * FROM pedidos; #id pedido e id cliente

#Clientes com 2 pedidos ou mais
SELECT cli.nome, ped.id_cliente, COUNT(pag.id_pedido) AS qnt_pedidos
FROM pagamentos pag
JOIN pedidos ped
	ON pag.id_pedido = ped.id_pedido
JOIN clientes cli
	ON ped.id_cliente = cli.id_cliente
WHERE pag.status_pagamento = 'aprovado'
GROUP BY cli.nome, ped.id_cliente
HAVING COUNT(pag.id_pedido) >= 2
ORDER BY nome;

#quantidade de clientes com mais de 2 pedidos
WITH clientes_2pedidos AS (
SELECT cli.nome, ped.id_cliente, COUNT(pag.id_pedido) AS qnt_pedidos
FROM pagamentos pag
JOIN pedidos ped
	ON pag.id_pedido = ped.id_pedido
JOIN clientes cli
	ON ped.id_cliente = cli.id_cliente
WHERE pag.status_pagamento = 'aprovado'
GROUP BY cli.nome, ped.id_cliente
HAVING COUNT(pag.id_pedido) >= 2
ORDER BY nome
) 
SELECT COUNT(*) AS clientes_recorrentes
FROM clientes_2pedidos;



-- 04) Quais produtos têm maior margem bruta estimada? Explique a limitação de usar custo atual. 

#Margem bruta: ((receita - custo) / receita) * 100

SELECT p.id_produto, p.nome_produto, SUM(iped.quantidade) AS unidades_vendidas,
	   SUM(iped.preco_unitario * iped.quantidade) AS faturamento,
       SUM(p.custo_unitario * iped.quantidade) AS custo_estimado,
       SUM(iped.preco_unitario * iped.quantidade) - SUM(p.custo_unitario * iped.quantidade) AS lucro_bruto,
       ROUND((SUM(iped.preco_unitario * iped.quantidade) - SUM(p.custo_unitario * iped.quantidade)) 
       / NULLIF(SUM(iped.preco_unitario * iped.quantidade), 0) * 100, 2) AS margem_bruta_percentual
FROM itens_pedido iped	
JOIN pagamentos pag
	ON iped.id_pedido = pag.id_pedido
JOIN produtos p
	ON iped.id_produto = p.id_produto
WHERE pag.status_pagamento = 'aprovado'
GROUP BY p.id_produto, p.nome_produto
ORDER BY margem_bruta_percentual DESC;

#Utilizar custo_atual para a análise possui uma limitação clara: não é possível saber se o produto foi adquirido por um preço
#maior ou menor em períodos anteriores, devido à ausência de um histórico de preços. Devido a isso, os resultados da pesquisa 
#são apenas aproximações/estimativas, e não devem ser considerados como os valores reais.








