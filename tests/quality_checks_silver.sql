/*
====================================
Quality Checks
====================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy and standardization across the 'silver' schemas.
  It includes checks for:
  - Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standardization and consistency.
  - Invalid date ranges and orders.
  - Data consistency between related fields.
Usage Notes:
  - Run these checks after data loading Silver Layer.
  - Investigate and resolve any discrepancies found during the checks
*/

/*
----------------------
silver.crm_cust_info table
----------------------
*/

-- Check for NULLs or Duplicates in primary key
-- Expectation: No results

SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted spaces
-- Expectation: No results

SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT
cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT
cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

-- Data Standardization & Consistency

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info

/*
----------------------
silver.crm_prd_info table
----------------------
*/

-- Check for NULLs or Duplicates in primary key
-- Expectation: No results

SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted spaces
-- Expectation: No results

SELECT
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULLs or Negative Numbers
-- Expectation: No results

SELECT
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency

SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for invalid date orders

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT * FROM silver.crm_prd_info

/*
----------------------
silver.crm_sales_details
----------------------
*/

-- Check for unwanted spaces
-- Expectation: No results

SELECT
sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Check the integrity
-- Expectation: No result

SELECT * 
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT * 
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- Check the invalid dates
-- Expectation: No result

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check sales, quantity and price
-- Expectation: No result

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales < 0 OR sls_quantity < 0 OR sls_price < 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT * FROM silver.crm_sales_details


/*
----------------------
silver.erp_cust_az12
----------------------
*/

-- Check the integrity
-- Expectation: No result

SELECT *
FROM silver.erp_cust_az12
WHERE cid NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

SELECT *
FROM silver.erp_cust_az12
WHERE CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

-- Identify Out-of-Range dates
-- Expectation: No result

SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE()

-- Data Standardization & Consistency

SELECT DISTINCT gen
FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12

/*
----------------------
silver.erp_loc_a101
----------------------
*/

-- Check the integrity
-- Expectation: No result

SELECT 
cid,
cntry
FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)

-- Data Standardization & Cinsistency

SELECT DISTINCT cntry 
FROM silver.erp_loc_a101
ORDER BY cntry

SELECT * FROM silver.erp_loc_a101

/*
----------------------
silver.erp_px_cat_g1v2
----------------------
*/

SELECT * FROM silver.erp_px_cat_g1v2
