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


-- 2. Deteksi Lonjakan Nilai Transaksi Sangat Besar (Anomali Nilai)
SELECT 
    f.transaction_id,
    f.transaction_code,
    c.full_name,
    f.transaction_type,
    f.amount,
    ch.channel_name
FROM fact_transactions f
JOIN dim_accounts a ON f.account_id = a.account_id
JOIN dim_customers c ON a.customer_id = c.customer_id
JOIN dim_channels ch ON f.channel_id = ch.channel_id
WHERE f.amount > 100000000 
ORDER BY f.amount DESC;