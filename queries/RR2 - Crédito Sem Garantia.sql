WITH base AS (
  SELECT
    -- Definir a faixa de uso de crédito sem garantia
    CASE
      WHEN using_lines_not_secured_personal_assets IS NULL THEN 'Não informado'
      WHEN using_lines_not_secured_personal_assets < 0.2 THEN '< 20%'
      WHEN using_lines_not_secured_personal_assets >= 0.2 AND using_lines_not_secured_personal_assets <= 0.5 THEN '20–50%'
      WHEN using_lines_not_secured_personal_assets > 0.5 AND using_lines_not_secured_personal_assets <= 0.8 THEN '51–80%'
      WHEN using_lines_not_secured_personal_assets > 0.8 THEN '> 80%'
      ELSE 'Outro'
    END AS faixa_credito_sem_garantia,
    default_flag
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
),

inadimplencia_por_faixa AS (
  SELECT
    faixa_credito_sem_garantia,
    COUNTIF(default_flag = 1) AS inadimplentes_faixa,
    COUNT(*) AS total_faixa,
    SAFE_DIVIDE(COUNTIF(default_flag = 1), COUNT(*)) AS taxa_inadimplencia_faixa
  FROM base
  GROUP BY faixa_credito_sem_garantia
),

inadimplencia_complemento AS (
  SELECT
    a.faixa_credito_sem_garantia,
    SUM(b.inadimplentes_faixa) AS inadimplentes_complemento,
    SUM(b.total_faixa) AS total_complemento,
    SAFE_DIVIDE(SUM(b.inadimplentes_faixa), SUM(b.total_faixa)) AS taxa_inadimplencia_complemento
  FROM inadimplencia_por_faixa a
  JOIN inadimplencia_por_faixa b ON a.faixa_credito_sem_garantia != b.faixa_credito_sem_garantia
  GROUP BY a.faixa_credito_sem_garantia
)

SELECT
  a.faixa_credito_sem_garantia,
  a.taxa_inadimplencia_faixa,
  c.taxa_inadimplencia_complemento,
  ROUND(SAFE_DIVIDE(a.taxa_inadimplencia_faixa, c.taxa_inadimplencia_complemento), 2) AS risco_relativo
FROM inadimplencia_por_faixa a
JOIN inadimplencia_complemento c ON a.faixa_credito_sem_garantia = c.faixa_credito_sem_garantia
ORDER BY risco_relativo DESC;