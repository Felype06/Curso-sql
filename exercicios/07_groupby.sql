-- Qual produto teve mais transações

SELECT IdProduto,
       --count(*)
       sum(QtdeProduto) AS qtdeProdutoSUM

FROM transacao_produto

GROUP BY 1
ORDER BY count(*) DESC

LIMIT 1