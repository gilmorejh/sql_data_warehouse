/*
=========================================================
Gold Layer Views
Purpose: Defines curated, analytics-ready views that
standardize customer, product, and sales data into
business-friendly dimensional and fact structures.

These views serve as the primary reporting layer for
BI tools, dashboards, and downstream analytics by:
- Applying business logic and data cleansing
- Conforming dimensions and fact tables
- Ensuring consistent keys and naming conventions
=========================================================
*/

-- =========================================================
-- View: gold.dim_customers
-- Purpose: Provides a unified customer dimension by
-- combining CRM and ERP customer data, enriching records
-- with demographic attributes, and standardizing gender,
-- location, and lifecycle information for analytics.
-- =========================================================

IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
	DROP VIEW gold.dim_customers
GO

CREATE VIEW gold.dim_customers as
SELECT 
		ROW_NUMBER() OVER (ORDER BY cst_id) as customer_key,
		ci.cst_id as customer_id,
		ci.cst_key as customer_number,
		ci.cst_firstname as first_name,
		ci.cst_lastname as last_name,
		la.cntry as country,
		ci.cst_marital_status as marital_status,
		CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'N/A')
		END as gender,
		ca.bdate as birthdate,
		ci.cst_create_date as create_date				
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
		ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
		on ci.cst_key = la.cid


-- =========================================================
-- View: gold.dim_products
-- Purpose: Provides a product dimension containing
-- standardized product attributes, category hierarchy,
-- maintenance requirements, cost data, and lifecycle
-- tracking for product analytics and reporting.
-- =========================================================

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

-- =========================================================
-- View: gold.fact_sales
-- Purpose: Provides a sales fact table capturing
-- transactional order-level data, enabling revenue,
-- pricing, quantity, and customer/product performance
-- analysis across time.
-- =========================================================

IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_order_num as order_number,
pr.product_key,
cu.customer_id,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales,
sd.sls_quantity as quantity,
sd.sls_price as price
FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr
		ON sd.sls_product_key = pr.product_number
	LEFT JOIN gold.dim_customers cu
		ON sd.sls_cust_id = cu.customer_id