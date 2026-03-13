-- ================================================
-- 1. Schema & Cleanup
-- ================================================
CREATE SCHEMA retail_practice;


-- ================================================
-- 2. Create Tables
-- ================================================

-- Table: Regions (For Joins)
CREATE TABLE retail_practice.regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50)
);

-- Table: Customers (For String Functions & Window Functions)
CREATE TABLE retail_practice.customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    join_date DATE,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES retail_practice.regions(region_id)
);

-- Table: Products (For Case Statements & Subqueries)
CREATE TABLE retail_practice.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    base_price DECIMAL(10, 2)
);

-- Table: Orders (Main Transaction Table for Window Functions)
CREATE TABLE retail_practice.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP,
    status VARCHAR(20), -- 'Shipped', 'Pending', 'Cancelled'
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES retail_practice.customers(customer_id)
);

-- Table: Order_Items (Granular Data for Joins & Aggregates)
CREATE TABLE retail_practice.order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2), -- Price at time of sale
    FOREIGN KEY (order_id) REFERENCES retail_practice.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES retail_practice.products(product_id)
);

-- Table: Legacy_Orders (From an old system, for UNION practice)
CREATE TABLE retail_practice.legacy_orders (
    l_order_id INT PRIMARY KEY,
    l_customer_name VARCHAR(100),
    l_order_date DATE,
    l_total_amount DECIMAL(10, 2)
);


-- ================================================
-- 3. Insert Data
-- ================================================

-- Insert Regions
INSERT INTO retail_practice.regions VALUES
(1, 'North'), (2, 'South'), (3, 'East'), (4, 'West');

-- Insert Customers
INSERT INTO retail_practice.customers (customer_id, first_name, last_name, email, join_date, region_id) VALUES
(101, 'Amit', 'Sharma', 'amit.sharma@email.com', '2023-01-15', 1),
(102, 'Priya', 'Verma', 'priya.v@email.com', '2023-02-10', 2),
(103, 'Rahul', 'Singh', 'rahul.singh99@email.com', '2023-03-05', 1),
(104, 'Sneha', 'Kapoor', 'sneha.k@email.com', '2023-05-20', 3),
(105, 'Vikram', 'Malhotra', 'vikram.m@email.com', '2023-06-01', 4),
(106, 'Anjali', 'Joshi', 'anjali.j@email.com', '2023-07-15', 2),
(107, 'Rohan', 'Mehta', 'rohan.mehta@email.com', '2023-08-10', 3),
(108, 'Ishita', 'Patel', 'ishita.p@email.com', '2023-09-25', 4),
(109, 'Aditya', 'Chopra', 'aditya.c@email.com', '2023-11-01', 1),
(110, 'Kavita', 'Reddy', 'kavita.r@email.com', '2023-12-10', 2),
(111, 'Deepak', 'Gupta', 'deepak.g@email.com', '2024-01-05', 3),
(112, 'Neha', 'Bhatia', 'neha.b@email.com', '2024-01-20', 1),
(113, 'Arjun', 'Nair', 'arjun.nair@email.com', '2024-02-15', 2),
(114, 'Pooja', 'Desai', 'pooja.d@email.com', '2024-03-01', 4),
(115, 'Suresh', 'Raina', 'suresh.r@email.com', '2023-04-12', 1);

-- Insert Products
INSERT INTO retail_practice.products VALUES
(501, 'Laptop Pro X', 'Electronics', 1200.00),
(502, 'Wireless Earbuds', 'Electronics', 150.00),
(503, '4K Monitor', 'Electronics', 400.00),
(504, 'Ergonomic Chair', 'Furniture', 350.00),
(505, 'Standing Desk', 'Furniture', 500.00),
(506, 'Desk Lamp', 'Furniture', 45.00),
(507, 'Running Shoes', 'Apparel', 80.00),
(508, 'Hotee', 'Apparel', 45.00),
(509, 'Backpack', 'Accessories', 60.00),
(510, 'Smart Watch', 'Electronics', 250.00),
(511, 'Bluetooth Speaker', 'Electronics', 90.00),
(512, 'Office Chair', 'Furniture', 200.00),
(513, 'Yoga Mat', 'Accessories', 30.00),
(514, 'Water Bottle', 'Accessories', 25.00),
(515, 'Leather Jacket', 'Apparel', 120.00);

-- Insert Orders (Spanning 2023-2024 for time-series analysis)
INSERT INTO retail_practice.orders VALUES
(1001, 101, '2023-02-01 10:00:00', 'Shipped', 1350.00),
(1002, 102, '2023-02-15 14:30:00', 'Shipped', 80.00),
(1003, 101, '2023-03-10 09:15:00', 'Shipped', 400.00),
(1004, 103, '2023-03-25 16:45:00', 'Cancelled', 1200.00),
(1005, 104, '2023-05-22 11:00:00', 'Shipped', 850.00),
(1006, 105, '2023-06-05 13:00:00', 'Shipped', 60.00),
(1007, 102, '2023-07-18 10:30:00', 'Shipped', 250.00),
(1008, 106, '2023-07-20 15:00:00', 'Pending', 90.00),
(1009, 107, '2023-08-12 12:00:00', 'Shipped', 350.00),
(1010, 101, '2023-09-05 09:00:00', 'Shipped', 150.00),
(1011, 108, '2023-10-01 14:00:00', 'Shipped', 500.00),
(1012, 105, '2023-10-15 11:30:00', 'Shipped', 1200.00),
(1013, 109, '2023-11-10 16:00:00', 'Shipped', 80.00),
(1014, 110, '2023-11-25 10:00:00', 'Cancelled', 250.00),
(1015, 101, '2023-12-01 09:30:00', 'Shipped', 45.00),
(1016, 111, '2024-01-10 13:45:00', 'Shipped', 1350.00),
(1017, 112, '2024-01-22 11:00:00', 'Pending', 400.00),
(1018, 102, '2024-02-05 15:15:00', 'Shipped', 90.00),
(1019, 113, '2024-02-20 10:30:00', 'Shipped', 80.00),
(1020, 101, '2024-03-05 12:00:00', 'Pending', 250.00),
(1021, 104, '2024-03-10 14:00:00', 'Shipped', 500.00),
(1022, 106, '2024-03-12 09:00:00', 'Shipped', 150.00),
(1023, 107, '2024-03-15 16:30:00', 'Shipped', 1200.00),
(1024, 114, '2024-03-18 11:00:00', 'Pending', 80.00),
(1025, 115, '2024-03-20 13:00:00', 'Shipped', 350.00);


-- Insert Order Items (Linking Orders to Products)
INSERT INTO retail_practice.order_items (order_id, product_id, quantity, unit_price) VALUES
(1001, 501, 1, 1200.00), (1001, 502, 1, 150.00),
(1002, 507, 1, 80.00),
(1003, 503, 1, 400.00),
(1004, 501, 1, 1200.00),
(1005, 504, 1, 350.00), (1005, 505, 1, 500.00),
(1006, 509, 1, 60.00),
(1007, 510, 1, 250.00),
(1008, 511, 1, 90.00),
(1009, 504, 1, 350.00),
(1010, 502, 1, 150.00),
(1011, 505, 1, 500.00),
(1012, 501, 1, 1200.00),
(1013, 507, 1, 80.00),
(1014, 510, 1, 250.00),
(1015, 506, 1, 45.00),
(1016, 501, 1, 1200.00), (1016, 502, 1, 150.00),
(1017, 503, 1, 400.00),
(1018, 511, 1, 90.00),
(1019, 507, 1, 80.00),
(1020, 510, 1, 250.00),
(1021, 505, 1, 500.00),
(1022, 502, 1, 150.00),
(1023, 501, 1, 1200.00),
(1024, 507, 1, 80.00),
(1025, 504, 1, 350.00);

-- Insert Legacy Orders (For Union Practice)
INSERT INTO retail_practice.legacy_orders VALUES
(901, 'Old Customer A', '2022-12-01', 150.00),
(902, 'Old Customer B', '2022-12-15', 300.00),
(903, 'Amit Sharma', '2022-11-20', 500.00), -- Duplicate name for UNION ALL testing
(904, 'Old Customer C', '2022-10-05', 75.00),
(905, 'Priya Verma', '2022-11-01', 200.00);