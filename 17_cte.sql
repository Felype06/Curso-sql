-- CTE: COMMOM TABLE EXPRESSION  

-- SELECT count(distinct IdCliente)
-- FROM transacoes AS t1
-- WHERE t1.IdCliente IN (
--    SELECT DISTINCT IdCliente
--   FROM transacoes
--    WHERE substr(DtCriacao,1,10) = '2025-08-25'
-- )
-- AND substr(t1.DtCriacao,1,10) = '2025-01-01'

WITH tb_Cliente_Primeiro_dia AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao,1,10) = '2025-08-25'

),

tb_Cliente_ultimo_dia AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao,1,10) = '2025-08-29'

),

tb_join AS (

    SELECT t1.idCliente AS primCliente,
           t2.idCliente AS ultCliente 
    FROM tb_Cliente_Primeiro_dia  AS t1
    LEFT JOIN tb_Cliente_ultimo_dia AS t2
    ON t1.IdCliente = t2.IdCliente 

)

SELECT count(primCliente),
       count(ultCliente),
       1. * count(ultCliente) / count(primCliente)
FROM tb_join







