
-- check data inconsistencey and attribute conflict detection


--Detect customer Conflicts
--Run this diagnostic query:
SELECT 
    customer_id,
    COUNT(DISTINCT customer_city) AS city_count,
    COUNT(DISTINCT customer_state) AS state_count,
    COUNT(DISTINCT customer_zip_code_prefix) AS zip_count,
    COUNT(DISTINCT customer_unique_id) AS unique_id_count
FROM raw_table
GROUP BY customer_id
HAVING 
    COUNT(DISTINCT customer_city) > 1
    OR COUNT(DISTINCT customer_state) > 1
    OR COUNT(DISTINCT customer_zip_code_prefix) > 1
    OR COUNT(DISTINCT customer_unique_id) > 1;

SELECT 
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS id_count
FROM raw_table
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 2;

--Detect product Conflicts
--Run this diagnostic query:
SELECT 
    product_id,
    COUNT(DISTINCT product_category_name) AS category_count,
    COUNT(DISTINCT product_weight_g) AS weight_count,
    COUNT(DISTINCT product_length_cm) AS length_count,
    COUNT(DISTINCT product_height_cm) AS height_count,
    COUNT(DISTINCT product_width_cm) AS width_count
FROM raw_table
GROUP BY product_id
HAVING 
    COUNT(DISTINCT product_category_name) > 1
    OR COUNT(DISTINCT product_weight_g) > 1
    OR COUNT(DISTINCT product_length_cm) > 1
    OR COUNT(DISTINCT product_height_cm) > 1
    OR COUNT(DISTINCT product_width_cm) > 1;

--Detect seller Conflicts
--Run this diagnostic query:
SELECT 
    seller_id,
    COUNT(DISTINCT seller_city) AS city_count,
    COUNT(DISTINCT seller_state) AS state_count,
    COUNT(DISTINCT seller_zip_code_prefix) AS zip_count
FROM raw_table
GROUP BY seller_id
HAVING 
    COUNT(DISTINCT seller_city) > 1
    OR COUNT(DISTINCT seller_state) > 1
    OR COUNT(DISTINCT seller_zip_code_prefix) > 1;


--Detect Payment Conflicts
--Run this diagnostic query:
SELECT 
    order_id,
    payment_sequential,
    COUNT(DISTINCT payment_type) AS type_count,
    COUNT(DISTINCT payment_installments) AS installment_count,
    COUNT(DISTINCT payment_value) AS value_count
FROM raw_table
GROUP BY order_id, payment_sequential
HAVING 
    COUNT(DISTINCT payment_type) > 1
    OR COUNT(DISTINCT payment_installments) > 1
    OR COUNT(DISTINCT payment_value) > 1;


SELECT 
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM raw_table
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;
