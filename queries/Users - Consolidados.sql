SELECT 
  u.user_id,
  u.age,
  u.sex,
  u.salary_original,
  u.is_zero_salary,
  u.salary_imputed,
  u.dependents_original,
  u.dependents_flag,
  u.dependents_imputed,
  ld.using_lines_not_secured_personal_assets,
  ld.number_times_delayed_payment_loan_30_59_days,
  ld.debt_ratio,
  d.default_flag,  -- só a default_flag da tabela default
  ul.total_loans,
  ul.qtd_real_estate,
  ul.qtd_other,
  ul.final_loan_status
FROM 
  `laboratoria-risco-relativo-h.banco_dataset.users_limpos` u
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.loans_detail` ld ON u.user_id = ld.user_id
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` d ON u.user_id = d.user_id
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.users_loans` ul ON u.user_id = ul.user_id
