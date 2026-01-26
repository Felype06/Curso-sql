-- Clientes mais antigos tem mais frequência de transação?

SELECT t1.IdCliente,
       julianday('now') - julianday(substr(t1.DtCriacao,1,19)) AS idadeBase,
       count(t2.IdTransacao)


FROM clientes As t1

LEFT JOIN transacoes AS t2
ON t1.IdCliente = t2.IdCliente

GROUP BY t1.IdCliente, idadeBase

ORDER BY count(t2.IdTransacao) DESC
