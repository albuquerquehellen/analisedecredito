SELECT
  faixa_credito_sem_garantia,
  COUNT(*) AS total_pessoas,
  SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes,
  ROUND(SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS taxa_inadimplencia_percentual
FROM
  `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
GROUP BY
  faixa_credito_sem_garantia
ORDER BY
  taxa_inadimplencia_percentual DESC;