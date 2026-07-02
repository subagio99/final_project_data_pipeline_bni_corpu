-- Analisis Performa Cabang Tertinggi per Region
WITH branch_ranking AS (
    SELECT 
        b.region,
        b.branch_id,
        b.branch_name,
        COUNT(f.transaction_id) AS total_volume,
        SUM(f.amount) AS total_value,
        RANK() OVER (PARTITION BY b.region ORDER BY SUM(f.amount) DESC) AS rank_in_region
    FROM fact_transactions f
    JOIN dim_branches b ON f.branch_id = b.branch_id
    GROUP BY b.region, b.branch_id, b.branch_name
)
SELECT 
    region,
    branch_name,
    total_volume,
    total_value
FROM branch_ranking
WHERE rank_in_region = 1
ORDER BY total_value DESC;