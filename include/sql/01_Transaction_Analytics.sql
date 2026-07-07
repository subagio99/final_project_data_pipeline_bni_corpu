SELECT
    period_type,
    period_start_date,
    total_transactions,
    total_amount,
    avg_transaction_amount,
    success_transactions,
    failed_transactions,
    pending_transactions,
    previous_total_amount,
    growth_amount_pct
FROM mart_transaction_analytics
ORDER BY
    CASE
        WHEN period_type = 'DAY' THEN 1
        WHEN period_type = 'WEEK' THEN 2
        WHEN period_type = 'MONTH' THEN 3
        ELSE 4
    END,
    period_start_date;
