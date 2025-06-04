WITH stats AS (
  SELECT
    APPROX_QUANTILES(last_month_salary, 4) AS quartis
  FROM `laboratoria-risco-relativo-h.banco_dataset.users_tratado`
),

limits AS (
  SELECT
    quartis[OFFSET(1)] AS q1,
    quartis[OFFSET(3)] AS q3,
    (quartis[OFFSET(3)] - quartis[OFFSET(1)]) AS iqr
  FROM stats
)

SELECT
  user_id,
  last_month_salary,
  q1,
  q3,
  (q1 - 1.5 * iqr) AS lower_limit,
  (q3 + 1.5 * iqr) AS upper_limit,
  CASE
    WHEN last_month_salary = 0 THEN 'Igual a zero'
    WHEN last_month_salary < 1518 THEN 'Muito baixo (abaixo do limite arbitrário)'
    WHEN last_month_salary > (q3 + 1.5 * iqr) THEN 'Acima do limite'
    ELSE 'Dentro do intervalo'
  END AS salary_outlier_flag
FROM `laboratoria-risco-relativo-h.banco_dataset.users_tratado`, limits
WHERE last_month_salary = 0
   OR last_month_salary < 500
   OR last_month_salary > (q3 + 1.5 * iqr)
ORDER BY last_month_salary;

