WITH tb_transacoes AS (

    SELECT IdTransacao,
           IdCliente,
           QtdePontos,
           datetime(substr(DtCriacao,1,19)) AS DtCriacao,
           julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate 
    
    FROM transacoes
),

tb_cliente AS (

    SELECT IdCliente,
           datetime(substr(DtCriacao,1,19)) AS DtCriacao,
           julianday('now') - julianday(substr(DtCriacao,1,10)) AS idadeBase
    FROM clientes
),

tb_sumario_transacoes AS (

     SELECT IdCliente,
        count(IdTransacao) AS qtdTransacoesVida,
        count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtdeTransacoes56,
        count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtdeTransacoes28,
        count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtdeTransacoes14,
        count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtdeTransacoes7,

        min(diffDate) AS diasUltimaInteracao,

        sum(QtdePontos) AS saldoAtual,

        sum(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS PontosPositivos,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 56 THEN QtdePontos ELSE 0 END) AS PontosPositivos56,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 28 THEN QtdePontos ELSE 0 END) AS PontosPositivos28,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 14 THEN QtdePontos ELSE 0 END) AS PontosPositivos14,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 7 THEN QtdePontos ELSE 0 END) AS PontosPositivos7,
        
        sum(CASE WHEN QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS PontosNegativoVida,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 56 THEN QtdePontos ELSE 0 END) AS PontosNegativo56,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 28 THEN QtdePontos ELSE 0 END) AS PontosNegativo28,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 14 THEN QtdePontos ELSE 0 END) AS PontosNegativo14,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 7 THEN QtdePontos ELSE 0 END) AS PontosNegativo7
        
        
    
    FROM tb_transacoes
    GROUP BY IdCliente

),


tb_transacao_produto AS (

    SELECT t1.*,
        t3.DescNomeProduto,
        t3.DescCategoriaProduto

    FROM tb_transacoes AS t1

    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto
),

tb_cliente_produto AS (

    SELECT idCliente,
        DescNomeProduto,
        count(*) AS qtdVida,
        count( CASE WHEN diffDate <= 56 THEN idTransacao END) AS qtd56,
        count( CASE WHEN diffDate <= 28 THEN idTransacao END) AS qtd28,
        count( CASE WHEN diffDate <= 14 THEN idTransacao END) AS qtd14,
        count( CASE WHEN diffDate <= 7 THEN idTransacao END) AS qtd7
            
    FROM tb_transacao_produto

    GROUP BY idCliente, DescNomeProduto
),

tb_cliente_produto_rn AS (

    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdVida DESC) AS rnVida,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd56 DESC) AS rn56,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd28 DESC) AS rn28,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd14 DESC) AS rn14,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd7 DESC) AS rn7

    FROM tb_cliente_produto
),



tb_cliente_dia AS (

    SELECT idCliente,
        strftime('%w', DtCriacao) AS dtDia,
        count(*) AS qtdTransacao

    FROM tb_transacoes
    WHERE diffDate <= 200
    GROUP BY idCliente, dtDia
    
),

tb_cliente_dia_rn AS (

    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY idCliente ORDER BY qtdTransacao DESC) AS rnDia

    FROM tb_cliente_dia 
),

tb_join AS ( 
 
    SELECT t1.*,
           t2.idadeBase,
           t3.DescNomeProduto AS produtoVida,
           t4.DescNomeProduto AS produto56,
           t5.DescNomeProduto AS produto28,
           t6.DescNomeProduto AS produto14,
           t7.DescNomeProduto AS produto7,
           t8.dtDia

    FROM tb_sumario_transacoes AS t1

    LEFT JOIN tb_cliente AS t2
    ON t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.idCliente = t3.idCliente
    AND t3.rnVida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.idCliente = t4.idCliente
    AND t4.rn56 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.idCliente = t5.idCliente
    AND t5.rn28 = 1

    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.idCliente = t6.idCliente
    AND t6.rn14 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.idCliente = t7.idCliente
    AND t7.rn7 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.idCliente = t8.idCliente
    AND rnDia = 1

)

SELECT * FROM tb_join


