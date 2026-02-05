/*
+++++++++++++++++++++++++++++++++++++++++++
Data Cleaning & Transformation: CRM Customer Info
+++++++++++++++++++++++++++++++++++++++++++
Purpose:
	This script transforms raw customer data from the Bronze layer into the Silver layer.
	It standardizes text fields, normalizes marital status and gender values, removes
	duplicate records by retaining the most recent entry per customer, and filters
	out invalid records. The result is a cleaner, more consistent dataset ready for
	downstream analytics and modeling.
*/

-- Clean bronze.crm_cust_info
INSERT INTO silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 ELSE 'N/A'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 ELSE 'N/A'
END cst_gndr,
cst_create_date
FROM(
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE flag_last = 1 
