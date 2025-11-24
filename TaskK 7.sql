show databases;
use sales_data
CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product VARCHAR(100),
    quantity INT,
    price DECIMAL(10,2)
);

INSERT INTO sales (product, quantity, price) VALUES
('USB-C Cable', 10, 9.99),
('USB-C Cable', 5, 9.99),
('Wireless Mouse', 7, 25.50),
('Mechanical Keyboard', 3, 79.99),
('Learning SQL Book', 4, 29.99),
('Coffee Maker', 2, 99.00);

SELECT product,
       SUM(quantity) AS total_qty,
       SUM(quantity * price) AS revenue
FROM sales
GROUP BY product;

