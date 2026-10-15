# TikTok Affiliate E-Commerce Data Pipeline & Analytics

## Business Overview
This project delivers an end-to-end relational data pipeline based on a optimized **Star Schema** architecture and performs advanced business analytics for a TikTok Affiliate e-commerce ecosystem (March 1–31, 2026). The analysis evaluates Gross Merchandise Value (GMV) revenue velocity, content channel efficiency (*LIVE Streams*, *Short Videos*, *Link Sharing*, and *Showcase*), anchor product SKU performance, and affiliate commission payout structures.

---

## Key Performance Indicators (March 1–31, 2026)
- **Total GMV:** IDR 2,075,084,455 (~IDR 2.08 Billion)
- **Total Completed Orders:** 6,308 distinct transactions
- **Average Order Value (AOV):** IDR 328,961
- **Total Footwear Units Sold:** 6,957 units

---

## Data Architecture & Relational Schema (ERD)
Unstructured raw e-commerce transaction logs were cleaned, deduplicated, and normalized into a **3-Table Star Schema** in PostgreSQL. This architecture eliminates data redundancy and optimizes SQL analytical join performance.

![Entity Relationship Diagram](assets/erd_diagram.png)

### **Relational Table Architecture:**
- **`fact_orders`**: Central fact table storing transactional records, completed order IDs, sales volume, GMV, and commission fees.
- **`dim_products`**: Dimension table containing product catalog details, SKU IDs, product names, and pricing structures.
- **`dim_content`**: Dimension table classifying content promotional channels (`LIVE`, `Video`, `Berbagi tautan`, and `Showcase`).

---

## Data Pipeline Integrity & Validation Test
To verify **100% data integrity** and ensure zero record loss or double-counting after table normalization, a validation re-join query was executed across all relational tables:

```sql
SELECT 
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.gmv) AS total_gmv,
    SUM(f.quantity_sold) AS total_units_sold,
    AVG(f.gmv) AS aov
FROM fact_orders f
JOIN dim_products p ON f.sku_id = p.sku_id
JOIN dim_content c ON f.content_id = c.content_id;
