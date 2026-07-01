-- Transform: stg_date → dim_date
-- Cast tipe data, tambah derived columns, deduplikasi

TRUNCATE TABLE dim_date;

INSERT INTO dim_date (
    date_id,
    full_date,
    year,
    quarter,
    month,
    month_name,
    week_of_year,
    day_of_month,
    day_of_week,
    day_name,
    is_weekend,
    is_holiday
)
SELECT DISTINCT ON (date_id)
    date_id,
    full_date::DATE,
    year::SMALLINT,
    quarter::SMALLINT,
    month::SMALLINT,
    month_name,
    week_of_year::SMALLINT,
    day_of_month::SMALLINT,
    day_of_week::SMALLINT,
    day_name,
    CASE WHEN LOWER(is_weekend) = 'true' THEN TRUE ELSE FALSE END AS is_weekend,
    CASE WHEN LOWER(is_holiday) = 'true' THEN TRUE ELSE FALSE END AS is_holiday
FROM stg_date
WHERE date_id IS NOT NULL
ORDER BY date_id;