-- 1. Definir os valores de corte dos quartis + min e max via janela analítica
WITH limites_quartis AS (
  SELECT DISTINCT
    PERCENTILE_CONT(age, 0.25) OVER () AS q1,
    PERCENTILE_CONT(age, 0.5)  OVER () AS q2,
    PERCENTILE_CONT(age, 0.75) OVER () AS q3,
    MIN(age) OVER () AS min_idade,
    MAX(age) OVER () AS max_idade
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
),

-- 2. Classificar cada pessoa colaboradora no quartil certo, usando os limites calculados
quartis_idade AS (
  SELECT 
    d.*,
    l.q1, l.q2, l.q3,
    CASE 
      WHEN d.age <= l.q1 THEN 'Q1'
      WHEN d.age <= l.q2 THEN 'Q2'
      WHEN d.age <= l.q3 THEN 'Q3'
      ELSE 'Q4'
    END AS quartil_idade
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados` d
  CROSS JOIN (SELECT * FROM limites_quartis LIMIT 1) l
),

-- 3. Taxa de inadimplência por quartil
inadimplencia_por_quartil AS (
  SELECT
    quartil_idade,
    COUNTIF(default_flag = 1) / COUNT(*) AS taxa_inadimplencia
  FROM quartis_idade
  GROUP BY quartil_idade
),

-- 4. Taxa de inadimplência geral
taxa_geral AS (
  SELECT 
    COUNTIF(default_flag = 1) / COUNT(*) AS taxa_inadimplencia_geral
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
)

-- 5. Calcular o Risco Relativo e mostrar os limites dos quartis
SELECT 
  q.quartil_idade,
  q.taxa_inadimplencia,
  t.taxa_inadimplencia_geral,
  ROUND(q.taxa_inadimplencia / t.taxa_inadimplencia_geral, 2) AS risco_relativo,
  l.q1, l.q2, l.q3,
  l.min_idade,
  l.max_idade
FROM inadimplencia_por_quartil q
CROSS JOIN taxa_geral t
CROSS JOIN (SELECT * FROM limites_quartis LIMIT 1) l
ORDER BY quartil_idade