-- Analisis Kinerja Produk Rekening
SELECT 
    a.account_type, 
    a.product_name, 
    COUNT(f.transaction_id) AS total_transaction_volume,
    SUM(f.amount) AS total_transaction_value,
    ROUND(AVG(f.balance_after), 2) AS average_retained_balance
FROM fact_transactions f
JOIN dim_accounts a ON f.account_id = a.account_id
GROUP BY a.account_type, a.product_name
ORDER BY total_transaction_value DESC;