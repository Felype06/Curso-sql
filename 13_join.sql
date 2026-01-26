SELECT transacao_produto.*,
       produtos.DescCategoriaProduto

FROM transacao_produto

LEFT JOIN produtos
ON transacao_produto.IdProduto = produtos.IdProduto





