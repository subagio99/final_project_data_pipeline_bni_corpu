-- Dominasi Penggunaan Channel dan Tren Migrasi Digital
SELECT 
    d.year,
    d.month_name,
    ch.channel_name,
    ch.channel_classification,
    COUNT(f.transaction_id) AS volume,
    SUM(f.amount) AS value,
    -- Proporsi volume channel dibanding seluruh transaksi pada bulan tersebut
    ROUND(COUNT(f.transaction_id) * 100.0 / SUM(COUNT(f.transaction_id)) OVER (PARTITION BY d.year, d.month), 2) AS volume_share_percentage
FROM fact_transactions f
JOIN dim_channels ch ON f.channel_id = ch.channel_id
JOIN dim_date d ON f.transaction_date = d.full_date
GROUP BY d.year, d.month, d.month_name, ch.channel_name, ch.channel_classification
ORDER BY d.year, d.month, volume DESC;