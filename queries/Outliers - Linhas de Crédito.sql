WITH stats AS (
  SELECT
    PERCENTILE_CONT(using_lines_not_secured_personal_assets, 0.25) OVER() AS q1,
    PERCENTILE_CONT(using_lines_not_secured_personal_assets, 0.75) OVER() AS q3
  FROM `laboratoria-risco-relativo-h.banco_dataset.loans_detail`
),
limits AS (
  SELECT
    q1,
    q3,
    (q3 - q1) AS iqr,
    (q1 - 1.5 * (q3 - q1)) AS lower_limit,
    (q3 + 1.5 * (q3 - q1)) AS upper_limit
  FROM stats
  LIMIT 1
)
SELECT
  u.user_id,
  u.using_lines_not_secured_personal_assets,
  l.lower_limit,
  l.upper_limit,
  CASE 
    WHEN u.using_lines_not_secured_personal_assets < l.lower_limit THEN 'Abaixo do limite'
    WHEN u.using_lines_not_secured_personal_assets > l.upper_limit THEN 'Acima do limite'
  END AS outlier_type
FROM
  `laboratoria-risco-relativo-h.banco_dataset.loans_detail` u,
  limits l
WHERE 
  u.using_lines_not_secured_personal_assets < l.lower_limit
  OR u.using_lines_not_secured_personal_assets > l.upper_limit
ORDER BY u.using_lines_not_secured_personal_assets;
