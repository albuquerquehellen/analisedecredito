CREATE OR REPLACE VIEW laboratoria-risco-relativo-h.banco_dataset.consolidacao_users AS

SELECT 
  u.user_id,
  u.age,

  /* nova faixa etária */
  CASE
    WHEN u.age < 25 THEN 'Menor de 25'
    WHEN u.age BETWEEN 25 AND 40 THEN '25 a 40'
    WHEN u.age BETWEEN 41 AND 60 THEN '41 a 60'
    WHEN u.age BETWEEN 61 AND 80 THEN '61 a 80'
    WHEN u.age BETWEEN 81 AND 90 THEN '81 a 90'
    WHEN u.age > 90 THEN 'Acima de 90'
    ELSE 'Não informado'
  END AS faixa_etaria,

  u.sex,
  u.salary_original,
  u.is_zero_salary,
  u.salary_imputed,

  /* nova faixa salarial */
  CASE
    WHEN u.is_zero_salary = 1 THEN 'Não informado'
    WHEN u.salary_imputed <= 500 THEN 'Até 500'
    WHEN u.salary_imputed BETWEEN 501 AND 1500 THEN '501 a 1500'
    WHEN u.salary_imputed BETWEEN 1501 AND 3000 THEN '1501 a 3000'
    WHEN u.salary_imputed BETWEEN 3001 AND 5000 THEN '3001 a 5000'
    WHEN u.salary_imputed BETWEEN 5001 AND 10000 THEN '5001 a 10000'
    WHEN u.salary_imputed > 10000 THEN 'Acima de 10000'
    ELSE 'Não informado'
  END AS faixa_salario,

  u.dependents_original,
  u.dependents_flag,
  u.dependents_imputed,

  /* nova faixa de dependentes */
  CASE
    WHEN u.dependents_flag = 'vazio' THEN 'Não informado'
    WHEN u.dependents_imputed = 0 THEN 'Sem dependentes'
    WHEN u.dependents_imputed BETWEEN 1 AND 2 THEN '1 a 2'
    WHEN u.dependents_imputed BETWEEN 3 AND 5 THEN '3 a 5'
    WHEN u.dependents_imputed >= 6 THEN 'Mais de 6'
    ELSE 'Não informado'
  END AS faixa_dependentes,

  ld.using_lines_not_secured_personal_assets,
  ld.number_times_delayed_payment_loan_30_59_days,
  ld.debt_ratio,

  /* faixa crédito sem garantia (mantido) */
  CASE
  WHEN ld.using_lines_not_secured_personal_assets IS NULL THEN 'Não informado'
  WHEN ld.using_lines_not_secured_personal_assets < 0.2 THEN '< 20%'
  WHEN ld.using_lines_not_secured_personal_assets >= 0.2 AND ld.using_lines_not_secured_personal_assets <= 0.5 THEN '20–50%'
  WHEN ld.using_lines_not_secured_personal_assets > 0.5 AND ld.using_lines_not_secured_personal_assets <= 0.8 THEN '51–80%'
  WHEN ld.using_lines_not_secured_personal_assets > 0.8 THEN '> 80%'
  ELSE 'Outro'
END AS faixa_credito_sem_garantia,

  /* faixa debt ratio (mantido) */
CASE
  WHEN ld.debt_ratio IS NULL THEN 'Não informado'
  WHEN ld.debt_ratio < 0.2 THEN '< 0.2'
  WHEN ld.debt_ratio >= 0.2 AND ld.debt_ratio <= 0.5 THEN '0.2–0.5'
  WHEN ld.debt_ratio > 0.5 AND ld.debt_ratio <= 1 THEN '0.51–1'
  WHEN ld.debt_ratio > 1 THEN '> 1'
  ELSE 'Outro'
END AS faixa_debt_ratio,

  d.default_flag,
  ul.total_loans,
  ul.qtd_real_estate,
  ul.qtd_other,
  ul.final_loan_status

FROM 
  `laboratoria-risco-relativo-h.banco_dataset.users_limpos` u
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.loans_detail` ld 
  ON u.user_id = ld.user_id
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` d 
  ON u.user_id = d.user_id
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.users_loans` ul 
  ON u.user_id = ul.user_id
ORDER BY u.user_id;