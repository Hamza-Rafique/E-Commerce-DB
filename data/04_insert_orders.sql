-- ============================================
-- INSERT ORDERS DATA
-- ============================================

-- Insert 20 sample orders with realistic dates
INSERT INTO orders (user_id, order_date, status, total_amount, payment_method, payment_status, shipping_method) VALUES 
-- January 2024 orders
(1, '2024-01-15 10:30:00', 'delivered', 2999.98, 'credit_card', 'paid', 'express'),
(2, '2024-01-20 14:45:00', 'delivered', 899.99, 'paypal', 'paid', 'standard'),
(3, '2024-01-25 09:15:00', 'delivered', 424.97, 'credit_card', 'paid', 'standard'),
(4, '2024-01-28 16:20:00', 'delivered', 349.99, 'credit_card', 'paid', 'express'),

-- February 2024 orders
(5, '2024-02-05 11:00:00', 'delivered', 129.98, 'paypal', 'paid', 'standard'),
(1, '2024-02-10 13:30:00', 'delivered', 319.96, 'credit_card', 'paid', 'standard'),
(2, '2024-02-12 15:45:00', 'cancelled', 1999.99, 'credit_card', 'refunded', NULL),
(6, '2024-02-15 10:00:00', 'delivered', 89.99, 'credit_card', 'paid', 'standard'),
(7, '2024-02-18 14:30:00', 'delivered', 519.96, 'paypal', 'paid', 'express'),
(8, '2024-02-20 09:45:00', 'delivered', 199.98, 'credit_card', 'paid', 'standard'),
(9, '2024-02-22 16:00:00', 'delivered', 159.99, 'credit_card', 'paid', 'standard'),
(10, '2024-02-25 11:30:00', 'pending', 74.97, 'paypal', 'pending', 'standard'),
(1, '2024-02-28 13:15:00', 'delivered', 1299.99, 'credit_card', 'paid', 'express'),

-- March 2024 orders
(3, '2024-03-02 10:45:00', 'shipped', 699.98, 'credit_card', 'paid', 'express'),
(4, '2024-03-05 14:20:00', 'processing', 199.99, 'paypal', 'paid', 'standard'),
(5, '2024-03-08 09:30:00', 'delivered', 229.98, 'credit_card', 'paid', 'standard'),
(6, '2024-03-10 16:45:00', 'delivered', 1799.97, 'credit_card', 'paid', 'express'),
(7, '2024-03-12 11:15:00', 'delivered', 449.99, 'paypal', 'paid', 'standard'),
(8, '2024-03-15 13:00:00', 'pending', 129.99, 'credit_card', 'pending', 'standard');

-- Add tracking numbers for shipped/delivered orders
UPDATE orders SET tracking_number = 'UPS' || order_id::text || 'US' WHERE status IN ('shipped', 'delivered') AND tracking_number IS NULL;

-- Add shipping and billing addresses
UPDATE orders o
SET shipping_address = u.address || ', ' || u.city || ', ' || u.state || ' ' || u.zip_code,
    billing_address = u.address || ', ' || u.city || ', ' || u.state || ' ' || u.zip_code
FROM users u
WHERE o.user_id = u.user_id;

-- Update some orders to have different billing addresses
UPDATE orders SET billing_address = '456 Corporate Blvd, ' || city || ', ' || state || ' ' || zip_code WHERE order_id IN (1, 5, 10, 15);

-- Verify insertion
SELECT 
    order_id,
    user_id,
    order_date,
    status,
    total_amount,
    payment_method,
    payment_status,
    shipping_method
FROM orders
ORDER BY order_date DESC;