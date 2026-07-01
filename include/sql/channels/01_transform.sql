-- Transform: stg_channels → dim_channels
-- Cast tipe data, tambah derived columns, deduplikasi

TRUNCATE TABLE dim_channels;

INSERT INTO dim_channels (
    channel_id,
    channel_code,
    channel_name,
    channel_category,
    is_digital,
    description,
    -- derived columns
    channel_classification
)
SELECT DISTINCT ON (channel_id)
    channel_id,
    UPPER(channel_code) AS channel_code,
    channel_name,
    UPPER(channel_category) AS channel_category,
    CASE WHEN LOWER(is_digital) = 'true' THEN TRUE ELSE FALSE END AS is_digital,
    description,
    -- 1. Derived Column: Klasifikasi gabungan antara kategori fisik/digital dan is_digital
    CASE 
        WHEN CASE WHEN LOWER(is_digital) = 'true' THEN TRUE ELSE FALSE END = TRUE THEN 'Digital Service'
        WHEN UPPER(channel_category) = 'PHYSICAL' THEN 'Conventional Physical'
        ELSE 'Hybrid / Other'
    END AS channel_classification
FROM stg_channels
WHERE channel_id IS NOT NULL
ORDER BY channel_id;