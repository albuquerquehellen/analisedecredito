SELECT number_dependents, COUNT(*) AS qtd
FROM `laboratoria-risco-relativo-h.banco_dataset.users`
WHERE number_dependents IS NOT NULL
GROUP BY number_dependents
ORDER BY qtd DESC