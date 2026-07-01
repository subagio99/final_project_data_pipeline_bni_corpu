-- Transform: stg_accounts → dim_accounts
-- Cast tipe data, tambah derived columns, deduplikasi

TRUNCATE TABLE dim_accounts;

INSERT INTO dim_accounts (
    account_id,
    account_no,
    account_type,
    product_name,
    currency,
    open_date,
    close_date,
    status,
    interest_rate,
    customer_id,
    branch_id,
    -- derived columns
    account_age_years,
    interest_segment
)
SELECT DISTINCT ON (account_id)
    account_id,
    account_no,
    UPPER(account_type) AS account_type,
    product_name,
    UPPER(currency) AS currency,
    open_date::DATE,
    -- close_date bisa kosong/null jika status masih ACTIVE
    CASE 
        WHEN close_date = '' OR close_date IS NULL THEN NULL 
        ELSE close_date::DATE 
    END AS close_date,
    UPPER(status) AS status,
    interest_rate,
    customer_id,
    branch_id,
    -- 1. Derived Column: Menghitung umur rekening sejak tanggal buka hingga sekarang (atau hingga tanggal tutup jika sudah tidak aktif)
    CASE
        WHEN close_date = '' OR close_date IS NULL THEN DATE_PART('year', AGE(CURRENT_DATE, open_date::DATE))::SMALLINT
        ELSE DATE_PART('year', AGE(close_date::DATE, open_date::DATE))::SMALLINT
    END AS account_age_years,
    -- 2. Derived Column: Segmentasi berdasarkan besaran suku bunga
    CASE 
        WHEN interest_rate = 0 THEN 'No Interest'
        WHEN interest_rate < 2.0 THEN 'Low Interest'
        WHEN interest_rate < 4.0 THEN 'Medium Interest'
        ELSE 'High Interest'
    END AS interest_segment
FROM stg_accounts
WHERE account_id IS NOT NULL
ORDER BY account_id;