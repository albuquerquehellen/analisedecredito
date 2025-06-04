-- Variáveis da tabela user_info
WITH user_info_stats AS (
  SELECT
    APPROX_QUANTILES(age, 4) AS age_quartiles,
    APPROX_QUANTILES(`last_month_salary`, 4) AS salary_quartiles,
    APPROX_QUANTILES(`number_dependents`, 4) AS dependents_quartiles
  FROM `laboratoria-risco-relativo-h.banco_dataset.users`
)

-- Outliers na tabela user_info (idade)
SELECT 
  ui.user_id,
  ui.age,
  CASE 
    WHEN ui.age < (stats.age_quartiles[OFFSET(1)] - 1.5 * (stats.age_quartiles[OFFSET(3)] - stats.age_quartiles[OFFSET(1)]))
         OR ui.age > (stats.age_quartiles[OFFSET(3)] + 1.5 * (stats.age_quartiles[OFFSET(3)] - stats.age_quartiles[OFFSET(1)]))
    THEN 1 ELSE 0
  END AS age_outlier
FROM `laboratoria-risco-relativo-h.banco_dataset.users` ui
CROSS JOIN user_info_stats stats
WHERE 
  CASE 
    WHEN ui.age < (stats.age_quartiles[OFFSET(1)] - 1.5 * (stats.age_quartiles[OFFSET(3)] - stats.age_quartiles[OFFSET(1)]))
         OR ui.age > (stats.age_quartiles[OFFSET(3)] + 1.5 * (stats.age_quartiles[OFFSET(3)] - stats.age_quartiles[OFFSET(1)]))
    THEN 1 ELSE 0
  END = 1