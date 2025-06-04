WITH base AS (
  SELECT
    -- Definir a faixa de debt ratio
    CASE
      WHEN debt_ratio IS NULL THEN 'Não informado'
      WHEN debt_ratio < 0.2 THEN '< 0.2'
      WHEN debt_ratio >= 0.2 AND debt_ratio <= 0.5 THEN '0.2–0.5'
      WHEN debt_ratio > 0.5 AND debt_ratio <= 1 THEN '0.51–1'
      WHEN debt_ratio > 1 THEN '> 1'
      ELSE 'Outro'
    END AS faixa_debt_ratio,
    default_flag
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
),

inadimplencia_por_faixa AS (
  SELECT
    faixa_debt_ratio,
    COUNTIF(default_flag = 1) AS inadimplentes_faixa,
    COUNT(*) AS total_faixa,
    SAFE_DIVIDE(COUNTIF(default_flag = 1), COUNT(*)) AS taxa_inadimplencia_faixa
  FROM base
  GROUP BY faixa_debt_ratio
),

inadimplencia_complemento AS (
  SELECT
    a.faixa_debt_ratio,
    SUM(b.inadimplentes_faixa) AS inadimplentes_complemento,
    SUM(b.total_faixa) AS total_complemento,
    SAFE_DIVIDE(SUM(b.inadimplentes_faixa), SUM(b.total_faixa)) AS taxa_inadimplencia_complemento
  FROM inadimplencia_por_faixa a
  JOIN inadimplencia_por_faixa b ON a.faixa_debt_ratio != b.faixa_debt_ratio
  GROUP BY a.faixa_debt_ratio
)

SELECT
  a.faixa_debt_ratio,
  a.taxa_inadimplencia_faixa,
  c.taxa_inadimplencia_complemento,
  ROUND(SAFE_DIVIDE(a.taxa_inadimplencia_faixa, c.taxa_inadimplencia_complemento), 2) AS risco_relativo
FROM inadimplencia_por_faixa a
JOIN inadimplencia_complemento c ON a.faixa_debt_ratio = c.faixa_debt_ratio
ORDER BY risco_relativo DESC;