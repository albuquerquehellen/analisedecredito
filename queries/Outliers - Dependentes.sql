SELECT
  user_id,
  number_dependents,
  CASE
    WHEN number_dependents < -1.5 THEN 'Abaixo do limite'
    WHEN number_dependents > 2.5 THEN 'Acima do limite'
  END AS dependents_outlier_flag
FROM `laboratoria-risco-relativo-h.banco_dataset.users_tratado`
WHERE number_dependents < -1.5
   OR number_dependents > 2.5
ORDER BY number_dependents DESC;
