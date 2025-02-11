-----------------------------------
-------- Script PostgreSQL --------
-----------------------------------

-- Drop existing tables if they exist
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS shippers;

-- Create tables

CREATE TABLE customers (
    customer_id VARCHAR(5) PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    state VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    last_name VARCHAR(20) NOT NULL,
    first_name VARCHAR(10) NOT NULL,
    title VARCHAR(30),
    title_of_courtesy VARCHAR(25),
    birth_date DATE,
    hire_date DATE,
    address VARCHAR(60),
    city VARCHAR(15),
    state VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    extension VARCHAR(4),
    reports_to INTEGER REFERENCES employees(employee_id)
);

CREATE TABLE shippers (
    shipper_id SERIAL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    phone VARCHAR(24),
    PRIMARY KEY (shipper_id)
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(15) NOT NULL,
    description TEXT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(40) NOT NULL,
    supplier_id INTEGER,
    category_id INTEGER REFERENCES categories(category_id),
    quantity_per_unit VARCHAR(20),
    unit_price NUMERIC(10, 2),
    units_in_stock INTEGER,
    units_on_order INTEGER,
    reorder_level INTEGER,
    discontinued BOOLEAN NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(5) REFERENCES customers(customer_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    ship_via INTEGER REFERENCES shippers(shipper_id),
    freight NUMERIC(10, 2),
    ship_name VARCHAR(40),
    ship_address VARCHAR(60),
    ship_city VARCHAR(15),
    ship_state VARCHAR(15),
    ship_postal_code VARCHAR(10),
    ship_country VARCHAR(15)
);

CREATE TABLE order_details (
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    unit_price NUMERIC(10, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    discount REAL NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

-- Insert sample data

-- Customers
INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, state, postal_code, country, phone) VALUES
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', '030-0074321'),
('ANATR', 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Owner', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', '(5) 555-4729'),
('ANTON', 'Antonio Moreno Taquería', 'Antonio Moreno', 'Owner', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico', '(5) 555-3932'),
('AROUT', 'Around the Horn', 'Thomas Hardy', 'Sales Representative', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK', '(171) 555-7788'),
('BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Order Administrator', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden', '0921-12 34 65');

-- Employees
INSERT INTO employees (last_name, first_name, title, title_of_courtesy, birth_date, hire_date, address, city, state, postal_code, country, extension) VALUES
('Davolio', 'Nancy', 'Sales Representative', 'Ms.', '1948-12-08', '1992-05-01', '507 - 20th Ave. E. Apt. 2A', 'Seattle', 'WA', '98122', 'USA', '5467'),
('Fuller', 'Andrew', 'Vice President, Sales', 'Dr.', '1952-02-19', '1992-08-14', '908 W. Capital Way', 'Tacoma', 'WA', '98401', 'USA', '3457'),
('Leverling', 'Janet', 'Sales Representative', 'Ms.', '1963-08-30', '1992-04-01', '722 Moss Bay Blvd.', 'Kirkland', 'WA', '98033', 'USA', '3355'),
('Peacock', 'Margaret', 'Sales Representative', 'Mrs.', '1937-09-19', '1993-05-03', '4110 Old Redmond Rd.', 'Redmond', 'WA', '98052', 'USA', '5176'),
('Buchanan', 'Steven', 'Sales Manager', 'Mr.', '1955-03-04', '1993-10-17', '14 Garrett Hill', 'London', NULL, 'SW1 8JR', 'UK', '3453');

-- Shippers
INSERT INTO shippers (company_name, phone) VALUES
('Speedy Express', '(503) 555-9831'),
('United Package', '(503) 555-3199'),
('Federal Shipping', '(503) 555-9931');

-- Categories
INSERT INTO categories (category_name, description) VALUES
('Laptops', 'Portable computers for various uses'),
('Desktops', 'Personal computers for desk use'),
('Accessories', 'Computer accessories like keyboards and mice'),
('Peripherals', 'External devices like printers and scanners'),
('Monitors', 'Display screens for computers');

-- Products
INSERT INTO products (product_name, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued) VALUES
('Dell XPS 13', 1, '1 unit', 999.99, 50, 10, 5, FALSE),
('HP Spectre x360', 1, '1 unit', 1099.99, 30, 5, 3, FALSE),
('Logitech MX Master 3', 3, '1 unit', 99.99, 200, 20, 10, FALSE),
('Apple Magic Keyboard', 3, '1 unit', 129.99, 150, 15, 7, FALSE),
('Canon Pixma G6020', 4, '1 unit', 249.99, 75, 10, 5, FALSE),
('Samsung 27" Curved Monitor', 5, '1 unit', 299.99, 40, 8, 4, FALSE),
('ASUS ROG Strix Desktop', 2, '1 unit', 1499.99, 25, 5, 2, FALSE),
('Logitech C920 Webcam', 3, '1 unit', 79.99, 120, 10, 6, FALSE),
('Brother HL-L2395DW Printer', 4, '1 unit', 199.99, 60, 8, 4, FALSE),
('Acer Predator Monitor', 5, '1 unit', 499.99, 35, 7, 3, FALSE);

-- Orders
INSERT INTO orders (customer_id, employee_id, order_date, required_date, shipped_date, ship_via, freight, ship_name, ship_address, ship_city, ship_state, ship_postal_code, ship_country) VALUES
('ALFKI', 1, '2024-01-01', '2024-01-15', '2024-01-10', 1, 29.46, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany'),
('ANATR', 2, '2024-01-03', '2024-01-17', '2024-01-12', 2, 45.60, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
('ANTON', 3, '2024-01-05', '2024-01-19', '2024-01-15', 3, 12.34, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico'),
('AROUT', 4, '2024-01-07', '2024-01-21', '2024-01-17', 1, 67.89, 'Around the Horn', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK'),
('BERGS', 5, '2024-01-09', '2024-01-23', '2024-01-19', 2, 23.45, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden'),
('ALFKI', 1, '2024-01-11', '2024-01-25', '2024-01-21', 3, 34.56, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany'),
('ANATR', 2, '2024-01-13', '2024-01-27', '2024-01-23', 1, 56.78, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
('ANTON', 3, '2024-01-15', '2024-01-29', '2024-01-25', 2, 78.90, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico'),
('AROUT', 4, '2024-01-17', '2024-01-31', '2024-01-27', 3, 12.34, 'Around the Horn', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK'),
('BERGS', 5, '2024-01-19', '2024-02-02', '2024-01-29', 1, 56.78, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden');

-- Order Details
INSERT INTO order_details (order_id, product_id, unit_price, quantity, discount) VALUES
(1, 1, 999.99, 2, 0.0),
(1, 3, 99.99, 5, 0.1),
(2, 2, 1099.99, 1, 0.05),
(3, 4, 129.99, 3, 0.0),
(4, 5, 249.99, 2, 0.2),
(5, 6, 299.99, 1, 0.15),
(6, 7, 1499.99, 2, 0.1),
(7, 8, 79.99, 4, 0.05),
(8, 9, 199.99, 3, 0.2),
(9, 10, 499.99, 1, 0.0),
(10, 1, 999.99, 1, 0.15);
