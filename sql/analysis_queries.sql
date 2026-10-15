SELECT 
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order,
    COUNT(DISTINCT DATE(order_date)) AS active_days
FROM fact_orders;


 


SELECT 
    DATE(order_date) AS order_day,
    SUM(gmv) AS daily_gmv,
    ROUND(AVG(SUM(gmv)) OVER (
        ORDER BY DATE(order_date) 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS gmv_7day_moving_avg
FROM fact_orders
GROUP BY DATE(order_date)
ORDER BY order_day;


SELECT 
    content_type,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(gmv) AS total_gmv,
    ROUND((SUM(gmv) / (SELECT SUM(gmv) FROM fact_orders)) * 100, 2) AS gmv_share_pct
FROM fact_orders
GROUP BY content_type
ORDER BY total_gmv DESC;


SELECT 
    p.product_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity_sold) AS units_sold,
    SUM(f.gmv) AS total_gmv,
    ROUND(SUM(f.gmv) / COUNT(DISTINCT f.order_id), 2) AS avg_order_value
FROM fact_orders f
JOIN dim_products p ON f.sku_id = p.sku_id
GROUP BY p.product_name
ORDER BY total_gmv DESC
LIMIT 5;

SELECT 
    content_type,
    SUM(gmv) AS total_gmv,
    SUM(commission_amount) AS total_commission_payout,
    ROUND((SUM(commission_amount) / SUM(gmv)) * 100, 2) AS commission_ratio_pct
FROM fact_orders
GROUP BY content_type
ORDER BY total_gmv DESC;