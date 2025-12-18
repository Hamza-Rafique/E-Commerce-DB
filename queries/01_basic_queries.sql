-- ============================================
-- BASIC QUERIES (Foundation Level)
-- ============================================

-- Query 1: Get all active users with their details
SELECT 
    user_id,
    username,
    email,
    full_name,
    city,
    state,
    country,
    created_at,
    last_login,
    is_active
FROM users
WHERE is_active = TRUE
ORDER BY created_at DESC;

-- Query 2: Get all products with category information
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.stock_quantity,
    p.brand,
    p.is_active,
    p.created_at
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
ORDER BY c.category_name, p.product_name;

-- Query 3: Get recent orders with customer details
SELECT 
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount,
    o.payment_method,
    o.payment_status,
    u.username,
    u.full_name,
    u.email
FROM orders o
JOIN users u ON o.user_id = u.user_id
ORDER BY o.order_date DESC
LIMIT 10;

-- Query 4: Get order details with product information
SELECT 
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal,
    c.category_name
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.status NOT IN ('cancelled', 'refunded')
ORDER BY o.order_date DESC, o.order_id;

-- Query 5: Count users by country
SELECT 
    country,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM users
WHERE is_active = TRUE
GROUP BY country
ORDER BY user_count DESC;

-- Query 6: Get products that need restocking
SELECT 
    product_name,
    sku,
    stock_quantity,
    reorder_level,
    CASE 
        WHEN stock_quantity = 0 THEN 'OUT OF STOCK'
        WHEN stock_quantity <= reorder_level THEN 'LOW STOCK'
        ELSE 'IN STOCK'
    END AS stock_status
FROM products
WHERE is_active = TRUE
    AND stock_quantity <= reorder_level
ORDER BY stock_quantity ASC;

-- Query 7: Get pending orders
SELECT 
    order_id,
    order_date,
    total_amount,
    payment_method,
    payment_status,
    shipping_method,
    (SELECT username FROM users WHERE user_id = o.user_id) AS customer_name
FROM orders o
WHERE status = 'pending'
ORDER BY order_date;

-- Query 8: Get products by price range
SELECT 
    product_name,
    category_id,
    price,
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-range'
        WHEN price < 500 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category
FROM products
WHERE is_active = TRUE
ORDER BY price DESC;

-- Query 9: Get user's shopping cart
SELECT 
    u.username,
    p.product_name,
    ci.quantity,
    p.price,
    ci.quantity * p.price AS item_total,
    ci.added_at,
    EXTRACT(DAY FROM CURRENT_TIMESTAMP - ci.added_at) AS days_in_cart
FROM cart_items ci
JOIN users u ON ci.user_id = u.user_id
JOIN products p ON ci.product_id = p.product_id
ORDER BY u.username, ci.added_at DESC;

-- Query 10: Simple revenue summary
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value,
    MIN(total_amount) AS min_order_value,
    MAX(total_amount) AS max_order_value
FROM orders
WHERE status NOT IN ('cancelled', 'refunded')
    AND order_date >= CURRENT_DATE - INTERVAL '30 days';

-- Query 11: Get category hierarchy
SELECT 
    c1.category_name AS parent_category,
    c2.category_name AS child_category,
    c2.description
FROM categories c1
RIGHT JOIN categories c2 ON c1.category_id = c2.parent_category_id
ORDER BY c1.category_name NULLS FIRST, c2.category_name;

-- Query 12: Get orders by status
SELECT 
    status,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_amount,
    AVG(total_amount) AS avg_amount
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Query 13: Get users with their order count
SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(o.order_id) AS order_count,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    COALESCE(AVG(o.total_amount), 0) AS avg_order_value
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id 
    AND o.status NOT IN ('cancelled', 'refunded')
GROUP BY u.user_id, u.username, u.email
ORDER BY total_spent DESC;

-- Query 14: Get products never ordered
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    p.stock_quantity,
    p.created_at
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
    AND NOT EXISTS (
        SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
    )
ORDER BY p.created_at DESC;

-- Query 15: Get daily order count
SELECT 
    DATE(order_date) AS order_day,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS daily_revenue
FROM orders
WHERE status NOT IN ('cancelled', 'refunded')
    AND order_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY DATE(order_date)
ORDER BY order_day DESC;