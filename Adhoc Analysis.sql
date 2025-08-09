USE gdb023;

SELECT * FROM dim_customer;
SELECT * FROM dim_product;
SELECT * FROM fact_gross_price;
SELECT * FROM fact_manufacturing_cost;
SELECT * FROM fact_pre_invoice_deductions;
SELECT * FROM fact_sales_monthly;

-- Request One --
SELECT market FROM dim_customer WHERE region = 'APAC' AND customer = 'Atliq Exclusive';

SELECT DISTINCT(dp.product_code), dp.product, fgp.fiscal_year FROM dim_product AS dp
JOIN fact_gross_price AS fgp ON dp.product_code = fgp.product_code
WHERE fiscal_year BETWEEN 2020 AND 2021;

CREATE TABLE product_year AS SELECT DISTINCT(dp.product_code), dp.product, fgp.fiscal_year FROM dim_product AS dp
JOIN fact_gross_price AS fgp ON dp.product_code = fgp.product_code
WHERE fiscal_year BETWEEN 2020 AND 2021;

SELECT COUNT(DISTINCT product_code) AS unique_products_2020, COUNT(DISTINCT product_code) AS
unique_products_2021
FROM product_year 
WHERE fiscal_year IN (2021, 2022);


-- Request Two --
SELECT 
    COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END) AS unique_products_2020,
    COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) AS unique_products_2021,
    ROUND(
        (COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) - 
         COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END)) * 100.0 / 
        COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END), 
        2
    ) AS percentage_difference
FROM product_year 
WHERE fiscal_year IN (2020, 2021);

CREATE TABLE 2020_products AS SELECT DISTINCT(dp.product_code), dp.division, dp.segment,
dp.category, dp.product, dp.variant, fgp.fiscal_year,  fgp.gross_price
FROM dim_product AS dp
JOIN fact_gross_price AS fgp ON dp.product_code = fgp.product_code
WHERE fiscal_year = 2020;


CREATE TABLE 2021_products AS SELECT DISTINCT(dp.product_code), dp.division, dp.segment,
dp.category, dp.product, dp.variant, fgp.fiscal_year,  fgp.gross_price
FROM dim_product AS dp
JOIN fact_gross_price AS fgp ON dp.product_code = fgp.product_code
WHERE fiscal_year = 2021;


-- Request Three --
SELECT segment, COUNT(product_code) AS product_count FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;


-- Request Four --
SELECT 
    dim_product.segment,
    COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN dim_product.product_code END)
    AS product_count_2020,
    COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN dim_product.product_code END) 
    AS product_count_2021,
    COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN dim_product.product_code END) - 
    COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN dim_product.product_code END) 
    AS difference,
    ROUND(
        (COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN dim_product.product_code END) - 
         COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN dim_product.product_code END)) * 100.0 / 
        NULLIF(COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN dim_product.product_code END), 0), 
        2
    ) AS percentage_change
FROM dim_product
JOIN fact_gross_price
ON dim_product.product_code = fact_gross_price.product_code
WHERE fiscal_year IN (2021, 2020)
GROUP BY segment
ORDER BY difference DESC;


-- Request Five --
SELECT dp.product_code, dp.product, fmc.manufacturing_cost FROM 
dim_product AS dp JOIN fact_manufacturing_cost AS fmc
ON dp.product_code = fmc.product_code
ORDER BY manufacturing_cost DESC;


-- Request Six --
SELECT dc.customer_code, dc.customer, AVG(fpid.pre_invoice_discount_pct)
AS average_discount_percentage
FROM dim_customer AS dc
JOIN fact_pre_invoice_deductions AS fpid ON dc.customer_code = fpid.customer_code 
WHERE fpid.fiscal_year = 2021 AND dc.market = 'India'
GROUP BY dc.customer_code, dc.customer 
ORDER BY average_discount_percentage
DESC
LIMIT 5;


-- Request Seven -- -- For 2020 Fiscal Year --
SELECT mn.month_name, mn.quarter, fsm.fact_date, fsm.fiscal_year, SUM(sold_quantity) AS gross_sales_amount 
FROM dim_customer AS dc
JOIN fact_sales_monthly AS fsm
ON dc.customer_code = fsm.customer_code
JOIN months AS mn ON fsm.fact_date = mn.fact_date
WHERE dc.customer = 'Atliq Exclusive' AND fsm.fiscal_year = 2020
GROUP BY fact_date, fiscal_year
ORDER BY month_number;

-- Request Seven -- -- For 2021 Fiscal Year --
SELECT mn.month_name, mn.quarter, fsm.fact_date, fsm.fiscal_year, SUM(sold_quantity) AS gross_sales_amount 
FROM dim_customer AS dc
JOIN fact_sales_monthly AS fsm
ON dc.customer_code = fsm.customer_code
JOIN months AS mn ON fsm.fact_date = mn.fact_date
WHERE dc.customer = 'Atliq Exclusive' AND fsm.fiscal_year = 2021
GROUP BY fact_date, fiscal_year
ORDER BY month_number;


CREATE TABLE months (
    fact_date DATE PRIMARY KEY,
    month_number INT,
    month_name VARCHAR(20),
    month_short VARCHAR(3),
    fiscal_year INT,
    calendar_year INT,
    quarter VARCHAR(2),
    fiscal_quarter VARCHAR(2)
);

INSERT INTO months (fact_date, month_number, month_name, month_short, fiscal_year, calendar_year, quarter, fiscal_quarter) VALUES
('2019-09-01', 9, 'September', 'Sep', 2020, 2019, 'Q3', 'Q1'),
('2019-10-01', 10, 'October', 'Oct', 2020, 2019, 'Q4', 'Q2'),
('2019-11-01', 11, 'November', 'Nov', 2020, 2019, 'Q4', 'Q2'),
('2019-12-01', 12, 'December', 'Dec', 2020, 2019, 'Q4', 'Q2'),
('2020-01-01', 1, 'January', 'Jan', 2020, 2020, 'Q1', 'Q3'),
('2020-02-01', 2, 'February', 'Feb', 2020, 2020, 'Q1', 'Q3'),
('2020-03-01', 3, 'March', 'Mar', 2020, 2020, 'Q1', 'Q3'),
('2020-04-01', 4, 'April', 'Apr', 2021, 2020, 'Q2', 'Q4'),
('2020-05-01', 5, 'May', 'May', 2021, 2020, 'Q2', 'Q4'),
('2020-06-01', 6, 'June', 'Jun', 2021, 2020, 'Q2', 'Q4'),
('2020-07-01', 7, 'July', 'Jul', 2021, 2020, 'Q3', 'Q1'),
('2020-08-01', 8, 'August', 'Aug', 2021, 2020, 'Q3', 'Q1'),
('2020-09-01', 9, 'September', 'Sep', 2021, 2020, 'Q3', 'Q1'),
('2020-10-01', 10, 'October', 'Oct', 2021, 2020, 'Q4', 'Q2'),
('2020-11-01', 11, 'November', 'Nov', 2021, 2020, 'Q4', 'Q2'),
('2020-12-01', 12, 'December', 'Dec', 2021, 2020, 'Q4', 'Q2'),
('2021-01-01', 1, 'January', 'Jan', 2021, 2021, 'Q1', 'Q3'),
('2021-02-01', 2, 'February', 'Feb', 2021, 2021, 'Q1', 'Q3'),
('2021-03-01', 3, 'March', 'Mar', 2021, 2021, 'Q1', 'Q3'),
('2021-04-01', 4, 'April', 'Apr', 2022, 2021, 'Q2', 'Q4'),
('2021-05-01', 5, 'May', 'May', 2022, 2021, 'Q2', 'Q4'),
('2021-06-01', 6, 'June', 'Jun', 2022, 2021, 'Q2', 'Q4'),
('2021-07-01', 7, 'July', 'Jul', 2022, 2021, 'Q3', 'Q1'),
('2021-08-01', 8, 'August', 'Aug', 2022, 2021, 'Q3', 'Q1');


-- Request Eight --
SELECT mn.quarter, SUM(fsm.sold_quantity) 
AS total_sold_quantity
FROM fact_sales_monthly AS fsm JOIN months AS mn ON
fsm.fact_date = mn.fact_date
WHERE fsm.fiscal_year = 2020
GROUP BY mn.quarter
ORDER BY total_sold_quantity DESC;

-- Request Nine --
SELECT 
    dc.platform, SUM(fsm.sold_quantity) AS gross_sales_mln,
    ROUND(
        SUM(fsm.sold_quantity) * 100.0 / 
        (SELECT SUM(sold_quantity) FROM fact_sales_monthly), 
        2
    ) AS percentage
FROM dim_customer AS dc 
JOIN fact_sales_monthly AS fsm ON dc.customer_code = fsm.customer_code
GROUP BY dc.platform
ORDER BY gross_sales_mln DESC;

-- Request Ten --
SELECT dp.division, dp.product_code, dp.product, 
    SUM(fsm.sold_quantity) AS total_sold_quantity,
    RANK() OVER (ORDER BY SUM(fsm.sold_quantity) DESC) AS rank_order
FROM dim_product AS dp 
JOIN fact_sales_monthly AS fsm
ON dp.product_code = fsm.product_code
GROUP BY dp.division, dp.product_code, dp.product
ORDER BY rank_order;
