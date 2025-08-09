# Atliq-Hardware-Ad-hoc-SQL-Analysis
# AtliQ Hardware SQL Analytics - Codebasics Challenge


This is my solution to the Codebasics SQL Challenge, where I analyzed AtliQ Hardware's business data to answer 10 specific ad-hoc requests. Instead of just running basic queries, I tried to understand what each stakeholder was asking for and why it mattered to their decision-making.

## The Challenge

Given 10 business questions that different teams at AtliQ Hardwares needed answers to I wrote SQL queries to answer all 10 questons and ensured that my queries not only got the right data but was formatted exactly how they wanted as each question had specific output requirements.

## What I Was Working With

The database had a 6 tables initially

**Dimension Tables:**
- `dim_customer` - Customer details, markets, regions, platforms
- `dim_product` - Product catalog with segments, categories, divisions

**Fact Tables:**
- `fact_sales_monthly` - Monthly sales transactions  
- `fact_gross_price` - Product pricing by fiscal year
- `fact_manufacturing_cost` - Manufacturing costs
- `fact_pre_invoice_deductions` - Customer discount data

## How I Tackled Each Request

### Request 1: "Where does Atliq Exclusive operate in APAC?"
**What they wanted:** Simple market list for a specific customer in APAC region.

**My approach:** Straightforward filtering on customer and region dimensions.

**Why this mattered:** Regional managers need to know their territory scope quickly.

### Request 2: "What's our product growth percentage from 2020 to 2021?"
**What they wanted:** Exact fields - unique_products_2020, unique_products_2021, percentage_chg

**My approach:**
This required conditional aggregations with CASE statements to count unique products by year and calculate the percentage change accurately.

**The result:** Found significant growth that would make any product manager happy.

### Request 3: "Product count by segment, sorted descending"
**What they wanted:** segment, product_count

**My approach:**
Simple aggregation with GROUP BY and ORDER BY to get segment-wise product counts.

**What I discovered:** Notebooks dominate the product catalog - useful for resource planning.

### Request 4: "Which segment grew the most in 2021 vs 2020?"
**What they wanted:** segment, product_count_2020, product_count_2021, difference

**My approach:**
Used conditional aggregations with CASE statements to compare product counts by segment across both years, then calculated the difference.

**Business insight:** This tells product strategy teams where to focus their expansion efforts.

### Request 5: "Highest and lowest manufacturing cost products"
**What they wanted:** product_code, product, manufacturing_cost

**My approach:**
Joined product and manufacturing cost tables, sorted by cost to identify the highest and lowest cost products.

**Why it matters:** Finance teams can spot potential margin issues and cost optimization opportunities.

### Request 6: "Top 5 customers with highest discounts in India for FY2021"
**What they wanted:** customer_code, customer, average_discount_percentage

**My approach:**
Filtered for India market and FY2021, then calculated average discount percentages by customer and selected top 5.

**Business value:** Sales teams can understand their discount strategies and customer relationships better.

### Request 7: "Monthly gross sales for Atliq Exclusive"
**What they wanted:** Month, Year, Gross sales Amount

**The challenge:** I had to create a proper date dimension because the database used fiscal years.

**My solution:**
First, I built a custom months lookup table to handle fiscal year complexities, then joined sales, pricing, and date data to calculate monthly gross sales for Atliq Exclusive.

**Why this was tricky:** Fiscal years don't align with calendar years, so I had to manually map the dates.

### Request 8: "Which Q1 2020 quarter had max sales quantity?"
**What they wanted:** Quarter, total_sold_quantity

**My approach:**
Used the custom months table to aggregate sales quantities by quarter for fiscal year 2020.

**Business insight:** Seasonal patterns help with inventory and marketing planning.

### Request 9: "Best performing channel in FY2021 with percentage contribution"
**What they wanted:** channel, gross_sales_mln, percentage

**My approach:**
Calculated gross sales by channel for FY2021, then used subqueries to determine each channel's percentage contribution to total sales.

**Why it matters:** Channel strategy decisions need data-driven insights.

### Request 10: "Top 3 products per division by sales quantity in FY2021"
**What they wanted:** division, product_code, product, total_sold_quantity, rank_order

**My approach:**
Used window functions with PARTITION BY to rank products within each division, then filtered to get only the top 3 per division.

**Why this was challenging:** Had to use PARTITION BY to rank within each division separately.

## Technical Skills I Used

- **Window Functions:** RANK(), PARTITION BY for competitive analysis
- **Conditional Aggregations:** CASE statements for year-over-year comparisons  
- **Complex Joins:** Multi-table joins across fact and dimension tables
- **Subqueries:** For percentage calculations and data filtering
- **Data Modeling:** Created custom date dimension for fiscal year handling
- **Performance Optimization:** Thought about query efficiency with large datasets

## What Made This Challenging

1. **Fiscal Year Complexity:** I had to build custom date logic since AtliQ uses September-August fiscal years
2. **Exact Output Requirements:** Each query needed specific column names and formats
3. **Business Context:** Had to understand what each stakeholder actually needed the data for
4. **Data Quality:** Had to handle edge cases and ensure accurate calculations
5. **Performance:** Some queries involved multiple large table joins

## Key Insights I Discovered

- **Product Growth:** Significant portfolio expansion between fiscal years
- **Segment Performance:** Clear leaders and growth opportunities identified  
- **Customer Patterns:** High-discount customers revealed important relationships
- **Seasonal Trends:** Quarterly patterns useful for planning
- **Channel Performance:** Data-driven insights for go-to-market strategy


##  What I'd Present to Stakeholders

This isn't just about writing SQL - each query answers a real business question:

- **Product Teams:** Portfolio growth metrics and segment performance
- **Finance:** Manufacturing cost analysis and discount patterns  
- **Sales:** Customer insights and channel performance
- **Operations:** Seasonal trends for inventory planning
- **Executive:** Overall business performance indicators

The technical execution matters, but understanding the business impact is what makes these insights valuable.
