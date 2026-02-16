
-- TASK 3: SQL FOR DATA ANALYSIS
-- Dataset: Ecommerce Database



-- 1. CREATE TABLES


DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


--  INSERT SAMPLE DATA

INSERT INTO customers VALUES
(1,'Rahul Sharma','rahul@gmail.com','Mumbai','2023-01-10'),
(2,'Priya Verma','priya@gmail.com','Delhi','2023-02-15'),
(3,'Amit Patel','amit@gmail.com','Bangalore','2023-03-12'),
(4,'Sneha Iyer','sneha@gmail.com','Chennai','2023-04-20'),
(5,'Karan Mehta','karan@gmail.com','Mumbai','2023-05-05');

INSERT INTO products VALUES
(101,'Laptop','Electronics',60000),
(102,'Phone','Electronics',30000),
(103,'Shoes','Fashion',4000),
(104,'Watch','Fashion',7000),
(105,'Headphones','Accessories',2000);

INSERT INTO orders VALUES
(1001,1,'2024-01-05',64000),
(1002,2,'2024-01-10',30000),
(1003,1,'2024-02-01',7000),
(1004,3,'2024-02-10',4000),
(1005,5,'2024-03-15',62000);

INSERT INTO order_items VALUES
(1,1001,101,1,60000),
(2,1001,105,2,4000),
(3,1002,102,1,30000),
(4,1003,104,1,7000),
(5,1004,103,1,4000),
(6,1005,101,1,60000),
(7,1005,105,1,2000);


--  BASIC QUERIES


-- Total Sales
SELECT SUM(total_amount) AS total_sales FROM orders;

-- Orders from Mumbai Customers
SELECT c.name, o.order_id, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.city = 'Mumbai';

-- Top 3 Highest Orders
SELECT *
FROM orders
ORDER BY total_amount DESC
LIMIT 3;

-- Revenue by Category
SELECT p.category, SUM(oi.subtotal) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


--  JOINS


-- INNER JOIN
SELECT c.name, o.order_id
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- LEFT JOIN
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN
SELECT c.name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


--  SUBQUERY


-- Customers who spent more than average total order amount
SELECT name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) >
        (SELECT AVG(total_amount) FROM orders)
);


--  AGGREGATE FUNCTION


-- Average Revenue Per User (ARPU)
SELECT 
    SUM(total_amount) / COUNT(DISTINCT customer_id) AS ARPU
FROM orders;


-- CREATE VIEW --

DROP VIEW IF EXISTS customer_revenue;

CREATE VIEW customer_revenue AS
SELECT c.customer_id, c.name,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- View Output
SELECT * FROM customer_revenue
ORDER BY total_spent DESC;


--  INDEXES (OPTIMIZATION)


CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orderitems_product ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category);
