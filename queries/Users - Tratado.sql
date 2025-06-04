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

users_com_default AS (
  SELECT
    u.*,
    d.default_flag
  FROM `laboratoria-risco-relativo-h.banco_dataset.users` u
  LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` d
    ON u.user_id = d.user_id
),

users_tratados AS (
  SELECT
    ucd.user_id,
    ucd.age,
    ucd.sex,
    COALESCE(ucd.last_month_salary, m.mediana_salarial) AS last_month_salary_tratado,
    COALESCE(ucd.number_dependents, 0) AS number_dependents_tratado
  FROM users_com_default ucd
  LEFT JOIN medianas m
    ON ucd.default_flag = m.default_flag
)

SELECT
  u.user_id,
  u.age,
  u.sex,
  ut.last_month_salary_tratado AS last_month_salary,
  ut.number_dependents_tratado AS number_dependents
FROM `laboratoria-risco-relativo-h.banco_dataset.users` u
JOIN users_tratados ut
  ON u.user_id = ut.user_id
ORDER BY u.user_id;
