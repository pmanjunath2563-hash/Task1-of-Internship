Create database ecommerce;
use ecommerce;
-- drop table if exists order_items;
-- drop table if exists orders;
-- drop table if exists products;
-- drop table if exists categories;
-- drop table if exists customers;

CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(255),
  country VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  category_id INT,
  price DECIMAL(10,2),
  stock INT,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  status VARCHAR(50),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  item_price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

insert into customers (first_name,last_name,email,country) values
('Ammi','kumari','ami@example.com','Unkal'),
('Bro','Patel','bro@example.com','India'),
('Cod','Gomez','cod@example.com','Manglore'),
('Dhana','Smith','dhana@example.com','Uttara Karnataka');

insert into categories (name) values
('electronics'),('books'),('home');

-- INSERT INTO products (name, category_id, price, stock) VALUES
-- ('USB-C Cable',1,9.99,150),
-- ('Wireless Mouse',1,25.50,80),
-- ('Mechanical Keyboard',1,79.99,40),
-- ('Learning SQL (Book)',2,29.99,60),
-- ('Coffee Maker',3,99.00,20);

DESCRIBE products;
select * from categories;
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Appliances');

INSERT INTO products (name, category_id, price, stock)
VALUES ('USB-C Cable',1,35,150);

INSERT INTO products (name, category_id, price, stock)
VALUES ('Wireless Mouse',1,25.50,80);

desc categories;




INSERT INTO orders (customer_id,order_date,status) VALUES
(1,'2025-01-15','delivered'),
(2,'2025-01-18','delivered'),
(1,'2025-02-05','processing'),
(3,'2025-02-10','cancelled'),
(4,'2025-02-12','delivered');

INSERT INTO order_items (order_id,product_id,quantity,item_price) VALUES
(1,2,1,25.50),
(1,4,2,29.99),
(2,1,3,9.99),
(3,3,1,79.99),
(5,5,1,99.00),
(2,4,1,29.99);

select * from products;
select * from customers;

select product_id, name, price
from products
where price > 30
order by price DESC;

SELECT o.order_id, o.order_date, o.status,
       CONCAT(c.first_name, ' ', c.last_name) AS customer
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

SELECT oi.order_item_id,
       o.order_id,
       CONCAT(c.first_name,' ',c.last_name) AS customer,
       p.name AS product,
       oi.quantity,
       oi.item_price,
       (oi.quantity * oi.item_price) AS total_line
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_item_id;

SELECT p.product_id, p.name,
       SUM(oi.quantity * oi.item_price) AS total_revenue,
       SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_revenue DESC;

SELECT p.name,
       SUM(oi.quantity * oi.item_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
HAVING total_revenue > 10;

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS customer
FROM customers
WHERE customer_id IN (
  SELECT o.customer_id
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.customer_id
  HAVING SUM(oi.quantity * oi.item_price) > 50
);

CREATE OR REPLACE VIEW customer_totals AS
SELECT c.customer_id,
       CONCAT(c.first_name,' ',c.last_name) AS customer,
       SUM(oi.quantity * oi.item_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id;

SELECT * FROM customer_totals ORDER BY total_spent DESC;

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orderitems_product ON order_items(product_id);


