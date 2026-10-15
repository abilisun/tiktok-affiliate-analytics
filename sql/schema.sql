DROP TABLE IF EXISTS fact_orders CASCADE;
DROP TABLE IF EXISTS dim_products CASCADE;
DROP TABLE IF EXISTS dim_content CASCADE;

CREATE TABLE dim_products (
    sku_id INT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(255),
    shop_id VARCHAR(100)
);

CREATE TABLE dim_content (
    content_id INT PRIMARY KEY,
    agency_id VARCHAR(100)
);

CREATE TABLE fact_orders (
    order_id INT,
    order_date TIMESTAMP,
    sku_id INT,
    content_id INT,
    price NUMERIC(12, 2),
    quantity_sold INT,
    gmv NUMERIC(15, 2),
    content_type VARCHAR(100),
    commission_rate NUMERIC(5, 4),
    commission_amount NUMERIC(15, 2),
    payment_status VARCHAR(100),
    payout_date TIMESTAMP
);

SELECT 
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.gmv) AS total_gmv,
    SUM(f.quantity_sold) AS total_units_sold,
    AVG(f.gmv) AS aov
FROM fact_orders f
JOIN dim_products p ON f.sku_id = p.sku_id
JOIN dim_content c ON f.content_id = c.content_id;