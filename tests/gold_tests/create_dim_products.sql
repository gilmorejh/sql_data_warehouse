IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
	DROP VIEW gold.dim_products
GO

CREATE VIEW gold.dim_products as
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start, pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as sub_category,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start as start_date -- Fix column naming in load_silver
FROM silver.crm_prd_info pn
	LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filters out historical data


-- Checking for duplicates
SELECT prd_key, COUNT(*) FROM
(
SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_cost,
pn.prd_line,
pn.prd_start, -- Fix column naming in load_silver
pc.cat,
pc.subcat,
pc.maintenance
FROM silver.crm_prd_info pn
	LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filters out historical data
)t GROUP BY prd_key
HAVING COUNT(*) > 1
