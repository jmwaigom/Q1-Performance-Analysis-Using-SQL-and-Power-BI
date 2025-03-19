/*
MANAGERS NEED TO SEE:
- Top-performing stores by revenue --> Stores table
- Best-selling products by sales volume and revenue --> Product and Sales tables
- Overall Q1 revenue trends
*/

SELECT * FROM customers; -- We can get region information from state and country columns
SELECT * FROM stores;
SELECT * FROM products; -- We can get product information
SELECT * FROM sales; -- We can get revenue and volume information
SELECT * FROM exchange_rates; -- We can exchange rate information for different days

/*
The first approach is to explore each table and check for the data completeness or any inconsistencies. This step
also involves a brief exploration of the available data
*/

-- EXPLORING stores TABLE:
SELECT * FROM stores;
-- Result set shows a complete dataset: No missing values or inconsistent data format

SELECT COUNT(*) store_count
FROM stores; -- There are 67 stores

SELECT DISTINCT("Country") store_country
FROM stores
ORDER BY 1; 
/* The 67 stores are spread across 8 countries (Australia, Canada, France, Germany, Italy, Netherlands, UK and US).
There is also one online store.
*/

SELECT
	"Country",
	COUNT("StoreKey") store_count
FROM stores
GROUP BY "Country"
ORDER BY 2 DESC; -- US has the most stores (27 total stores)

-- EXPLORING products TABLE:
SELECT * FROM products;

--Checking for duplicates
SELECT
	"ProductName",
	"Brand",
	"Color",
	"UnitCostUSD",
	"UnitPriceUSD",
	"SubcategoryKey",
	"Subcategory",
	"CategoryKey",
	"Category"
FROM products
GROUP BY 
	"ProductName",
	"Brand",
	"Color",
	"UnitCostUSD",
	"UnitPriceUSD",
	"SubcategoryKey",
	"Subcategory",
	"CategoryKey",
	"Category"
HAVING COUNT(*) > 1; -- There are no duplicate records in this table

-- Checking for null values in any column
SELECT *
FROM products
WHERE 
	"ProductKey" IS NULL OR
	"ProductName" IS NULL OR
	"Brand" IS NULL OR
	"Color" IS NULL OR
	"UnitCostUSD" IS NULL OR
	"UnitPriceUSD" IS NULL OR
	"SubcategoryKey" IS NULL OR
	"Subcategory" IS NULL OR
	"CategoryKey" IS NULL OR
	"Category" IS NULL; -- There are no null values in any column of the products table

-- Exploring product varieties by brand
SELECT
	"Brand",
	COUNT(*) product_varieties
FROM products
GROUP BY "Brand"
ORDER BY 2 DESC; -- There are 9 brands: Contoso brand has the most product varieties (710), while Northwind Traders has the least(47)

--EXPLORING customers TABLE:
SELECT * FROM customers;

-- Checking for duplicate records
SELECT
	"CustomerKey",
	"Name"
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY "CustomerKey","Name") duplicate_number
	FROM customers
) duplicates
WHERE duplicate_number > 1; -- There are no duplicated customer records in this table

-- EXPLORING sales TABLE:
SELECT * FROM sales;

/*
From the result set, it can be observed that there are duplicate order numbers. Since each row represents an order,
we will examine to see if there are duplicate orders in the set
*/

SELECT
	*
FROM sales
GROUP BY
	"OrderNumber",
	"LineItem",
	"OrderDate",
	"DeliveryDate",
	"CustomerKey",
	"StoreKey",
	"ProductKey",
	"Quantity",
	"CurrencyCode"
HAVING COUNT(*) > 1; 

/*
The query above returns no duplicates, confirming that each order is unique. 
However, an order number may appear multiple times because a single customer can purchase 
multiple products within the same order. Each product in the sales table is assigned a 
distinct line item, ensuring uniqueness at the product level. For instance, Customer 1269051 
purchased two products (1048 and 2007), each linked to line items 1 and 2, respectively. 
This structure ensures that while orders can span multiple rows, each product within an order 
remains uniquely identifiable.
*/

-- Checking for NULL values in each column:
SELECT COUNT(*) FROM sales WHERE "OrderNumber" IS NULL; -- No null values in OrderNumber column
SELECT COUNT(*) FROM sales WHERE "LineItem" IS NULL; -- No null values in LineItem column
SELECT COUNT(*) FROM sales WHERE "OrderDate" IS NULL; -- No null values in the OrderDate column
SELECT COUNT(*) FROM sales WHERE "DeliveryDate" IS NULL; -- There are 49719 rows with null values in the DeliveryDate column
SELECT COUNT(*) FROM sales WHERE "CustomerKey" IS NULL; -- No null values in the CustomerKey column
SELECT COUNT(*) FROM sales WHERE "StoreKey" IS NULL; -- No null values in StoreKey column
SELECT COUNT(*) FROM sales WHERE "ProductKey" IS NULL; -- No null values in ProductKey column
SELECT COUNT(*) FROM sales WHERE "Quantity" IS NULL; -- No null values in Quantity column
SELECT COUNT(*) FROM sales WHERE "CurrencyCode" IS NULL; -- No null values in CurrencyCode column

-- Exploring null values in the DeliveryDate column
SELECT
	CONCAT(ROUND(null_values),'%') null_percentage
FROM (
	SELECT
		100.0 * COUNT(*) FILTER(WHERE "DeliveryDate" IS NULL) / COUNT(*) null_values
	FROM sales
) null_proportion; -- ~ 79% null values in DeliveryDate column

/* 
ASSUMPTION FOR MISSING DELIVERY DATES: Missing null values are associated with in-store pickup rather than delivery.

HANDLING: 
Step 1: Create a new column indicating whether an order is 'in-store pickup' or 'delivery'
Step 2: Replace null values with corresponding OrderDate such that: DeliveryDate = OrderDate
Step 3: Create a view that stores these changes in a new table
*/

CREATE VIEW sales_modified AS (
	WITH modified_table AS (
		SELECT 
			*,
			CASE 
				WHEN "DeliveryDate" IS NULL THEN 'In-store pickup' ELSE 'Delivery'
			END "OrderType"
		FROM sales
	)
	SELECT
		"OrderNumber",
		"LineItem",
		"OrderDate",
		COALESCE("DeliveryDate","OrderDate") "DeliveryDate",
		"CustomerKey",
		"StoreKey",
		"ProductKey",
		"Quantity",
		"CurrencyCode",
		"OrderType"
	FROM modified_table
); -- This view will be used instead of the original sales table.

-- EXPLORING exchange_rates TABLE:
SELECT * FROM exchange_rates;

-- Checking for duplicates
SELECT
	*
FROM exchange_rates
GROUP BY 
	"Date",
	"Currency",
	"Exchange"
HAVING COUNT(*) > 1 -- Query returned no records, hence no duplicates in the exchange_rates table

-- Checking for null values
SELECT COUNT(*) FROM exchange_rates WHERE "Date" IS NULL; -- No null values in the Date column
SELECT COUNT(*) FROM exchange_rates WHERE "Currency" IS NULL; -- No null values in the Currency column
SELECT COUNT(*) FROM exchange_rates WHERE "Exchange" IS NULL; -- No null values in the Exchange column

-- ALL TABLES HAVE BEEN CHECKED FOR ACCURACY AND COMPLETENESS

/*
Retrieving what managers want to see: 
MANAGERS NEED TO SEE:
- Top-performing stores by revenue --> Stores table
- Best-selling products by sales volume and revenue --> Product and Sales tables
- Overall Q1 revenue trends
*/

-- CREATING A VIEW WITH ALL THE NECESSARY COLUMNS FOR ANALYSIS AND VISUALIZATION
CREATE VIEW  sales_summary_adhoc AS (
	WITH quarter1_sales AS (
		SELECT 
			"OrderNumber",
			"LineItem",
			"OrderDate",
			"CustomerKey",
			"StoreKey",
			"ProductKey",
			"Quantity",
			"CurrencyCode"
		FROM sales_modified
		WHERE EXTRACT(YEAR FROM "OrderDate") = 2021 AND
			EXTRACT(QUARTER FROM "OrderDate") = 1
	)
	SELECT 
		q1."OrderNumber",
		q1."LineItem",
		q1."OrderDate",
		st."StoreKey",
		st."Country",
		pr."ProductName",
		pr."Brand" "ProductBrand",
		pr."Category",
		q1."Quantity",
		pr."UnitPriceUSD",
		er."Currency",
		er."Exchange" "ExchangeRate"
	FROM quarter1_sales q1
	INNER JOIN stores st
	USING("StoreKey")
	INNER JOIN products pr
	USING("ProductKey")
	INNER JOIN exchange_rates er
	ON q1."OrderDate" = er."Date" AND q1."CurrencyCode" = er."Currency"
);
	
-- TOTAL REVENUE AND VOLUME BY STORE
SELECT
	"StoreKey",
	"TotalRevenue",
	CONCAT((ROUND((100.0 * "TotalRevenue" / SUM("TotalRevenue") OVER()),1)),'%') "pct_TotalRevenue",
	"TotalProductsSold",
	CONCAT((ROUND((100.0 * "TotalProductsSold" / SUM("TotalProductsSold") OVER()),1)),'%') "pct_TotalProductsSold"
FROM (
	SELECT 
		"StoreKey",
		SUM("Quantity" * "UnitPriceUSD") "TotalRevenue",
		COUNT(*) "TotalProductsSold"
	FROM sales_summary_adhoc
	GROUP BY "StoreKey"
) storeRevenue
ORDER BY 2 DESC;

-- PUTTING THE QUERY ABOVE IN A VIEW FOR EASE OF REFERENCE
CREATE VIEW store_performance_summary AS (
SELECT
	"StoreKey",
	"TotalRevenue",
	CONCAT((ROUND((100.0 * "TotalRevenue" / SUM("TotalRevenue") OVER()),1)),'%') "pct_TotalRevenue",
	"TotalProductsSold",
	CONCAT((ROUND((100.0 * "TotalProductsSold" / SUM("TotalProductsSold") OVER()),1)),'%') "pct_TotalProductsSold"
FROM (
	SELECT 
		"StoreKey",
		SUM("Quantity" * "UnitPriceUSD") "TotalRevenue",
		COUNT(*) "TotalProductsSold"
	FROM sales_summary_adhoc
	GROUP BY "StoreKey"
) storeRevenue
);

-- TOTAL REVENUE & QAUNTITY SOLD PER PRODUCT:
SELECT
	"ProductName",
	SUM("Quantity") "TotalQuantity",
	SUM("Quantity" * "UnitPriceUSD") "TotalRevenue"
FROM sales_summary_adhoc
GROUP BY "ProductName"
ORDER BY 3 DESC;

-- SALES BY COUNTRY:
SELECT
	"Country",
	"TotalStores",
	CONCAT((ROUND((100.0 * "TotalStores" / SUM("TotalStores") OVER()),1)),'%') "pct_TotalStores",
	"TotalRevenue",
	CONCAT((ROUND((100.0 * "TotalRevenue" / SUM("TotalRevenue") OVER()),1)),'%') "pct_TotalRevenue"
FROM (
	SELECT
		"Country",
		COUNT("StoreKey") "TotalStores",
		SUM("Quantity" * "UnitPriceUSD") "TotalRevenue"
	FROM sales_summary_adhoc
	GROUP BY "Country"
) countrySales
ORDER BY 2 DESC;

-- ANALYZING THE TOP 10 STORE BY REVENUE AND SALES VOLUME
CREATE VIEW top_10_stores AS (
	WITH top_10_stores AS (
		SELECT
			"StoreKey",
			"RevenueRanking"
		FROM (
			SELECT
				"StoreKey",
				DENSE_RANK() OVER(ORDER BY "TotalRevenue" DESC) "RevenueRanking" -- No gaps in ranking.
			FROM store_performance_summary
		) rankedrevenue
		WHERE "RevenueRanking" <= 10
	)
	SELECT
		*
	FROM sales_summary_adhoc s
	INNER JOIN top_10_stores t
	USING("StoreKey")
);

-- For each of the top stores, what is their top-selling product category?
SELECT
	"StoreKey",
	"StoreRank",
	"Category",
	"TotalRevenue"
FROM (
	SELECT
		"StoreKey",
		"Category",
		"RevenueRanking" "StoreRank",
		SUM("Quantity" * "UnitPriceUSD") "TotalRevenue",
		RANK() OVER(PARTITION BY "StoreKey" ORDER BY SUM("Quantity" * "UnitPriceUSD") DESC) "RevenueRanking"
	FROM top_10_stores
	GROUP BY 1,2,3
) rankedRevenue
WHERE "RevenueRanking" = 1
ORDER BY 2; -- For all the top 10 stores, the top revenue-generating product category is Computer

/*
Examining Store 0: 
Which Product subcategories of computers (e.g. Desktops, laptops, etc) drive the most sales? Where does it rank in terms of pricing? 
*/
WITH top_10stores_with_subcategories AS (
	SELECT
		t.*,
		p."Subcategory"
	FROM top_10_stores t
	INNER JOIN products p
	USING("ProductName") -- Joining the top_10_stores table to products table to get Subcategories
),
	store_0_sales_summary AS (
	SELECT
		"Subcategory",
		COUNT(*) "TotalOrders",
		SUM("Quantity" * "UnitPriceUSD") "TotalRevenue"
	FROM top_10stores_with_subcategories
	WHERE "StoreKey" = 0 AND "Category" = 'Computers'
	GROUP BY "Subcategory"
)
SELECT
	"Subcategory",
	"TotalOrders",
	CONCAT((ROUND((100.0 * "TotalOrders" / SUM("TotalOrders") OVER()),1)),'%') "pct_TotalOrders",
	"TotalRevenue",
	CONCAT((ROUND((100.0 * "TotalRevenue" / SUM("TotalRevenue") OVER()),1)),'%') "pct_TotalRevenue"
FROM store_0_sales_summary
ORDER BY "TotalRevenue" DESC; -- Results show that desktop drive the most sales for store 0 followed by laptops

-- CREATING A VIEW OF TOP 1O STORES WITH SUBCATEGORIES
CREATE VIEW top_10stores_with_subcategory AS (
	SELECT
		t.*,
		p."Subcategory"
	FROM top_10_stores t
	INNER JOIN products p
	USING("ProductName")
);

--Identifying the top 3 revenue-driving products/subcategories in each store
SELECT
	"StoreKey",
	"StoreRank",
	"Subcategory",
	"TotalRevenue",
	"RevenueRank"
FROM (
	SELECT
		"StoreKey",
		"Subcategory",
		"RevenueRanking" "StoreRank",
		SUM("Quantity" * "UnitPriceUSD") "TotalRevenue",
		DENSE_RANK() OVER(PARTITION BY "StoreKey" ORDER BY SUM("Quantity" * "UnitPriceUSD") DESC) "RevenueRank"
	FROM top_10stores_with_subcategory
	WHERE "Category" = 'Computers' 
	GROUP BY "StoreKey", "Subcategory","RevenueRanking"
) rankedRevenue
WHERE "RevenueRank" <= 3
ORDER BY "StoreRank","RevenueRank"; -- Desktops and laptops appear to be in top 3 for nearly all the top 10 stores  

