-- =============================================================
-- DDL Script: Bronze Layer Tables
-- Database:   DataWarehouse
-- Schema:     bronze
-- =============================================================

USE DataWarehouse;

CREATE SCHEMA bronze;

-- CRM: Customer Information
CREATE TABLE bronze_crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gender         NVARCHAR(50),
    cst_create_date    DATE
);

-- CRM: Product Information
CREATE TABLE bronze_crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);

-- CRM: Sales Details
CREATE TABLE bronze_crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

-- ERP: Customer Demographics
CREATE TABLE bronze_erp_cust_az12 (
    id    NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);

-- ERP: Customer Location
CREATE TABLE bronze_erp_cust_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50)
);

-- ERP: Product Category
CREATE TABLE bronze_erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
