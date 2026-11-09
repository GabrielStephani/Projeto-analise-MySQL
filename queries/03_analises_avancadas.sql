-- CTEs e Window Functions
-- Desafios 15 a 20

USE ecommerce_analytics;

-- Comparação do faturamento entre os meses
WITH ganho_mensal AS (
SELECT
    YEAR(ped.data_pedido) AS ano, MONTH(ped.data_pedido) AS mes, SUM(pag.valor_pago) AS faturamento_mensal
FROM pedidos AS ped
JOIN pagamentos AS pag
    ON ped.id_pedido = pag.id_pedido
WHERE pag.status_pagamento = 'aprovado'
GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
)
SELECT ano, mes, faturamento_mensal,
	  LAG(faturamento_mensal) OVER(ORDER BY ano, mes) AS faturamento_anterior,
      (faturamento_mensal - LAG(faturamento_mensal) OVER(ORDER BY ano, mes)) as diferenca
FROM ganho_mensal
;



-- Participação percentual de cada categoria
WITH faturamento_categoria AS (
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
), faturamento_total AS (
	SELECT SUM(faturamento) AS total
    FROM faturamento_categoria
)
SELECT fc.id_categoria, fc.nome_categoria, ROUND(((faturamento / total) * 100), 2) AS contribuicao_percentual
FROM faturamento_categoria fc
CROSS JOIN faturamento_total ft
ORDER BY contribuicao_percentual DESC;


-- Ranking dos produtos por faturamento dentro de cada categoria
WITH faturamento_produtos AS (
SELECT pro.id_produto, pro.nome_produto, pro.id_categoria, cat.nome_categoria,
	   SUM(iped.quantidade * iped.preco_unitario) AS faturamento_produto
FROM pagamentos pag
JOIN itens_pedido iped
	ON pag.id_pedido = iped.id_pedido
JOIN produtos pro
	ON iped.id_produto = pro.id_produto
JOIN categorias cat
	ON pro.id_categoria = cat.id_categoria
WHERE pag.status_pagamento = 'aprovado'
GROUP BY pro.id_produto, pro.nome_produto, pro.id_categoria, cat.nome_categoria
)
SELECT nome_categoria, nome_produto, faturamento_produto,
	   DENSE_RANK() OVER(PARTITION BY id_categoria ORDER BY faturamento_produto DESC) AS ranking_categoria
FROM faturamento_produtos
ORDER BY id_categoria, ranking_categoria;
#Retirei o id_produto e id_categoria para ser mais fácil visualizar os dados


-- Pedidos de cada cliente em ordem cronológica
WITH pedidos_cronologico AS (
SELECT ped.id_pedido, ped.id_cliente, cli.nome, ped.data_pedido
FROM pedidos ped
JOIN clientes cli
	ON ped.id_cliente = cli.id_cliente
) 
SELECT id_pedido, id_cliente, nome, data_pedido,
	   ROW_NUMBER() OVER(PARTITION BY id_cliente ORDER BY data_pedido, id_pedido) AS ordem_pedidos
FROM pedidos_cronologico;


-- Faturamento aprovado acumulado ao longo dos meses

WITH ganho_mensal AS (SELECT YEAR(ped.data_pedido) AS ano, MONTH(ped.data_pedido) AS mes,
					  SUM(pag.valor_pago) AS faturamento_mensal
    FROM pedidos ped
    JOIN pagamentos pag
        ON ped.id_pedido = pag.id_pedido
    WHERE pag.status_pagamento = 'aprovado'
    GROUP BY
        YEAR(ped.data_pedido),
        MONTH(ped.data_pedido)
)
SELECT ano, mes, faturamento_mensal,
    SUM(faturamento_mensal) OVER(ORDER BY ano, mes) AS faturamento_acumulado
FROM ganho_mensal
ORDER BY ano, mes;




-- Comparação entre o faturamento de cada mês com o mês anterior,
-- em valor e percentual.
WITH ganho_mensal AS (SELECT YEAR(ped.data_pedido) AS ano, MONTH(ped.data_pedido) AS mes, 
					  SUM(pag.valor_pago) AS faturamento_mensal
    FROM pedidos AS ped
    JOIN pagamentos AS pag
        ON ped.id_pedido = pag.id_pedido
    WHERE pag.status_pagamento = 'aprovado'
    GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
),
comparacao AS (SELECT ano, mes, faturamento_mensal,
               LAG(faturamento_mensal) OVER (ORDER BY ano, mes) AS faturamento_anterior,
               SUM(faturamento_mensal) OVER () AS faturamento_total
    FROM ganho_mensal
)
SELECT ano, mes, faturamento_mensal,
    ROUND((faturamento_mensal / faturamento_total) * 100, 2) AS contribuicao_percentual,
    faturamento_anterior,
    ROUND(faturamento_mensal - faturamento_anterior, 2) AS diferenca,
    ROUND(((faturamento_mensal - faturamento_anterior) / faturamento_anterior) * 100, 2) AS variacao_percentual
FROM comparacao
ORDER BY ano, mes;



