WITH product_sales AS (
    SELECT 
        p.product_name,
        SUM(f.gmv) AS total_gmv,
        SUM(f.quantity_sold) AS total_units_sold,
        RANK() OVER (ORDER BY SUM(f.gmv) DESC) AS gmv_rank
    FROM fact_orders f
    JOIN dim_products p ON f.sku_id = p.sku_id
    GROUP BY p.product_name
)
SELECT * 
FROM product_sales
WHERE gmv_rank <= 5;

WITH monthly_gmv AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(gmv) AS current_month_gmv
    FROM fact_orders
    GROUP BY 1
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') AS period,
    current_month_gmv,
    LAG(current_month_gmv) OVER (ORDER BY month) AS previous_month_gmv,
    ROUND(
        ((current_month_gmv - LAG(current_month_gmv) OVER (ORDER BY month)) / 
        NULLIF(LAG(current_month_gmv) OVER (ORDER BY month), 0)) * 100, 2
    ) AS mom_growth_percentage
FROM monthly_gmv
ORDER BY month;

SELECT 
    c.content_type,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.gmv) AS total_gmv,
    SUM(pay.total_earnings) AS total_commission_paid,
    ROUND(AVG(f.gmv), 2) AS avg_order_value
FROM fact_orders f
JOIN dim_content c ON f.content_id = c.content_id
JOIN dim_commission_payout pay ON f.order_id = pay.order_id
GROUP BY c.content_type
ORDER BY total_gmv DESC;

WITH affiliate_earnings AS (
    SELECT 
        c.affiliate_partner,
        SUM(pay.total_earnings) AS total_earnings,
        NTILE(4) OVER (ORDER BY SUM(pay.total_earnings) DESC) AS earnings_quartile
    FROM fact_orders f
    JOIN dim_content c ON f.content_id = c.content_id
    JOIN dim_commission_payout pay ON f.order_id = pay.order_id
    WHERE c.affiliate_partner IS NOT NULL
    GROUP BY c.affiliate_partner
)
SELECT 
    affiliate_partner,
    total_earnings,
    CASE 
        WHEN earnings_quartile = 1 THEN 'Tier 1 (Top Performance)'
        WHEN earnings_quartile = 2 THEN 'Tier 2 (High Performance)'
        WHEN earnings_quartile = 3 THEN 'Tier 3 (Medium Performance)'
        ELSE 'Tier 4 (Low Performance)'
    END AS affiliate_tier
FROM affiliate_earnings
ORDER BY total_earnings DESC;

WITH product_refunds AS (
    SELECT 
        p.sku_id,
        p.product_name,
        SUM(f.quantity_sold) AS total_sold,
        SUM(f.quantity_refunded) AS total_refunded
    FROM fact_orders f
    JOIN dim_products p ON f.sku_id = p.sku_id
    GROUP BY p.sku_id, p.product_name
)
SELECT 
    sku_id,
    product_name,
    total_sold,
    total_refunded,
    ROUND(
        (total_refunded::NUMERIC / NULLIF(total_sold, 0)) * 100, 2
    ) AS refund_rate_percentage
FROM product_refunds
WHERE total_sold > 0
ORDER BY refund_rate_percentage DESC;