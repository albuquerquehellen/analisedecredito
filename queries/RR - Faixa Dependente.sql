-- 1. Taxa de inadimplência por faixa de dependentes
WITH inadimplencia_por_faixa AS (
  SELECT
    faixa_dependentes,
    COUNTIF(default_flag = 1) / COUNT(*) AS taxa_inadimplencia
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
  GROUP BY faixa_dependentes
),

-- 2. Taxa de inadimplência geral
taxa_geral AS (
  SELECT 
    COUNTIF(default_flag = 1) / COUNT(*) AS taxa_inadimplencia_geral
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
)

-- 3. Calcular o Risco Relativo
SELECT
  f.faixa_dependentes,
  f.taxa_inadimplencia,
  g.taxa_inadimplencia_geral,
  ROUND(f.taxa_inadimplencia / g.taxa_inadimplencia_geral, 2) AS risco_relativo
FROM inadimplencia_por_faixa f
CROSS JOIN taxa_geral g
ORDER BY risco_relativo DESC