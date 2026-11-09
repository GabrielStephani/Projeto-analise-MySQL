-- Consultas de exploração inicial
-- Desafios 1 a 5

USE ecommerce_analytics;

-- quantidade de produtos por categoria
SELECT id_categoria, COUNT(*) AS quantidade_produtos
FROM produtos
GROUP BY id_categoria
ORDER BY quantidade_produtos DESC;

-- Produtos com maior preço atual
SELECT nome_produto, preco_atual
FROM produtos
ORDER BY preco_atual DESC
LIMIT 10;

-- Quantidade de clientes por estado
SELECT estado, COUNT(*) AS quantidade_clientes
FROM clientes
GROUP BY estado
ORDER BY quantidade_clientes DESC;

-- Pedidos de 2025
SELECT *
FROM pedidos
WHERE YEAR(data_pedido) = 2025
ORDER BY data_pedido DESC;

-- Quantidade de pedidos por status
SELECT status_pedido, COUNT(*) AS quantidade_pedidos
FROM pedidos
GROUP BY status_pedido
ORDER BY quantidade_pedidos DESC;

-- Desafios extras

-- Preço médio de cada categoria
SELECT produtos.id_categoria, nome_categoria, ROUND(AVG(preco_atual)) AS preco_medio
FROM produtos
JOIN categorias
	ON produtos.id_categoria = categorias.id_categoria
GROUP BY produtos.id_categoria
ORDER BY preco_medio DESC;

-- Pedidos por mês em 2025
SELECT MONTH(data_pedido) AS mes, COUNT(*) AS quantidade_pedidos
FROM pedidos
WHERE YEAR(data_pedido) = 2025
GROUP BY mes;

-- 5 Clientes que mais pediram
SELECT ped.id_cliente, nome, COUNT(id_pedido) AS quantidade_pedidos
FROM pedidos AS ped
JOIN clientes AS cli
	ON ped.id_cliente = cli.id_cliente
GROUP BY ped.id_cliente 
ORDER BY quantidade_pedidos DESC
LIMIT 5;

-- Valor total de cada pedido
SELECT ped.id_pedido, id_cliente, SUM(quantidade * preco_unitario) AS custo_pedido
FROM pedidos AS ped
JOIN itens_pedido AS iped
	ON ped.id_pedido = iped.id_pedido
GROUP BY ped.id_pedido, id_cliente
ORDER BY custo_pedido DESC;

-- Categorias com mais de 5 produtos
SELECT pro.id_categoria, nome_categoria, COUNT(id_produto) AS quantidade_produtos
FROM produtos pro
JOIN categorias cat
	ON pro.id_categoria = cat.id_categoria
GROUP BY pro.id_categoria, cat.nome_categoria
HAVING quantidade_produtos > 5
ORDER BY quantidade_produtos DESC;






