/*
++++++++++++++++++++++++++++
Exploratory Data Validation
++++++++++++++++++++++++++++
Purpose:
	This script contains exploratory queries used to assess data quality
	across Bronze and Silver for crm_cust_info. Each query is intended to be run
	individually to identify null values, duplicate primary keys, unwanted
	whitespace, and inconsistencies in standardized fields.
*/


-- Check for Nulls or Duplicates in Primary Key

SELECT
cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL

-- Check for unwanted spaces

SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


-- Check data standarization
SELECT cst_gndr, cst_marital_status
FROM bronze.crm_cust_info

-- Check silver table data for fix
-- Check for Nulls or Duplicates in Primary Key

SELECT
cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL

-- Check for unwanted spaces

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


-- Check data standarization
SELECT DISTINCT cst_gndr, cst_marital_status
FROM silver.crm_cust_info
