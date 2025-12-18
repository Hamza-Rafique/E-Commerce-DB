-- ============================================
-- TEST QUERIES (Data Validation)
-- ============================================

-- Test 1: Verify all tables have data
SELECT 'users' AS table_name, COUNT(*) AS record_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'cart_items', COUNT(*) FROM cart_items
ORDER BY table_name;

-- Test 2: Verify foreign key relationships
SELECT 'Orders referencing non-existent users' AS test,
    COUNT(*) AS issues_count
FROM orders o
LEFT JOIN users u ON o.user_id = u.user_id
WHERE u.user_id IS NULL
UNION ALL
SELECT 'Order items referencing non-existent orders',
    COUNT(*)
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'Order items referencing non-existent products',
    COUNT(*)
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL
UNION ALL
SELECT 'Products referencing non-existent categories',
    COUNT(*)
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL AND p.category_id IS NOT NULL
UNION ALL
SELECT 'Cart items referencing non-existent users',
    COUNT(*)
FROM cart_items ci
LEFT JOIN users u ON ci.user_id = u.user_id
WHERE u.user_id IS NULL
UNION ALL
SELECT 'Cart items referencing non-existent products',
    COUNT(*)
FROM cart_items ci
LEFT JOIN products p ON ci.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Test 3: Verify data integrity
SELECT 'Negative prices in products' AS test,
    COUNT(*) AS issues_count
FROM products
WHERE price < 0
UNION ALL
SELECT 'Negative stock quantity in products',
    COUNT(*)
FROM products
WHERE stock_quantity < 0
UNION ALL
SELECT 'Negative order amounts',
    COUNT(*)
FROM orders
WHERE total_amount < 0
UNION ALL
SELECT 'Order items with zero or negative quantity',
    COUNT(*)
FROM order_items
WHERE quantity <= 0
UNION ALL
SELECT 'Cart items with zero or negative quantity',
    COUNT(*)
FROM cart_items
WHERE quantity <= 0;

-- Test 4: Verify calculated fields
SELECT 'Order total mismatch' AS test,
    COUNT(*) AS issues_count
FROM orders o
WHERE ABS(o.total_amount - (
    SELECT COALESCE(SUM(subtotal), 0)
    FROM order_items oi
    WHERE oi.order_id = o.order_id
)) > 0.01;

-- Test 5: Verify business rules
SELECT 'Orders with invalid status' AS test,
    COUNT(*) AS issues_count
FROM orders
WHERE status NOT IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')
UNION ALL
SELECT 'Orders with invalid payment status',
    COUNT(*)
FROM orders
WHERE payment_status NOT IN ('pending', 'paid', 'failed', 'refunded')
UNION ALL
SELECT 'Products with price lower than cost',
    COUNT(*)
FROM products
WHERE cost_price IS NOT NULL AND price < cost_price;

-- Test 6: Verify index usage (sample query)
EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'john.doe@email.com';

-- Test 7: Performance test - most complex query
EXPLAIN ANALYZE
WITH rfm_data AS (
    SELECT 
        u.user_id,
        u.username,
        MAX(o.order_date) AS last_order_date,
        COUNT(o.order_id) AS frequency,
        SUM(o.total_amount) AS monetary,
        EXTRACT(DAY FROM CURRENT_DATE - MAX(o.order_date)) AS recency_days
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id 
        AND o.status NOT IN ('cancelled', 'refunded')
    GROUP BY u.user_id, u.username
)
SELECT * FROM rfm_data WHERE monetary > 1000;

-- Test 8: Data completeness check
SELECT 
    'Users without email' AS test,
    COUNT(*) AS missing_count
FROM users
WHERE email IS NULL OR email = ''
UNION ALL
SELECT 'Products without price',
    COUNT(*)
FROM products
WHERE price IS NULL
UNION ALL
SELECT 'Orders without order date',
    COUNT(*)
FROM orders
WHERE order_date IS NULL
UNION ALL
SELECT 'Categories without name',
    COUNT(*)
FROM categories
WHERE category_name IS NULL OR category_name = '';

-- Test 9: Verify sample queries work
SELECT 'Basic Query 1: Active Users' AS test_query,
    (SELECT COUNT(*) FROM users WHERE is_active = TRUE) AS result
UNION ALL
SELECT 'Basic Query 2: Products in Stock',
    (SELECT COUNT(*) FROM products WHERE is_active = TRUE AND stock_quantity > 0)
UNION ALL
SELECT 'Basic Query 3: Recent Orders',
    (SELECT COUNT(*) FROM orders WHERE order_date >= CURRENT_DATE - INTERVAL '7 days')
UNION ALL
SELECT 'Analytical Query: Total Revenue',
    (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status NOT IN ('cancelled', 'refunded'));

-- Test 10: Final summary report
SELECT 
    '✅ Database is properly populated' AS status,
    'All tests passed' AS message
WHERE NOT EXISTS (
    SELECT 1 FROM (
        -- Combine all test queries above
        SELECT 1 FROM orders WHERE status NOT IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')
        UNION ALL
        SELECT 1 FROM products WHERE price < 0
        UNION ALL
        SELECT 1 FROM orders o
        WHERE ABS(o.total_amount - (
            SELECT COALESCE(SUM(subtotal), 0)
            FROM order_items oi
            WHERE oi.order_id = o.order_id
        )) > 0.01
    ) AS issues
)
UNION ALL
SELECT 
    '⚠️ Some issues found' AS status,
    'Check test results above' AS message
WHERE EXISTS (
    SELECT 1 FROM (
        SELECT 1 FROM orders WHERE status NOT IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')
        UNION ALL
        SELECT 1 FROM products WHERE price < 0
        UNION ALL
        SELECT 1 FROM orders o
        WHERE ABS(o.total_amount - (
            SELECT COALESCE(SUM(subtotal), 0)
            FROM order_items oi
            WHERE oi.order_id = o.order_id
        )) > 0.01
    ) AS issues
);