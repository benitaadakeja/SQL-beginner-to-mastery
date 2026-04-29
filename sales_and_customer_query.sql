-- Find Total Sales Revenue Per Order
-- Since revenue = Price x Quantity, we'll use the order_id and multiply price and quantity to give us revenue
SELECT order_id, quantity * price_per_unit AS total_revenue
FROM sales_data;

-- Total revenue by category
SELECT category,  sum(quantity * price_per_unit) AS revenue
FROM sales_data
GROUP BY category;

-- Find customers who placed more than one order
SELECT customer_id, COUNT(order_id) AS order_count
FROM sales_data
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- The most expensive product sold
SELECT product, price_per_unit
FROM sales_data
ORDER BY price_per_unit DESC
LIMIT 1;

-- OR
SELECT product, MAX(price_per_unit) AS highest_price
FROM sales_data
GROUP BY product
ORDER BY highest_price DESC
LIMIT 1;

-- Find total revenue for January 8, 2024
SELECT order_date, SUM(quantity * price_per_unit) AS total_revenue
FROM sales_data
WHERE order_date = '2024-01-08'
GROUP BY order_date ;

-- Number of orders per day
SELECT order_date, COUNT(order_id) AS order_count
FROM sales_data
GROUP BY order_date
ORDER BY order_date;

-- Total quantity sold for each product
SELECT product, SUM(quantity) AS total_quantity
FROM sales_data
GROUP BY product;

-- Find distinct product categories
SELECT DISTINCT category
FROM sales_data;

-- Find Orders with revenue greater than 500
SELECT order_id, quantity * price_per_unit AS revenue
FROM sales_data
WHERE quantity * price_per_unit > 500;

-- Cheapest Product sold
SELECT product, price_per_unit
FROM sales_data
ORDER BY price_per_unit ASC
LIMIT 1;

-- Total revenue per customer with names
SELECT customers_data.customer_name, SUM(quantity * price_per_unit) AS revenue
FROM sales_data
JOIN customers_data
ON customers_data.customer_id = sales_data.customer_id
GROUP BY customers_data.customer_name;

-- First Order date for each customer
SELECT customer_id, MIN(order_date)
FROM sales_data
GROUP BY customer_id;

-- Cumulative revenue per day
SELECT order_date, SUM(quantity * price_per_unit) AS daily_revenue, 
	SUM(SUM(quantity * price_per_unit)) OVER (ORDER BY order_date) AS cumulative_revenue
FROM sales_data
GROUP BY order_date
ORDER BY order_date;

-- top selling product in each category
WITH product_totals AS (
	SELECT category, product, SUM(quantity) AS total_quantity
    FROM sales_data
    GROUP BY category, product
) SELECT category, product, total_quantity
  FROM (
  SELECT category, product, total_quantity, RANK() OVER ( PARTITION BY category ORDER BY 
  total_quantity DESC) AS rnk
  FROM product_totals
  ) ranked
  WHERE rnk = 1;
  
-- show orders from new customers(i.e, customers who joined after Jan 1, 2024)
SELECT customers_data.customer_id, customers_data.customer_name, customers_data.join_date,  sales_data.order_id
FROM sales_data
JOIN customers_data
ON customers_data.customer_id = sales_data.customer_id
WHERE join_date > '2024-01-01';

-- Find revenue split between categories
SELECT 
    SUM(CASE
        WHEN category = 'Electronics' THEN quantity * price_per_unit
        ELSE 0
    END) AS electronics_revenue,
    SUM(CASE
        WHEN category = 'Furniture' THEN quantity * price_per_unit
        ELSE 0
    END) AS furniture_revenue
FROM
    sales_data;

-- Customers who never bought electronics
SELECT sales_data.customer_id, customers_data.customer_name, sales_data.category
FROM sales_data
JOIN customers_data
ON customers_data.customer_id= sales_data.customer_id
WHERE sales_data.category != 'Electronics';

