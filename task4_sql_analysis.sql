use commerce;

-- Create Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    country VARCHAR(30)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert Customers
INSERT INTO customers VALUES
(1, 'Priya Sharma', 'India'),
(2, 'John Doe', 'USA'),
(3, 'Ananya Rao', 'India'),
(4, 'David Lee', 'UK');

-- Insert Orders
INSERT INTO orders VALUES
(101, 1, '2025-07-01', 500, 'Completed'),
(102, 2, '2025-07-02', 1200, 'Pending'),
(103, 1, '2025-07-05', 150, 'Completed'),
(104, 3, '2025-07-10', 800, 'Completed'),
(105, 4, '2025-07-12', 300, 'Cancelled');

-- Insert Order Items
INSERT INTO order_items VALUES
(1, 101, 'Laptop Bag', 1, 500),
(2, 102, 'Smartphone', 2, 600),
(3, 103, 'Mouse', 3, 50),
(4, 104, 'Keyboard', 2, 400),
(5, 105, 'Charger', 1, 300);

-- Total revenue per country
SELECT c.country, SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country;

-- Total revenue per country
SELECT c.country, SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country;

-- Countries with total revenue greater than 500
SELECT c.country, SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
HAVING SUM(o.total_amount) > 500;


-- Show all order details with customer name
SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Show all customers and their orders (even if no orders placed)
SELECT c.customer_name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Show all orders and customers (customers will show even if not matched - if DB supports RIGHT JOIN)
SELECT c.customer_name, o.order_id, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- Find customers who have placed orders worth more than the average total amount
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (SELECT AVG(total_amount) FROM orders)
);


-- Check the view
SELECT * FROM completed_orders;

-- Calculate average revenue per customer
SELECT customer_id, AVG(total_amount) AS avg_revenue
FROM orders
GROUP BY customer_id;

CREATE VIEW completed_orders AS
SELECT o.order_id, c.customer_name, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Completed';

