-- Pasien/Nasabah Paling Aktif (Top 10)
SELECT 
    c.customer_id,
    c.full_name,
    c.segment,
    COUNT(f.transaction_id) AS transaction_frequency,
    SUM(f.amount) AS total_transaction_value,
    RANK() OVER (ORDER BY SUM(f.amount) DESC) AS rank_by_value
FROM fact_transactions f
JOIN dim_accounts a ON f.account_id = a.account_id
JOIN dim_customers c ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.segment
ORDER BY total_transaction_value DESC
LIMIT 10;

-- Distribusi Transaksi per Segmen Nasabah
SELECT 
    c.segment,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(f.transaction_id) AS total_volume,
    SUM(f.amount) AS total_value,
    ROUND(AVG(f.amount), 2) AS average_ticket_size
FROM fact_transactions f
JOIN dim_accounts a ON f.account_id = a.account_id
JOIN dim_customers c ON a.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_value DESC;