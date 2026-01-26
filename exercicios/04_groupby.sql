-- Quantos produtos são de rpg?
SELECT IdProduto,
       count(*) 

FROM produtos

WHERE DescCategoriaProduto = 'rpg';

SELECT DescCategoriaProduto,
       count(*)

FROM produtos

GROUP BY DescCategoriaProduto