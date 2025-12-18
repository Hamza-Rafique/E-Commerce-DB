-- ============================================
-- INSERT ORDER ITEMS DATA
-- ============================================

-- Order 1: John Doe buys MacBook Pro and Samsung phone
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 1999.99),   -- MacBook Pro
(1, 7, 1, 899.99);    -- Samsung Galaxy

-- Order 2: Jane Smith buys Samsung phone
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(2, 7, 1, 899.99);    -- Samsung Galaxy

-- Order 3: Bob Johnson buys headphones and wireless mouse
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(3, 11, 1, 349.99),   -- Sony Headphones
(3, 22, 2, 29.99);    -- JBL Speaker (as mouse proxy)

-- Order 4: Alice Brown buys headphones
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(4, 11, 1, 349.99);   -- Sony Headphones

-- Order 5: Charlie Wilson buys coffee maker and JBL speaker
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(5, 26, 1, 89.99),    -- Coffee Maker
(5, 22, 1, 29.99);    -- JBL Speaker

-- Order 6: John Doe buys men's clothing
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(6, 31, 2, 24.99),    -- Men's T-Shirt (2x)
(6, 32, 1, 59.99),    -- Men's Jeans
(6, 37, 3, 34.99);    -- Women's Leggings (3x)

-- Order 7: Jane Smith buys MacBook Pro (cancelled)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(7, 1, 1, 1999.99);   -- MacBook Pro

-- Order 8: Diana Miller buys coffee maker
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(8, 26, 1, 89.99);    -- Coffee Maker

-- Order 9: Edward Taylor buys furniture
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(9, 21, 1, 299.99),   -- Office Chair
(9, 23, 1, 199.99);   -- Bookshelf
(9, 29, 1, 19.99);    -- Add some discount

-- Order 10: Fiona Clark buys books
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(10, 36, 2, 39.99),   -- Python Book (2x)
(10, 37, 1, 16.99);   -- The Alchemist

-- Order 11: George Lewis buys LEGO set
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(11, 41, 1, 159.99);  -- LEGO Set

-- Order 12: Hannah Walker buys men's t-shirts
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(12, 31, 3, 24.99);   -- Men's T-Shirt (3x)

-- Order 13: John Doe buys Dell laptop
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(13, 2, 1, 1299.99);  -- Dell XPS

-- Order 14: Bob Johnson buys iPhone and JBL speaker
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(14, 6, 1, 999.99),   -- iPhone 15 Pro
(14, 22, 1, 29.99);   -- JBL Speaker

-- Order 15: Alice Brown buys blender
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(15, 27, 1, 129.99),  -- Blender
(15, 28, 1, 69.99);   -- Air Fryer

-- Order 16: Charlie Wilson buys men's hoodie and jeans
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(16, 33, 2, 49.99),   -- Men's Hoodie (2x)
(16, 32, 1, 59.99),   -- Men's Jeans
(16, 31, 1, 24.99);   -- Men's T-Shirt

-- Order 17: Diana Miller buys ASUS gaming laptop
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(17, 4, 1, 1899.99),  -- ASUS Gaming Laptop
(17, 43, 1, 299.99),  -- Nintendo Switch
(17, 42, 2, 24.99);   -- Monopoly Game (2x)

-- Order 18: Edward Taylor buys women's clothing
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(18, 36, 1, 59.99),   -- Women's Dress
(18, 38, 1, 49.99),   -- Women's Blouse
(18, 39, 1, 69.99),   -- Women's Jacket
(18, 40, 2, 44.99);   -- Women's Skirt (2x)

-- Order 19: Fiona Clark buys PlayStation
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(19, 44, 1, 499.99);  -- PlayStation 5

-- Order 20: George Lewis buys HP laptop
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(20, 3, 1, 699.99),   -- HP Laptop
(20, 13, 1, 249.99),  -- AirPods Pro
(20, 35, 1, 119.99);  -- Harry Potter Books

-- Update order totals based on order items (redundant but ensures consistency)
UPDATE orders o
SET total_amount = (
    SELECT COALESCE(SUM(subtotal), 0)
    FROM order_items oi
    WHERE oi.order_id = o.order_id
);

-- Verify insertion
SELECT 
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.product_id;