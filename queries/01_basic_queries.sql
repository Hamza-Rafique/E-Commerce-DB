-- ============================================
-- BASIC QUERIES - Foundation Level
-- ============================================

-- 1. Get all active users
SELECT user_id, username, email, full_name, city, country
FROM users
WHERE is_active = TRUE
ORDER BY created_at DESC;

-- 2. Get all products with category names
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.stock_quantity,
    c.category_name,
    p.brand
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
ORDER BY p.product_name;

-- 3. Get orders with customer information
SELECT 
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount,
    u.username,
    u.full_name,
    u.email
FROM orders o
JOIN users u ON o.user_id = u.user_id
ORDER BY o.order_date DESC;

-- 4. Get order details with product information
SELECT 
    o.order_id,
    o.order_date,
    o.status,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status NOT IN ('cancelled', 'refunded')
ORDER BY o.order_date DESC, o.order_id;

-- 5. Get users with their order count
SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id 
    AND o.status NOT IN ('cancelled', 'refunded')
GROUP BY u.user_id, u.username, u.email
ORDER BY total_orders DESC;

-- 6. Get low stock products
SELECT 
    product_name,
    sku,
    stock_quantity,
    reorder_level,
    CASE 
        WHEN stock_quantity = 0 THEN 'Out of Stock'
        WHEN stock_quantity <= reorder_level THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM products
WHERE is_active = TRUE
ORDER BY stock_quantity ASC;

-- 7. Get pending orders
SELECT 
    order_id,
    order_date,
    total_amount,
    payment_method,
    payment_status,
    (SELECT username FROM users WHERE user_id = o.user_id) AS customer
FROM orders o
WHERE status = 'pending'
ORDER BY order_date;

-- 8. Get products by category
SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count,
    MIN(p.price) AS min_price,
    MAX(p.price) AS max_price,
    AVG(p.price)::DECIMAL(10,2) AS avg_price
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
WHERE p.is_active = TRUE OR p.product_id IS NULL
GROUP BY c.category_id, c.category_name
ORDER BY c.category_name;

-- 9. Get customer's shopping cart
SELECT 
    u.username,
    p.product_name,
    ci.quantity,
    p.price,
    ci.quantity * p.price AS item_total,
    ci.added_at
FROM cart_items ci
JOIN users u ON ci.user_id = u.user_id
JOIN products p ON ci.product_id = p.product_id
ORDER BY u.username, ci.added_at DESC;

-- 10. Simple revenue calculation
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount)::DECIMAL(10,2) AS avg_order_value
FROM orders
WHERE status NOT IN ('cancelled', 'refunded')
    AND order_date >= CURRENT_DATE - INTERVAL '30 days';