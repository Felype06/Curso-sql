SELECT IdProduto,
       sum(vlProduto * QtdeProduto) AS totalpontos,
       sum(QtdeProduto) AS qtdevenda

FROM transacao_produto

GROUP BY IdProduto
ORDER BY sum(vlProduto) DESC