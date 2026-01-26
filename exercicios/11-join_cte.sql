-- Quem iniciou o curso no primeiro dia, assistiu quantas aulas?

-- Quem participou da primeira aula
WITH tb_prim_dia AS (

    SELECt DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao,1,10) = '2025-08-25'
),

-- Quem participou do Curso inteiro
tb_dias_curso AS (
    SELECT DISTINCT
            idCliente,
            substr(DtCriacao,1,10) AS presenteDia
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
    ORDER BY idCliente, presenteDia
),

-- Contando quantas vezes quem particpou do primeiro dia voltou
tb_cliente_dias AS (


    SELECT t1.idCliente,
        count(DISTINCT t2.presenteDia) AS qtdDia

    FROM tb_prim_dia AS t1

    LEFT JOIN tb_dias_curso AS t2
    ON t1.idCliente = t2.idCliente

    GROUP BY t1.idCliente
)

-- Calcula a média
SELECT avg(qtdDia)
FROM tb_cliente_dias

