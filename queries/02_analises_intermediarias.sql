-- JOINs, agregações e subconsultas
-- Desafios 6 a 14

USE ecommerce_analytics;

-- informações do pedido e do cliente
SELECT ped.id_pedido, ped.id_cliente, nome, cidade, ped.status_pedido
FROM pedidos ped
JOIN clientes cli
	ON ped.id_cliente = cli.id_cliente
ORDER BY ped.id_cliente;

-- Valor total de cada pedido (já realizado em "01_exploracao")

-- Faturamento mensal com pedidos aprovados
WITH ganho_mensal AS (
SELECT
    YEAR(ped.data_pedido) AS ano, MONTH(ped.data_pedido) AS mes, SUM(pag.valor_pago) AS faturamento_mensal
FROM pedidos AS ped
JOIN pagamentos AS pag
    ON ped.id_pedido = pag.id_pedido
WHERE pag.status_pagamento = 'aprovado'
GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
)
SELECT ano, mes, faturamento_mensal
FROM ganho_mensal
ORDER BY ano, mes ;


-- 5 categorias com maior faturamento aprovado
SELECT
    pro.id_categoria, cat.nome_categoria, ROUND(SUM(iped.quantidade * iped.preco_unitario), 2) AS faturamento
FROM pagamentos AS pag
JOIN itens_pedido AS iped
    ON pag.id_pedido = iped.id_pedido
JOIN produtos AS pro
    ON iped.id_produto = pro.id_produto
JOIN categorias AS cat
    ON pro.id_categoria = cat.id_categoria
WHERE pag.status_pagamento = 'aprovado'
GROUP BY pro.id_categoria, cat.nome_categoria
ORDER BY faturamento DESC
LIMIT 5;


-- Ticket médio de pagamentos aprovados
SELECT ROUND(AVG(valor_pago), 2)
FROM pagamentos pag
WHERE status_pagamento = 'aprovado';

-- Clientes que nunca fizeram pedidos
SELECT cli.id_cliente, nome
FROM clientes cli
WHERE NOT EXISTS( SELECT 1
				  FROM pedidos ped
				  WHERE ped.id_cliente = cli.id_cliente
)
;


-- Itens que nunca foram pedidos
SELECT pro.id_produto
FROM produtos pro
WHERE NOT EXISTS( SELECT 1
				  FROM itens_pedido iped
				  WHERE iped.id_produto = pro.id_produto
);


-- Produtos com preço acima da média de sua categoria
WITH media_valor AS (
SELECT produtos.id_categoria, AVG(preco_atual) AS preco_medio
FROM produtos
GROUP BY produtos.id_categoria
)
SELECT p.id_produto, p.nome_produto, p.preco_atual, ROUND(mv.preco_medio, 2) as preco_medio_categoria, p.id_categoria
FROM produtos p
JOIN media_valor mv
	ON p.id_categoria = mv.id_categoria 
WHERE p.preco_atual > mv.preco_medio
ORDER BY p.id_categoria ASC;


-- Clientes em que o total comprado é maior que a média
WITH valor_por_cliente AS (
SELECT ped.id_cliente, SUM(valor_pago) as total
FROM pedidos ped
JOIN pagamentos pag
	ON ped.id_pedido = pag.id_pedido
WHERE pag.status_pagamento = 'aprovado'
GROUP BY ped.id_cliente
ORDER BY id_cliente
)
, media_pedidos AS (

SELECT AVG(total) as media
FROM valor_por_cliente
)
SELECT vp.id_cliente, cli.nome, vp.total
FROM valor_por_cliente vp
JOIN media_pedidos mp
	ON vp.total > mp.media
JOIN clientes cli
	ON vp.id_cliente = cli.id_cliente
ORDER BY total DESC;

