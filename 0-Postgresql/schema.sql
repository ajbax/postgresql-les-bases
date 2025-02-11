DROP TABLE IF EXISTS states;
DROP TABLE IF EXISTS inventory_movements;
DROP TABLE IF EXISTS order_salespersons;
DROP TABLE IF EXISTS salespersons;
DROP TABLE IF EXISTS product_suppliers;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

-- Categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    parent_category_id INTEGER REFERENCES categories(category_id), -- For hierarchical categories
    category_name VARCHAR(255) NOT NULL,
    category_description TEXT
);

-- Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES categories(category_id) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_description TEXT,
    sku VARCHAR(255) UNIQUE NOT NULL, -- Stock Keeping Unit
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE
);

-- Product Images (separate table for flexibility)
CREATE TABLE product_images (
    image_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id) NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE -- To indicate the primary image
);


-- Customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(30),
    state VARCHAR(30),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,  -- Calculated on order creation
    order_status VARCHAR(50) DEFAULT 'Pending', -- e.g., Pending, Processing, Shipped, Delivered, Cancelled
    shipping_address TEXT,
    billing_address TEXT
);

-- Order Items (for multiple products in one order)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) NOT NULL,
    product_id INTEGER REFERENCES products(product_id) NOT NULL,
    quantity INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL -- Price at the time of order (important for historical data)
);

-- Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_name VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    address TEXT
);

-- Product-Supplier relationship (many-to-many)
CREATE TABLE product_suppliers (
    product_id INTEGER REFERENCES products(product_id) NOT NULL,
    supplier_id INTEGER REFERENCES suppliers(supplier_id) NOT NULL,
    lead_time INTEGER, -- Days
    price_from_supplier DECIMAL(10,2),
    PRIMARY KEY (product_id, supplier_id) -- Composite key to prevent duplicates
);

-- Salespersons
CREATE TABLE salespersons (
    salesperson_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- Order-Salesperson relationship (One to Many, an order is handled by one salesperson)
CREATE TABLE order_salespersons (
  order_id INTEGER REFERENCES orders(order_id) NOT NULL,
  salesperson_id INTEGER REFERENCES salespersons(salesperson_id) NOT NULL,
  PRIMARY KEY (order_id, salesperson_id)
);

-- Inventory Tracking (Optional, but recommended)
CREATE TABLE inventory_movements (
    movement_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id) NOT NULL,
    quantity_change INTEGER NOT NULL, -- Positive for incoming stock, negative for outgoing
    movement_type VARCHAR(50) CHECK (movement_type IN ('Purchase', 'Sale', 'Return', 'Adjustment')),
    movement_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    order_item_id INTEGER REFERENCES order_items(order_item_id) -- Link to order item if applicable
);

CREATE TABLE states (
    state_id SERIAL PRIMARY KEY,  -- Or use a two-letter abbreviation as the primary key if you prefer
    state_name VARCHAR(255) UNIQUE NOT NULL, -- Ensure state names are unique
    state_abbreviation CHAR(2) UNIQUE NOT NULL -- Add a two-letter abbreviation for convenience
);

-- Categories
INSERT INTO categories (category_name, category_description) VALUES
('Electronics', 'Devices and gadgets'),
('Clothing', 'Apparel for men and women'),
('Books', 'A wide selection of books'),
('Home & Kitchen', 'Furniture and appliances'),
('Electronics Accessories', 'Cables, chargers, etc.'); -- Example of a subcategory
('Sporting Goods', 'Equipment and apparel for sports'),
('Toys & Games', 'Fun for all ages'),
('Beauty & Personal Care', 'Cosmetics and toiletries'),
('Pet Supplies', 'Everything for your furry friends');


INSERT INTO categories (parent_category_id, category_name, category_description) VALUES
(1, 'Smartphones', 'Mobile phones'), -- Subcategory of Electronics
(1, 'Laptops', 'Portable computers'); -- Subcategory of Electronics
INSERT INTO categories (parent_category_id, category_name, category_description) VALUES
(1, 'Running Shoes', 'Footwear for running'),  -- Subcategory of Sporting Goods
(1, 'Basketballs', 'Balls for basketball'), -- Subcategory of Sporting Goods
(2, 'Board Games', 'Games for families and friends'), -- Subcategory of Toys & Games
(2, 'Action Figures', 'Collectible toys'), -- Subcategory of Toys & Games
(3, 'Makeup', 'Cosmetics for the face'), -- Subcategory of Beauty & Personal Care
(4, 'Dog Food', 'Food for dogs'), -- Subcategory of Pet Supplies
(4, 'Cat Toys', 'Toys for cats'); -- Subcategory of Pet Supplies

-- Products
INSERT INTO products (category_id, product_name, product_description, sku, price, stock_quantity) VALUES
(6, 'iPhone 13', 'Apple iPhone 13', 'IPH13-128GB', 999.99, 50),  -- Using the Smartphones category
(6, 'Samsung Galaxy S22', 'Samsung Galaxy S22', 'SAM-S22-256GB', 899.99, 30), -- Using the Smartphones category
(7, 'Dell XPS 15', 'Dell XPS 15 Laptop', 'DEL-XPS15', 1499.99, 20), -- Using the Laptops category
(3, 'The Lord of the Rings', 'J.R.R. Tolkien', 'LOTR-001', 19.99, 100),
(2, 'T-Shirt (Men)', 'Cotton T-Shirt', 'TSH-M-BLUE', 29.99, 75),
(8, 'Nike Running Shoes', 'Air Zoom Pegasus', 'NKE-RUN-001', 120.00, 30),
(9, 'Spalding Basketball', 'NBA Official Game Ball', 'SPA-BASK-001', 35.00, 50),
(10, 'Monopoly', 'Classic board game', 'MNO-GAME-001', 25.00, 75),
(11, 'Marvel Action Figure', 'Spider-Man', 'MARV-FIG-001', 15.00, 100),
(12, 'Maybelline Mascara', 'Volum Express', 'MAYB-MASC-001', 10.00, 60),
(13, 'Purina Dog Food', 'Pro Plan', 'PUR-DOG-001', 40.00, 45),
(14, 'Catnip Toy', 'Mouse shape', 'CAT-TOY-001', 5.00, 90),
(6, 'iPhone 14', 'Apple iPhone 14', 'IPH14-256GB', 1099.99, 40),
(7, 'HP Spectre x360', 'HP Spectre x360 Laptop', 'HP-SPEC-X360', 1699.99, 15);


-- Product Images
INSERT INTO product_images (product_id, image_url, is_main) VALUES
(1, 'https://example.com/iphone13.jpg', TRUE),
(1, 'https://example.com/iphone13_back.jpg', FALSE),
(2, 'https://example.com/s22.jpg', TRUE),
(3, 'https://example.com/dell_xps.jpg', TRUE),
(4, 'https://example.com/lotr.jpg', TRUE),
(5, 'https://example.com/tshirt.jpg', TRUE),
(6, 'https://example.com/nike_running.jpg', TRUE),
(7, 'https://example.com/spalding_ball.jpg', TRUE),
(8, 'https://example.com/monopoly.jpg', TRUE),
(9, 'https://example.com/spiderman.jpg', TRUE),
(10, 'https://example.com/mascara.jpg', TRUE),
(11, 'https://example.com/dog_food.jpg', TRUE),
(12, 'https://example.com/cat_toy.jpg', TRUE),
(13, 'https://example.com/iphone14.jpg', TRUE),
(14, 'https://example.com/hp_spectre.jpg', TRUE);


-- Customers
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('John', 'Doe', 'john.doe@example.com', '555-123-4567', '123 Main St'),
('Jane', 'Smith', 'jane.smith@example.com', '555-987-6543', '456 Oak Ave'),
('David', 'Lee', 'david.lee@example.com', '555-567-8901', '789 Pine St'),
('Sarah', 'Jones', 'sarah.j@example.com', '555-101-1122', '101 Elm Ave'),
('Michael', 'Brown', 'michael.b@example.com', '555-223-3344', '202 Maple Dr'),
('Emily', 'Davis', 'emily.d@example.com', '555-445-5566', '303 Oak Ln');


-- Orders
INSERT INTO orders (customer_id, total_amount, shipping_address, billing_address) VALUES
(1, 1029.98, '123 Main St', '123 Main St'), -- iPhone 13 + T-shirt
(2, 1519.98, '456 Oak Ave', '456 Oak Ave'), -- Dell XPS + LOTR
(3, 135.00, '789 Pine St', '789 Pine St'),  -- Nike Running Shoes
(4, 40.00, '101 Elm Ave', '101 Elm Ave'),  -- Purina Dog Food
(1, 1124.98, '123 Main St', '123 Main St'), -- iPhone 14 + T-shirt
(2, 1719.98, '456 Oak Ave', '456 Oak Ave'); -- HP Spectre + LOTR

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 999.99), -- iPhone 13
(1, 5, 1, 29.99), -- T-Shirt
(2, 3, 1, 1499.99),  -- Dell XPS
(2, 4, 1, 19.99),  -- LOTR
(3, 6, 1, 120.00),  -- Nike Running Shoes
(3, 9, 1, 15.00), -- Marvel Action Figure
(4, 11, 1, 40.00), -- Purina Dog Food
(5, 13, 1, 1099.99), -- iPhone 14
(5, 5, 1, 29.99), -- T-Shirt
(6, 14, 1, 1699.99), -- HP Spectre
(6, 4, 1, 19.99);  -- LOTR


-- Suppliers
INSERT INTO suppliers (supplier_name, contact_name, contact_email, contact_phone, address) VALUES
('Apple Inc.', 'Tim Cook', 'tim.cook@apple.com', '1-800-MY-APPLE', '1 Infinite Loop, Cupertino, CA'),
('Samsung', 'DJ Koh', 'dj.koh@samsung.com', '1-800-SAMSUNG', 'Samsung Town, Seoul'),
('Dell', 'Michael Dell', 'michael@dell.com', '1-800-BUY-DELL', 'Round Rock, TX'),
('Penguin Random House', 'Madeline McIntosh', 'madelinem@penguinrandomhouse.com', '1-800-PENGUIN', 'New York, NY'),
('Adidas', 'Kasper Rorsted', 'kasper@adidas.com', '1-800-ADIDAS', 'Herzogenaurach, Germany'),
('Mattel', 'Ynon Kreiz', 'ynon.kreiz@mattel.com', '1-800-MATTEL', 'El Segundo, CA'),
('Nestlé Purina', 'Nina L. Barton', 'nina.barton@purina.com', '1-800-PURINA', 'St. Louis, MO'),
('HP', 'Enrique Lores', 'enrique.lores@hp.com', '1-800-HP', 'Palo Alto, CA');

-- Product-Supplier Relationship
INSERT INTO product_suppliers (product_id, supplier_id, lead_time, price_from_supplier) VALUES
(1, 1, 7, 900.00), -- iPhone from Apple
(2, 2, 10, 800.00), -- Samsung S22 from Samsung
(3, 3, 14, 1300.00), -- Dell XPS from Dell
(4, 4, 30, 15.00),  -- LOTR from Penguin Random House
(5, 4, 30, 20.00),  -- T-shirt from local supplier
(6, 5, 10, 100.00),  -- Nike shoes from Adidas
(7, 6, 14, 30.00),  -- Spalding ball from Mattel
(9, 6, 14, 10.00), -- Marvel figure from Mattel
(11, 7, 7, 35.00), -- Dog food from Purina
(13, 1, 7, 950.00), -- iPhone from Apple
(14, 8, 14, 1500.00);  -- HP Spectre from HP

-- Salespersons
INSERT INTO salespersons (first_name, last_name, email, phone) VALUES
('Alice', 'Johnson', 'alice.j@example.com', '555-111-2222'),
('Bob', 'Williams', 'bob.w@example.com', '555-333-4444'),
('Carol', 'Garcia', 'carol.g@example.com', '555-555-5555'),
('Dan', 'Rodriguez', 'dan.r@example.com', '555-666-6666');

-- Order-Salesperson relationship
INSERT INTO order_salespersons (order_id, salesperson_id) VALUES
(1, 1), -- Order 1 handled by Alice
(2, 2), -- Order 2 handled by Bob
(3, 1),
(4, 2),
(5, 3),
(6, 4);

-- Inventory Movements (Examples)
INSERT INTO inventory_movements (product_id, quantity_change, movement_type, order_item_id) VALUES
(1, -1, 'Sale', 1),  -- iPhone sold
(5, -1, 'Sale', 2),  -- T-Shirt sold
(3, -1, 'Sale', 3),  -- Dell XPS sold
(4, -1, 'Sale', 4),  -- LOTR sold
(1, 50, 'Purchase', NULL), -- iPhone stock received (initial stock)
(5, 75, 'Purchase', NULL), -- T-Shirt stock received (initial stock)
(3, 20, 'Purchase', NULL), -- Dell XPS stock received (initial stock)
(4, 100, 'Purchase', NULL), -- LOTR stock received (initial stock)
(6, -1, 'Sale', 5),  -- Nike Running Shoes sold
(9, -1, 'Sale', 6), -- Marvel Action Figure sold
(11, -1, 'Sale', 7), -- Purina Dog Food sold
(13, -1, 'Sale', 8), -- iPhone 14 sold
(5, -1, 'Sale', 9), -- T-Shirt sold
(14, -1, 'Sale', 10), -- HP Spectre sold
(4, -1, 'Sale', 11), -- LOTR sold
(6, 30, 'Purchase', NULL), -- Nike shoes stock received
(9, 50, 'Purchase', NULL);
