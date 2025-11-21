-- SQL script: sales_db setup and analysis (ready for MySQL Workbench)
CREATE DATABASE IF NOT EXISTS sales_db;
USE sales_db;

DROP TABLE IF EXISTS online_sales;
CREATE TABLE online_sales (
  order_id BIGINT PRIMARY KEY,
  order_date DATETIME NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  product_id VARCHAR(50),
  customer_id VARCHAR(50)
);

-- sample data inserts
INSERT INTO online_sales (order_id, order_date, amount, product_id, customer_id) VALUES
(1001, '2024-01-05 10:12:00',  49.99, 'P001', 'C001'),
(1002, '2024-01-15 14:00:00', 129.50, 'P002', 'C002'),
(1003, '2024-02-03 09:30:00',  20.00, 'P001', 'C003'),
(1004, '2024-02-20 11:00:00',  75.00, 'P003', 'C001'),
(1005, '2024-03-10 16:45:00', 200.00, 'P004', 'C004'),
(1006, '2024-03-12 12:10:00',  15.00, 'P001', 'C005'),
(1007, '2024-03-12 12:11:00',  15.00, 'P001', 'C006'),
(1008, '2024-04-01 08:00:00',  99.99, 'P002', 'C007'),
(1009, '2024-11-15 13:00:00', 250.00, 'P005', 'C008'),
(1010, '2025-01-08 09:00:00', 300.00, 'P006', 'C009');

-- indexes (optional, uncomment to create)
-- CREATE INDEX idx_order_date ON online_sales(order_date);
-- CREATE INDEX idx_product_id ON online_sales(product_id);

-- Queries used in report:

-- 1) All rows (ordered)
SELECT * FROM online_sales ORDER BY order_id DESC;

-- 2) Year-month formatted (sample)
SELECT DATE_FORMAT(order_date, '%Y-%m') FROM online_sales LIMIT 5;

-- 3) Monthly aggregation (year, month, revenue, order volume)
SELECT
  YEAR(order_date) AS yr,
  MONTH(order_date) AS mon,
  SUM(amount) AS total_revenue,
  COUNT(order_id) AS order_volume
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- 4) Last 12 months relative to today
SELECT
  YEAR(order_date) AS yr,
  MONTH(order_date) AS mon,
  SUM(amount) AS total_revenue,
  COUNT(order_id) AS order_volume
FROM online_sales
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- 5) Monthly revenue by product
SELECT
  YEAR(order_date) AS yr,
  MONTH(order_date) AS mon,
  product_id,
  SUM(amount) AS revenue,
  COUNT(order_id) AS order_volume
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date), product_id
ORDER BY YEAR(order_date), MONTH(order_date), product_id;

-- 6) Average order value per month
SELECT
  YEAR(order_date) AS yr,
  MONTH(order_date) AS mon,
  SUM(amount) / COUNT(DISTINCT order_id) AS avg_order_value,
  SUM(amount) AS total_revenue,
  COUNT(DISTINCT order_id) AS order_volume
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);
