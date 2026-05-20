-- ============================================================
-- Quality Check: bronze_erp_cust_a101
-- Database:      DataWarehouse
-- Run BEFORE loading into silver_erp_cust_a101 to catch issues
-- ============================================================

USE DataWarehouse;

-- CHECK 1: Duplicates & NULL on primary key (cid)
-- Expect: 0 rows returned
SELECT cid, COUNT(*) AS cnt
FROM bronze_erp_cust_a101
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL;

-- -------------------------------------------------------

-- CHECK 2: NULL or empty values across all columns
-- Expect: all counts = 0
SELECT
    SUM(CASE WHEN cid   IS NULL OR TRIM(cid)   = '' THEN 1 ELSE 0 END) AS null_cid,
    SUM(CASE WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 1 ELSE 0 END) AS null_cntry
FROM bronze_erp_cust_a101;

-- -------------------------------------------------------

-- CHECK 3: Unwanted whitespace in text fields
-- Expect: 0 rows returned for each
SELECT cid   FROM bronze_erp_cust_a101 WHERE cid   != TRIM(cid);
SELECT cntry FROM bronze_erp_cust_a101 WHERE cntry != TRIM(cntry);

-- -------------------------------------------------------

-- CHECK 4: Distinct country values (standardization check)
-- Review: look for misspellings, inconsistent codes (e.g. 'US' vs 'USA' vs 'United States')
SELECT cntry, COUNT(*) AS cnt
FROM bronze_erp_cust_a101
GROUP BY cntry
ORDER BY cnt DESC;

-- -------------------------------------------------------

-- CHECK 5: Overall row count (baseline reference)
SELECT COUNT(*) AS total_rows FROM bronze_erp_cust_a101;