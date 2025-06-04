WITH medianas AS (
  SELECT 
    d.default_flag,
    APPROX_QUANTILES(l.last_month_salary, 2)[OFFSET(1)] AS mediana_salarial
  FROM `laboratoria-risco-relativo-h.banco_dataset.users` AS l
  LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` AS d
  ON l.user_id = d.user_id
  WHERE l.last_month_salary IS NOT NULL
  GROUP BY d.default_flag
)

SELECT 
  l.user_id,
  d.default_flag,
  COALESCE(l.last_month_salary, m.mediana_salarial) AS last_month_salary_tratado
FROM `laboratoria-risco-relativo-h.banco_dataset.users` AS l
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` AS d
ON l.user_id = d.user_id
LEFT JOIN medianas AS m
ON d.default_flag = m.default_flag
