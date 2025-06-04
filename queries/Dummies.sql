SELECT
  user_id,
  -- Dummies para Número de Dependentes (RR>1)
  CASE WHEN faixa_dependentes IN ('3 a 5', 'Mais de 6') THEN 1 ELSE 0 END AS dep_risco,
  
  -- Dummy para Faixa Etária (25 a 40 anos)
  CASE WHEN faixa_etaria = '25 a 40' THEN 1 ELSE 0 END AS idade_risco,
  
  -- Dummies para Faixa Salarial (R$501 a 1500 e 1501 a 3000)
  CASE WHEN faixa_salario IN ('501 a 1500', '1501 a 3000') THEN 1 ELSE 0 END AS salario_risco,
  
  -- Dummy para Crédito Sem Garantia (>80%)
  CASE WHEN faixa_credito_sem_garantia = '> 80%' THEN 1 ELSE 0 END AS credito_risco,
  
  -- Dummy para Debt Ratio (0.51 a 1)
  CASE WHEN faixa_debt_ratio = '0.51–1' THEN 1 ELSE 0 END AS debt_ratio_risco,

    -- Dummy para Delayed Payment 30-59 (>0)
  CASE WHEN number_times_delayed_payment_loan_30_59_days >= 1 THEN 1 ELSE 0 END AS delayed_payment_risco,
  
  -- Outras colunas originais que quiser trazer
  default_flag,
FROM laboratoria-risco-relativo-h.banco_dataset.dados_atualizados;