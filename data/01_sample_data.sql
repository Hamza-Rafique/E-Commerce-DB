-- Insert categories (hierarchical structure)
INSERT INTO categories (category_name, description, parent_category_id) VALUES 
('Electronics', 'Electronic devices and accessories', NULL),
('Computers & Laptops', 'Computers, laptops, and peripherals', 1),
('Smartphones', 'Mobile phones and accessories', 1),
('Home & Kitchen', 'Home appliances and kitchenware', NULL),
('Furniture', 'Home and office furniture', 4),
('Clothing', 'Apparel and fashion', NULL),
('Men''s Clothing', 'Clothing for men', 6),
('Women''s Clothing', 'Clothing for women', 6),
('Books', 'Books and educational material', NULL),
('Toys & Games', 'Toys and games for all ages', NULL);

-- Insert users
INSERT INTO users (username, email, password_hash, full_name, city, state, country) VALUES 
('john_doe', 'john@example.com', 'hashed_password_1', 'John Doe', 'New York', 'NY', 'USA'),
('jane_smith', 'jane@example.com', 'hashed_password_2', 'Jane Smith', 'Los Angeles', 'CA', 'USA'),
('bob_wilson', 'bob@example.com', 'hashed_password_3', 'Bob Wilson', 'Chicago', 'IL', 'USA'),
('alice_brown', 'alice@example.com', 'hashed_password_4', 'Alice Brown', 'Houston', 'TX', 'USA'),
('charlie_davis', 'charlie@example.com', 'hashed_password_5', 'Charlie Davis', 'Miami', 'FL', 'USA'),
('diana_miller', 'diana@example.com', 'hashed_password_6', 'Diana Miller', 'Seattle', 'WA', 'USA'),
('edward_taylor', 'edward@example.com', 'hashed_password_7', 'Edward Taylor', 'Boston', 'MA', 'USA'),
('fiona_clark', 'fiona@example.com', 'hashed_password_8', 'Fiona Clark', 'Denver', 'CO', 'USA'),
('george_lee', 'george@example.com', 'hashed_password_9', 'George Lee', 'Atlanta', 'GA', 'USA'),
('hannah_wright', 'hannah@example.com', 'hashed_password_10', 'Hannah Wright', 'Phoenix', 'AZ', 'USA');

-- Insert products
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('MacBook Pro 14"', 'Apple MacBook Pro with M3 chip', 1999.99, 1500.00, 2, 'MBP14-M3-001', 25, 'Apple'),
('iPhone 15 Pro', 'Latest iPhone with A17 Pro chip', 999.99, 800.00, 3, 'IP15P-001', 50, 'Apple'),
('Samsung Galaxy S24', 'Android flagship phone', 899.99, 700.00, 3, 'SGS24-001', 40, 'Samsung'),
('Dell XPS 13', 'Windows ultrabook', 1299.99, 1000.00, 2, 'DXPS13-001', 30, 'Dell'),
('Sony WH-1000XM5', 'Noise cancelling headphones', 349.99, 250.00, 1, 'SONYWH5-001', 100, 'Sony'),
('Leather Office Chair', 'Ergonomic office chair', 299.99, 200.00, 5, 'LOFC-001', 20, 'Herman Miller'),
('Coffee Maker', 'Automatic drip coffee maker', 89.99, 60.00, 4, 'CMAKER-001', 75, 'Breville'),
('Men''s T-Shirt', 'Cotton crew neck t-shirt', 24.99, 15.00, 7, 'MTS-001', 200, 'Nike'),
('Women''s Dress', 'Summer floral dress', 59.99, 35.00, 8, 'WD-001', 150, 'Zara'),
('Python Crash Course', 'Learn Python programming', 39.99, 20.00, 9, 'BOOK-PY-001', 300, 'No Starch Press'),
('LEGO Star Wars Set', 'Millennium Falcon building set', 159.99, 100.00, 10, 'LEGO-SW-001', 50, 'LEGO'),
('Wireless Mouse', 'Bluetooth wireless mouse', 29.99, 15.00, 2, 'WMOUSE-001', 500, 'Logitech'),
('4K Monitor', '27-inch 4K UHD monitor', 399.99, 300.00, 2, 'MON4K-001', 60, 'LG'),
('Yoga Mat', 'Non-slip exercise mat', 34.99, 20.00, NULL, 'YOGAMAT-001', 250, 'Gaiam'),
('Blender', 'High-speed kitchen blender', 129.99, 80.00, 4, 'BLENDER-001', 45, 'Vitamix');

-- Insert orders (realistic timeline)
INSERT INTO orders (user_id, order_date, status, total_amount, payment_method, payment_status) VALUES 
(1, '2024-01-15 10:30:00', 'delivered', 2999.98, 'credit_card', 'paid'),
(2, '2024-01-20 14:45:00', 'shipped', 899.99, 'paypal', 'paid'),
(3, '2024-02-05 09:15:00', 'delivered', 424.97, 'credit_card', 'paid'),
(1, '2024-02-10 16:20:00', 'processing', 349.99, 'credit_card', 'paid'),
(4, '2024-02-12 11:00:00', 'pending', 129.98, 'paypal', 'pending'),
(5, '2024-02-15 13:30:00', 'delivered', 319.96, 'credit_card', 'paid'),
(2, '2024-02-18 15:45:00', 'cancelled', 1999.99, 'credit_card', 'refunded'),
(6, '2024-02-20 10:00:00', 'delivered', 89.99, 'credit_card', 'paid'),
(7, '2024-02-22 14:30:00', 'shipped', 519.96, 'paypal', 'paid'),
(8, '2024-02-25 09:45:00', 'processing', 199.98, 'credit_card', 'paid'),
(9, '2024-02-28 16:00:00', 'delivered', 159.99, 'credit_card', 'paid'),
(10, '2024-03-01 11:30:00', 'pending', 74.97, 'paypal', 'pending'),
(1, '2024-03-05 13:15:00', 'delivered', 1299.99, 'credit_card', 'paid'),
(3, '2024-03-08 10:45:00', 'shipped', 699.98, 'credit_card', 'paid');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 1999.99),  -- MacBook Pro
(1, 3, 1, 899.99),   -- Samsung Galaxy
(2, 3, 1, 899.99),   -- Samsung Galaxy
(3, 5, 1, 349.99),   -- Sony Headphones
(3, 12, 2, 29.99),   -- Wireless Mouse (2x)
(4, 5, 1, 349.99),   -- Sony Headphones
(5, 7, 1, 89.99),    -- Coffee Maker
(5, 12, 1, 29.99),   -- Wireless Mouse
(6, 8, 2, 24.99),    -- Men's T-Shirt (2x)
(6, 9, 1, 59.99),    -- Women's Dress
(6, 12, 3, 29.99),   -- Wireless Mouse (3x)
(7, 1, 1, 1999.99),  -- MacBook Pro (cancelled)
(8, 7, 1, 89.99),    -- Coffee Maker
(9, 6, 1, 299.99),   -- Office Chair
(9, 13, 1, 399.99),  -- 4K Monitor
(10, 10, 2, 39.99),  -- Python Book (2x)
(10, 14, 1, 34.99),  -- Yoga Mat
(11, 11, 1, 159.99), -- LEGO Set
(12, 8, 3, 24.99),   -- Men's T-Shirt (3x)
(13, 4, 1, 1299.99), -- Dell XPS
(14, 2, 1, 999.99),  -- iPhone 15 Pro
(14, 12, 1, 29.99);  -- Wireless Mouse

-- Insert cart items (for abandoned cart analysis)
INSERT INTO cart_items (user_id, product_id, quantity, added_at) VALUES 
(1, 15, 1, '2024-03-10 10:00:00'),  -- John has blender in cart
(2, 6, 1, '2024-03-09 14:30:00'),   -- Jane has chair in cart
(2, 13, 1, '2024-03-09 14:35:00'),  -- Jane also has monitor in cart
(4, 2, 1, '2024-03-08 11:20:00'),   -- Alice has iPhone in cart
(5, 11, 2, '2024-03-07 16:45:00'),  -- Charlie has 2 LEGO sets in cart
(8, 5, 1, '2024-03-06 09:15:00');   -- Fiona has headphones in cart