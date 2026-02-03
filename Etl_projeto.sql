WITH tb_transacoes AS (

    SELECT IdTransacao,
           IdCliente,
           QtdePontos,
           datetime(substr(DtCriacao,1,19)) AS DtCriacao,
           julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate,
           CAST(strftime('%H', substr(DtCriacao,1,19)) AS INTERGER) AS dtHora
    
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
        count(CASE WHEN diffDate <= 300 THEN IdTransacao END) AS qtdeTransacoes300,
        count(CASE WHEN diffDate <= 200 THEN IdTransacao END) AS qtdeTransacoes200,
        count(CASE WHEN diffDate <= 140 THEN IdTransacao END) AS qtdeTransacoes140,
        count(CASE WHEN diffDate <= 70 THEN IdTransacao END) AS qtdeTransacoes70,

        min(diffDate) AS diasUltimaInteracao,

        sum(QtdePontos) AS saldoAtual,

        sum(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS PontosPositivos,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 300 THEN QtdePontos ELSE 0 END) AS PontosPositivos300,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 200 THEN QtdePontos ELSE 0 END) AS PontosPositivos200,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 140 THEN QtdePontos ELSE 0 END) AS PontosPositivos140,
        sum(CASE WHEN QtdePontos > 0 AND diffDate <= 70 THEN QtdePontos ELSE 0 END) AS PontosPositivos70,
        
        sum(CASE WHEN QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS PontosNegativoVida,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 300 THEN QtdePontos ELSE 0 END) AS PontosNegativo300,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 200 THEN QtdePontos ELSE 0 END) AS PontosNegativo200,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 140 THEN QtdePontos ELSE 0 END) AS PontosNegativo140,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 70 THEN QtdePontos ELSE 0 END) AS PontosNegativo70
        
        
    
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
        count( CASE WHEN diffDate <= 300 THEN idTransacao END) AS qtd300,
        count( CASE WHEN diffDate <= 200 THEN idTransacao END) AS qtd200,
        count( CASE WHEN diffDate <= 140 THEN idTransacao END) AS qtd140,
        count( CASE WHEN diffDate <= 70 THEN idTransacao END) AS qtd70
            
    FROM tb_transacao_produto

    GROUP BY idCliente, DescNomeProduto
),

tb_cliente_produto_rn AS (

    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdVida DESC) AS rnVida,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd300 DESC) AS rn300,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd200 DESC) AS rn200,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd140 DESC) AS rn140,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd70 DESC) AS rn70

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


tb_cliente_periodo AS (

    SELECT 
        idCliente,
        CASE
                WHEN dtHora BETWEEN 7 AND 12 THEN 'MANHÃ'
                WHEN dtHora BETWEEN 12 AND 18 THEN 'TARDE'
                WHEN dtHora BETWEEN 19 AND 23 THEN 'NOITE'
                ELSE 'MADRUGADA'
            END AS periodo,
            count(*) AS qtdTransacao

    FROM tb_transacoes
    WHERE diffDate <= 200

GROUP BY 1,2 
),

tb_cliente_periodo_rn AS (

    SELECT *, 
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtdTransacao DESC) AS rnperiodo 
    FROM tb_cliente_periodo
),

tb_join AS ( 
 
    SELECT t1.*,
           t2.idadeBase,
           t3.DescNomeProduto AS produtoVida,
           t4.DescNomeProduto AS produto300,
           t5.DescNomeProduto AS produto200,
           t6.DescNomeProduto AS produto140,
           t7.DescNomeProduto AS produto70,
           COALESCE(t8.dtDia, -1) AS dtDia,
           COALESCE(t9.periodo, 'SEM INFORMAÇÃO') AS periodoFreq200

    FROM tb_sumario_transacoes AS t1

    LEFT JOIN tb_cliente AS t2
    ON t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.idCliente = t3.idCliente
    AND t3.rnVida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.idCliente = t4.idCliente
    AND t4.rn300 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.idCliente = t5.idCliente
    AND t5.rn200 = 1

    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.idCliente = t6.idCliente
    AND t6.rn140 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.idCliente = t7.idCliente
    AND t7.rn70 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.idCliente = t8.idCliente
    AND rnDia = 1

    LEFT JOIN tb_cliente_periodo_rn AS t9
    ON t1.idCliente = t9.idCliente
    AND t9.rnperiodo = 1

)

SELECT *,
       1.* qtdeTransacoes200 / qtdTransacoesVida AS engajamento200Vida
       
FROM tb_join



