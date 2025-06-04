-- 1) Calcular a mediana de salário por perfil de inadimplência
WITH medianas AS (
  SELECT 
    d.default_flag,
    APPROX_QUANTILES(l.last_month_salary, 2)[OFFSET(1)] AS mediana_salarial
  FROM `laboratoria-risco-relativo-h.banco_dataset.users` AS l
  LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` AS d
    ON l.user_id = d.user_id
  WHERE l.last_month_salary IS NOT NULL
  GROUP BY d.default_flag
),

-- 2) Trazer todos os usuários com seus dados originais e default_flag
users_with_default AS (
  SELECT
    u.user_id,
    u.age,
    u.sex,
    u.last_month_salary,
    u.number_dependents,
    d.default_flag
  FROM `laboratoria-risco-relativo-h.banco_dataset.users` AS u
  LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` AS d
    ON u.user_id = d.user_id
),

-- 3) Aplicar tratamentos:
--    - dummy de salário zero
--    - substituir zeros por NULL e imputar pela mediana segmentada
--    - preencher dependentes nulos com zero
users_tratado AS (
  SELECT
    uwd.user_id,
    uwd.age,
    uwd.sex,
    
    -- valor original e tratado de salário
    uwd.last_month_salary    AS salary_original,
    CASE 
  WHEN uwd.last_month_salary = 0 OR uwd.last_month_salary IS NULL THEN 1 
  ELSE 0 
END AS is_zero_salary,
    COALESCE(NULLIF(uwd.last_month_salary, 0), m.mediana_salarial) AS salary_imputed,
    
    -- valor original e tratado de dependentes
    uwd.number_dependents AS dependents_original,
COALESCE(uwd.number_dependents, 0) AS dependents_imputed,
CASE 
  WHEN uwd.number_dependents IS NULL THEN 'vazio'
  ELSE 'preenchido'
END AS dependents_flag,
    
    uwd.default_flag
  FROM users_with_default uwd
  LEFT JOIN medianas m
    ON uwd.default_flag = m.default_flag
)

-- 4) Selecionar tabela completa com campos originais e tratados
SELECT
  user_id,
  age,
  sex,
  salary_original,
  is_zero_salary,
  salary_imputed,
  dependents_original,
  dependents_flag,
  dependents_imputed,
  default_flag
FROM users_tratado
ORDER BY user_id;