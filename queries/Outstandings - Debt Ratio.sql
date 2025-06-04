WITH stats AS (
  SELECT 
    APPROX_QUANTILES(debt_ratio, 4) AS quartis
  FROM `laboratoria-risco-relativo-h.banco_dataset.loans_detail`
),

limits AS (
  SELECT
    quartis[OFFSET(1)] AS q1,
    quartis[OFFSET(3)] AS q3,
    (quartis[OFFSET(3)] - quartis[OFFSET(1)]) AS iqr
  FROM stats
),

outliers_debt_ratio AS (
  SELECT 
    u.user_id,
    u.debt_ratio,
    l.q1,
    l.q3,
    (l.q1 - 1.5 * l.iqr) AS lower_limit,
    (l.q3 + 1.5 * l.iqr) AS upper_limit,
    CASE 
      WHEN u.debt_ratio < (l.q1 - 1.5 * l.iqr) THEN 'Abaixo do limite'
      WHEN u.debt_ratio > (l.q3 + 1.5 * l.iqr) THEN 'Acima do limite'
    END AS classificacao_outlier
  FROM `laboratoria-risco-relativo-h.banco_dataset.loans_detail` u
  CROSS JOIN limits l
  WHERE u.debt_ratio < (l.q1 - 1.5 * l.iqr)
     OR u.debt_ratio > (l.q3 + 1.5 * l.iqr)
)

SELECT user_id, debt_ratio, classificacao_outlier
FROM outliers_debt_ratio
ORDER BY debt_ratio DESC;
