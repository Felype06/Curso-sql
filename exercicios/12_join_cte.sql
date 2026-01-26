-- Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?

WITH  tb_clientes_janeiro AS (
    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE DtCriacao >= '2025-01-01'
    AND DtCriacao < '2025-02-01'
),

tb_clientes_curso AS (
    SELECT DISTINCT idCliente
    FROM transacoes 
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
)

SELECT count(t1.idCliente) AS clientejaneiro,
       count(t2.idCliente) AS clientesql
FROM tb_clientes_janeiro AS t1
LEFT JOIN tb_clientes_curso AS t2
ON t1.idCliente = t2.idCliente





