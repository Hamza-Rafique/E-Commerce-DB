-- ============================================
-- INSERT PRODUCTS DATA
-- ============================================

-- Electronics - Computers & Laptops
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('MacBook Pro 14"', 'Apple MacBook Pro with M3 chip, 16GB RAM, 512GB SSD', 1999.99, 1500.00, 2, 'MBP14-M3-001', 25, 'Apple'),
('Dell XPS 13', 'Windows ultrabook, Intel i7, 16GB RAM, 1TB SSD', 1299.99, 1000.00, 2, 'DXPS13-001', 30, 'Dell'),
('HP Pavilion 15', '15.6" laptop, AMD Ryzen 7, 8GB RAM, 256GB SSD', 699.99, 550.00, 2, 'HPPAV15-001', 45, 'HP'),
('ASUS ROG Zephyrus', 'Gaming laptop, RTX 4070, 32GB RAM, 1TB SSD', 1899.99, 1400.00, 2, 'ASUSROG-001', 15, 'ASUS'),
('Lenovo ThinkPad X1', 'Business laptop, Intel i5, 16GB RAM, 512GB SSD', 1499.99, 1200.00, 2, 'LENX1-001', 20, 'Lenovo');

-- Electronics - Smartphones
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('iPhone 15 Pro', 'Latest iPhone with A17 Pro chip, 256GB', 999.99, 800.00, 3, 'IP15P-256', 50, 'Apple'),
('Samsung Galaxy S24', 'Android flagship, 256GB, 8GB RAM', 899.99, 700.00, 3, 'SGS24-256', 40, 'Samsung'),
('Google Pixel 8 Pro', 'Google flagship with Tensor G3, 256GB', 799.99, 650.00, 3, 'GP8P-256', 35, 'Google'),
('OnePlus 11', 'Android phone with Snapdragon 8 Gen 2, 256GB', 699.99, 550.00, 3, 'OP11-256', 60, 'OnePlus'),
('Xiaomi 13 Pro', 'Chinese flagship with Leica camera, 256GB', 749.99, 600.00, 3, 'XM13P-256', 25, 'Xiaomi');

-- Electronics - Audio
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('Sony WH-1000XM5', 'Noise cancelling over-ear headphones', 349.99, 250.00, 4, 'SONYWH5-001', 100, 'Sony'),
('AirPods Pro (2nd Gen)', 'Apple wireless earbuds with ANC', 249.99, 180.00, 4, 'APP2-001', 150, 'Apple'),
('Bose QuietComfort 45', 'Noise cancelling headphones', 329.99, 240.00, 4, 'BOSEQC45-001', 80, 'Bose'),
('JBL Flip 6', 'Portable Bluetooth speaker', 129.99, 80.00, 4, 'JBLFLIP6-001', 200, 'JBL'),
('Samsung Galaxy Buds 2 Pro', 'Wireless earbuds with ANC', 229.99, 160.00, 4, 'SGBUDS2P-001', 120, 'Samsung');

-- Home & Kitchen - Furniture
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('Leather Office Chair', 'Ergonomic office chair with lumbar support', 299.99, 200.00, 8, 'LOFC-001', 20, 'Herman Miller'),
('Wooden Dining Table', '6-seater dining table, solid oak', 599.99, 400.00, 8, 'WDT-001', 10, 'IKEA'),
('Sofa Bed', 'Convertible sofa bed, medium firm', 799.99, 550.00, 8, 'SOFABED-001', 15, 'Ashley'),
('Bookshelf', '5-tier wooden bookshelf', 199.99, 120.00, 8, 'BSHF-001', 30, 'Sauder'),
('Nightstand', 'Bedside table with drawer', 89.99, 50.00, 8, 'NIGHTSTD-001', 40, 'Walker Edison');

-- Home & Kitchen - Kitchen Appliances
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('Coffee Maker', 'Automatic drip coffee maker, 12 cup', 89.99, 60.00, 9, 'CMAKER-001', 75, 'Breville'),
('Blender', 'High-speed kitchen blender, 1500W', 129.99, 80.00, 9, 'BLENDER-001', 45, 'Vitamix'),
('Air Fryer', 'Digital air fryer, 6 quart', 119.99, 75.00, 9, 'AIRFRY-001', 60, 'Ninja'),
('Toaster Oven', '4-slice toaster oven with convection', 79.99, 50.00, 9, 'TOASTOVN-001', 85, 'Cuisinart'),
('Stand Mixer', 'KitchenAid stand mixer, 5 quart', 399.99, 280.00, 9, 'STMIXER-001', 25, 'KitchenAid');

-- Clothing - Men's
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('Men''s T-Shirt', 'Cotton crew neck t-shirt, various colors', 24.99, 15.00, 16, 'MTS-001', 200, 'Nike'),
('Men''s Jeans', 'Slim fit denim jeans, dark wash', 59.99, 35.00, 16, 'MJNS-001', 150, 'Levi''s'),
('Men''s Hoodie', 'Fleece hoodie with front pocket', 49.99, 30.00, 16, 'MHD-001', 120, 'Champion'),
('Men''s Dress Shirt', 'Formal dress shirt, non-iron', 39.99, 25.00, 16, 'MDS-001', 180, 'Van Heusen'),
('Men''s Shorts', 'Cargo shorts with multiple pockets', 34.99, 20.00, 16, 'MSHTS-001', 160, 'Columbia');

-- Clothing - Women's
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('Women''s Dress', 'Summer floral dress, knee-length', 59.99, 35.00, 17, 'WD-001', 150, 'Zara'),
('Women''s Leggings', 'Yoga leggings, high-waisted', 34.99, 20.00, 17, 'WLEG-001', 250, 'Lululemon'),
('Women''s Blouse', 'Silk blouse, button-down', 49.99, 30.00, 17, 'WBL-001', 130, 'Ann Taylor'),
('Women''s Jacket', 'Denim jacket, oversized fit', 69.99, 45.00, 17, 'WJCKT-001', 90, 'Madewell'),
('Women''s Skirt', 'A-line skirt, midi length', 44.99, 28.00, 17, 'WSKRT-001', 110, 'H&M');

-- Books
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('Python Crash Course', 'Learn Python programming, 3rd edition', 39.99, 20.00, 19, 'BOOK-PY-001', 300, 'No Starch Press'),
('The Alchemist', 'Fiction novel by Paulo Coelho', 16.99, 8.00, 19, 'BOOK-ALCH-001', 500, 'HarperCollins'),
('Atomic Habits', 'Self-help book by James Clear', 27.99, 15.00, 19, 'BOOK-ATOM-001', 400, 'Avery'),
('The Lean Startup', 'Business book by Eric Ries', 29.99, 18.00, 24, 'BOOK-LEAN-001', 250, 'Crown Business'),
('Harry Potter Box Set', 'Complete Harry Potter series', 119.99, 70.00, 21, 'BOOK-HP-001', 100, 'Scholastic');

-- Toys & Games
INSERT INTO products (product_name, description, price, cost_price, category_id, sku, stock_quantity, brand) VALUES 
('LEGO Star Wars Set', 'Millennium Falcon building set, 1350 pieces', 159.99, 100.00, 5, 'LEGO-SW-001', 50, 'LEGO'),
('Monopoly Board Game', 'Classic edition board game', 24.99, 15.00, 25, 'MONOP-001', 200, 'Hasbro'),
('Nintendo Switch', 'Gaming console with Joy-Cons', 299.99, 220.00, 7, 'NSWITCH-001', 75, 'Nintendo'),
('PlayStation 5', 'Gaming console with DualSense controller', 499.99, 380.00, 7, 'PS5-001', 40, 'Sony'),
('Barbie Dreamhouse', 'Doll house with accessories', 199.99, 130.00, 5, 'BARBIE-001', 30, 'Mattel');

-- Set some products as inactive and low stock
UPDATE products SET is_active = FALSE WHERE product_id IN (3, 8, 12);
UPDATE products SET stock_quantity = 2 WHERE product_id IN (5, 10, 15);
UPDATE products SET stock_quantity = 0 WHERE product_id IN (20, 25);

-- Verify insertion
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.stock_quantity,
    p.brand,
    p.is_active
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY p.category_id, p.product_id;