-- ============================================================
-- Quality Check: bronze_erp_px_cat_g1v2
-- Database:      DataWarehouse
-- Run BEFORE loading into silver_erp_px_cat_g1v2 to catch issues
-- ============================================================

USE DataWarehouse;

-- CHECK 1: Duplicates & NULL on primary key (id)
-- Expect: 0 rows returned
SELECT id, COUNT(*) AS cnt
FROM bronze_erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1 OR id IS NULL;

-- -------------------------------------------------------

-- CHECK 2: NULL or empty values across all columns
-- Expect: all counts = 0
SELECT
    SUM(CASE WHEN id          IS NULL OR TRIM(id)          = '' THEN 1 ELSE 0 END) AS null_id,
    SUM(CASE WHEN cat         IS NULL OR TRIM(cat)         = '' THEN 1 ELSE 0 END) AS null_cat,
    SUM(CASE WHEN subcat      IS NULL OR TRIM(subcat)      = '' THEN 1 ELSE 0 END) AS null_subcat,
    SUM(CASE WHEN maintenance IS NULL OR TRIM(maintenance) = '' THEN 1 ELSE 0 END) AS null_maintenance
FROM bronze_erp_px_cat_g1v2;

-- -------------------------------------------------------

-- CHECK 3: Unwanted whitespace in text fields
-- Expect: 0 rows returned for each
SELECT id          FROM bronze_erp_px_cat_g1v2 WHERE id          != TRIM(id);
SELECT cat         FROM bronze_erp_px_cat_g1v2 WHERE cat         != TRIM(cat);
SELECT subcat      FROM bronze_erp_px_cat_g1v2 WHERE subcat      != TRIM(subcat);
SELECT maintenance FROM bronze_erp_px_cat_g1v2 WHERE maintenance != TRIM(maintenance);

-- -------------------------------------------------------

-- CHECK 4: Distinct category values (standardization check)
-- Review: confirm all category names are consistent
SELECT cat, COUNT(*) AS cnt
FROM bronze_erp_px_cat_g1v2
GROUP BY cat
ORDER BY cnt DESC;

-- -------------------------------------------------------

-- CHECK 5: Distinct subcategory values per category (standardization check)
-- Review: confirm subcategories map correctly to categories
SELECT cat, subcat, COUNT(*) AS cnt
FROM bronze_erp_px_cat_g1v2
GROUP BY cat, subcat
ORDER BY cat, subcat;

-- -------------------------------------------------------

-- CHECK 6: Distinct maintenance values (standardization check)
-- Review: expect a small set of values (e.g. 'Yes', 'No')
SELECT maintenance, COUNT(*) AS cnt
FROM bronze_erp_px_cat_g1v2
GROUP BY maintenance
ORDER BY cnt DESC;

-- -------------------------------------------------------

-- CHECK 7: Overall row count (baseline reference)
SELECT COUNT(*) AS total_rows FROM bronze_erp_px_cat_g1v2;