-- Check for duplicate entries in primary key
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 or prd_id IS NULL

-- Check for null or negative product costs
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 or prd_cost IS NULL

-- Find distinct product types
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for invalid dates
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start

-- Check for duplicate entries in primary key
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 or prd_id IS NULL

-- Check for null or negative product costs
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 or prd_cost IS NULL

-- Find distinct product types
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for invalid dates
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start


-- Testing for start and end date corrections
SELECT
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509')