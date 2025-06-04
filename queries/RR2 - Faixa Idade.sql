WITH base AS (
  SELECT
    -- Definir a faixa etária
    CASE
    WHEN age < 25 THEN 'Menor de 25'
    WHEN age BETWEEN 25 AND 40 THEN '25 a 40'
    WHEN age BETWEEN 41 AND 60 THEN '41 a 60'
    WHEN age BETWEEN 61 AND 80 THEN '61 a 80'
    WHEN age BETWEEN 81 AND 90 THEN '81 a 90'
    WHEN age > 90 THEN 'Acima de 90'
      ELSE 'Não informado'
    END AS faixa_etaria,
    default_flag
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
),

inadimplencia_por_faixa AS (
  SELECT
    faixa_etaria,
    COUNTIF(default_flag = 1) AS inadimplentes_faixa,
    COUNT(*) AS total_faixa,
    SAFE_DIVIDE(COUNTIF(default_flag = 1), COUNT(*)) AS taxa_inadimplencia_faixa
  FROM base
  GROUP BY faixa_etaria
),

inadimplencia_complemento AS (
  SELECT
    a.faixa_etaria,
    -- Somar inadimplentes e totais de todas as outras faixas (complemento)
    SUM(b.inadimplentes_faixa) AS inadimplentes_complemento,
    SUM(b.total_faixa) AS total_complemento,
    SAFE_DIVIDE(SUM(b.inadimplentes_faixa), SUM(b.total_faixa)) AS taxa_inadimplencia_complemento
  FROM inadimplencia_por_faixa a
  JOIN inadimplencia_por_faixa b ON a.faixa_etaria != b.faixa_etaria
  GROUP BY a.faixa_etaria
)

SELECT
  a.faixa_etaria,
  a.taxa_inadimplencia_faixa,
  c.taxa_inadimplencia_complemento,
  ROUND(SAFE_DIVIDE(a.taxa_inadimplencia_faixa, c.taxa_inadimplencia_complemento), 2) AS risco_relativo
FROM inadimplencia_por_faixa a
JOIN inadimplencia_complemento c ON a.faixa_etaria = c.faixa_etaria
ORDER BY risco_relativo DESC;