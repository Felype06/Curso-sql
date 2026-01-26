-- SELECT * 
-- FROM clientes
-- ORDER BY qtdePontos DESC
-- LIMIT 10;

SELECT idCliente, 
       flTwitch, 
       DtCriacao,
       qtdePontos
FROM clientes
WHERE flTwitch = 1
ORDER BY DtCriacao, qtdePontos DESC