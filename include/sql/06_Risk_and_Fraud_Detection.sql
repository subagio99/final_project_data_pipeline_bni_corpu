-- 1. Deteksi Nasabah dengan Frekuensi Transaksi 'FAILED' yang Tidak Wajar dalam Sehari
SELECT 
    f.transaction_date,
    c.customer_id,
    c.full_name,
    COUNT(f.transaction_id) AS total_failed_attempts
FROM fact_transactions f
JOIN dim_accounts a ON f.account_id = a.account_id
JOIN dim_customers c ON a.customer_id = c.customer_id
WHERE UPPER(f.status) = 'FAILED'
GROUP BY f.transaction_date, c.customer_id, c.full_name
HAVING COUNT(f.transaction_id) >= 5 
ORDER BY total_failed_attempts DESC;
