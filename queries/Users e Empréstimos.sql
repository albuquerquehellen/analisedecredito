SELECT 
  u.user_id,
  
  -- Contagem total de empréstimos conhecidos (na loans_outstanding)
  COALESCE(SUM(CASE WHEN l.loan_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS total_loans,

  -- Quantidade por tipo
  COALESCE(SUM(CASE WHEN l.loan_type_standardized = 'REAL ESTATE' THEN 1 ELSE 0 END), 0) AS qtd_real_estate,
  COALESCE(SUM(CASE WHEN l.loan_type_standardized = 'OTHER' THEN 1 ELSE 0 END), 0) AS qtd_other,

  -- Flag de status final do empréstimo
  CASE 
    WHEN l.user_id IS NOT NULL THEN 'known'
    WHEN ld.user_id IS NOT NULL OR d.user_id IS NOT NULL THEN 'unknown'
    ELSE 'none'
  END AS final_loan_status

FROM 
  `laboratoria-risco-relativo-h.banco_dataset.users_limpo` u

-- Left join loans_outstanding
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.loans_outstanding_limpa` l
  ON u.user_id = l.user_id

-- Left join loans_detail
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.loans_detail` ld
  ON u.user_id = ld.user_id

-- Left join default
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` d
  ON u.user_id = d.user_id

GROUP BY 
  u.user_id,
  final_loan_status

ORDER BY 
  u.user_id
