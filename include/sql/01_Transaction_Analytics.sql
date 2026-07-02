-- Analisis Tren Transaksi Harian, Mingguan, dan Bulanan
WITH monthly_trend AS (
    SELECT 
        d.year,
        d.month,
        d.month_name,
        COUNT(f.transaction_id) AS total_volume,
        SUM(f.amount) AS total_amount,
        -- Menghitung pertumbuhan dari bulan sebelumnya (MoM Growth)
        LAG(SUM(f.amount)) OVER (ORDER BY d.year, d.month) AS prev_month_amount
    FROM fact_transactions f
    JOIN dim_date d ON f.transaction_date = d.full_date
    GROUP BY d.year, d.month, d.month_name
)
SELECT 
    year,
    month_name,
    total_volume,
    total_amount,
    ROUND(((total_amount - prev_month_amount) / prev_month_amount) * 100, 2) AS mom_growth_percentage
FROM monthly_trend
ORDER BY year, month;

-- Untuk breakdown per Minggu & Hari
SELECT 
    d.year,
    d.week_of_year AS week,
    d.day_name,
    COUNT(f.transaction_id) AS daily_volume,
    SUM(f.amount) AS daily_amount
FROM fact_transactions f
JOIN dim_date d ON f.transaction_date = d.full_date
GROUP BY d.year, d.week_of_year, d.day_of_week, d.day_name
ORDER BY d.year, d.week_of_year, d.day_of_week;