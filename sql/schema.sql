-- public.dim_commission_payout definition

-- Drop table

-- DROP TABLE public.dim_commission_payout;

CREATE TABLE public.dim_commission_payout (
	order_id varchar(50) NOT NULL,
	actual_commission_base numeric NULL,
	standard_commission numeric NULL,
	store_ads_commission numeric NULL,
	bonus numeric NULL,
	affiliate_bonus numeric NULL,
	total_earnings numeric NULL,
	payout_date timestamp NULL,
	CONSTRAINT dim_commission_payout_order_id_not_null NOT NULL order_id,
	CONSTRAINT dim_commission_payout_pkey PRIMARY KEY (order_id)
);


-- public.dim_content definition

-- Drop table

-- DROP TABLE public.dim_content;

CREATE TABLE public.dim_content (
	content_id varchar(100) NOT NULL,
	content_type varchar(50) NULL,
	order_type varchar(100) NULL,
	affiliate_partner varchar(100) NULL,
	agency varchar(100) NULL,
	CONSTRAINT dim_content_content_id_not_null NOT NULL content_id,
	CONSTRAINT dim_content_pkey PRIMARY KEY (content_id)
);


-- public.dim_products definition

-- Drop table

-- DROP TABLE public.dim_products;

CREATE TABLE public.dim_products (
	sku_id varchar(100) NOT NULL,
	product_id varchar(100) NULL,
	product_name text NULL,
	price numeric NULL,
	store_name varchar(100) NULL,
	store_code varchar(50) NULL,
	CONSTRAINT dim_products_pkey PRIMARY KEY (sku_id),
	CONSTRAINT dim_products_sku_id_not_null NOT NULL sku_id
);


-- public.fact_orders definition

-- Drop table

-- DROP TABLE public.fact_orders;

CREATE TABLE public.fact_orders (
	order_id varchar(50) NULL,
	sku_id varchar(100) NULL,
	content_id varchar(100) NULL,
	order_date timestamp NULL,
	quantity_sold int4 NULL,
	quantity_refunded int4 NULL,
	currency varchar(10) NULL,
	payment_status varchar(50) NULL,
	gmv numeric NULL,
	CONSTRAINT fact_orders_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.dim_content(content_id),
	CONSTRAINT fact_orders_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.dim_commission_payout(order_id),
	CONSTRAINT fact_orders_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.dim_products(sku_id)
);