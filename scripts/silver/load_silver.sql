-- =============================================================
-- Load Script: Silver Layer Tables
-- Database:    DataWarehouse
-- Schema:      silver
-- Run after:   load_bronze.sql
-- =============================================================

USE DataWarehouse;

-- -------------------------------------------------------------
-- CRM: Customer Information
-- -------------------------------------------------------------
TRUNCATE TABLE silver_crm_cust_info;

SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

INSERT INTO silver_crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gender,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname)                                   AS cst_firstname,
    TRIM(cst_lastname)                                    AS cst_lastname,
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END                                                   AS cst_marital_status,
    CASE
        WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END                                                   AS cst_gender,
    NULLIF(cst_create_date, '0000-00-00')                 AS cst_create_date
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last_record
    FROM bronze_crm_cust_info
) t
WHERE flag_last_record = 1;

SET SESSION sql_mode = DEFAULT;

SELECT * FROM silver_crm_cust_info;
SELECT COUNT(*) FROM silver_crm_cust_info;

-- -------------------------------------------------------------
-- CRM: Product Information
-- -------------------------------------------------------------
TRUNCATE TABLE silver_crm_prd_info;

INSERT INTO silver_crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')          AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key))               AS prd_key,
    prd_nm,
    IFNULL(prd_cost, 0)                                  AS prd_cost,
    CASE
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        ELSE 'n/a'
    END                                                  AS prd_line,
    CAST(prd_start_dt AS DATE)                           AS prd_start_dt,
    CAST(
        LEAD(prd_start_dt) OVER (
            PARTITION BY REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')
            ORDER BY prd_start_dt
        ) - INTERVAL 1 DAY
    AS DATE)                                             AS prd_end_dt
FROM bronze_crm_prd_info;

SELECT * FROM silver_crm_prd_info;
SELECT COUNT(*) FROM silver_crm_prd_info;

-- -------------------------------------------------------------
-- CRM: Sales Details          [TODO: add cleaning logic]
-- -------------------------------------------------------------

-- -------------------------------------------------------------
-- ERP: Customer Demographics  [TODO: add cleaning logic]
-- -------------------------------------------------------------

-- -------------------------------------------------------------
-- ERP: Customer Location      [TODO: add cleaning logic]
-- -------------------------------------------------------------

-- -------------------------------------------------------------
-- ERP: Product Category       [TODO: add cleaning logic]
-- -------------------------------------------------------------