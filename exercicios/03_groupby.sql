-- Qual cliente fez mais transações no ano de 2024w
SELECT idCliente,
       count(*)
       

FROM transacoes

WHERE DtCriacao >= '2024-01-01'
AND DtCriacao < '2025-01-01'

GROUP BY idCliente

ORDER BY count(*) DESC 
