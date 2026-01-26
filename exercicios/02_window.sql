-- Quantidade de usuarios cadastrados (absoluto e acumulado) ao longo do tepmpo?
WITH tb_dia_cliente AS (

    SELECT substr(DtCriacao,1,10) AS dtDia,
        count(distinct idCliente) AS qtdCliente
        
    FROM clientes
    GROUP BY dtDia
),

tb_Acum AS (

    SELECT *,
        sum(qtdCliente) OVER (ORDER BY dtDia) AS qtdClienteAcum

    FROM tb_dia_cliente
)

SELECT * 
FROM tb_Acum
WHERE qtdClienteAcum > 3000
