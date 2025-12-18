-- ============================================
-- CREATE USEFUL VIEWS
-- ============================================

-- View 1: Customer Order Summary
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.city,
    u.state,
    u.country,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.status NOT IN ('cancelled', 'refunded') THEN o.total_amount ELSE 0 END) AS total_spent,
    AVG(CASE WHEN o.status NOT IN ('cancelled', 'refunded') THEN o.total_amount END) AS avg_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) AS active_months
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username, u.email, u.city, u.state, u.country;

-- View 2: Product Sales Performance
CREATE OR REPLACE VIEW product_sales_performance AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.brand,
    p.price,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
    COALESCE(SUM(oi.subtotal), 0) AS total_revenue,
    COALESCE(COUNT(DISTINCT oi.order_id), 0) AS times_ordered,
    COALESCE(AVG(oi.quantity), 0) AS avg_order_quantity
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status NOT IN ('cancelled', 'refunded')
GROUP BY p.product_id, p.product_name, c.category_name, p.brand, p.price, p.stock_quantity;

-- View 3: Monthly Sales Report
CREATE OR REPLACE VIEW monthly_sales_report AS
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month,
    TO_CHAR(o.order_date, 'Month') AS month_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.user_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    SUM(oi.quantity) AS total_units_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status NOT IN ('cancelled', 'refunded')
GROUP BY EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date), TO_CHAR(o.order_date, 'Month')
ORDER BY year DESC, month DESC;

-- View 4: Category Performance
CREATE OR REPLACE VIEW category_performance AS
SELECT 
    c.category_id,
    c.category_name,
    COUNT(DISTINCT p.product_id) AS total_products,
    SUM(CASE WHEN p.is_active = TRUE THEN 1 ELSE 0 END) AS active_products,
    COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
    COALESCE(SUM(oi.subtotal), 0) AS total_revenue,
    COALESCE(AVG(p.price), 0) AS avg_product_price,
    COALESCE(MIN(p.price), 0) AS min_product_price,
    COALESCE(MAX(p.price), 0) AS max_product_price
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status NOT IN ('cancelled', 'refunded')
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC;

-- View 5: Abandoned Cart Analysis
CREATE OR REPLACE VIEW abandoned_cart_analysis AS
SELECT 
    ci.user_id,
    u.username,
    u.email,
    COUNT(ci.product_id) AS items_in_cart,
    SUM(ci.quantity) AS total_items,
    SUM(ci.quantity * p.price) AS potential_cart_value,
    MIN(ci.added_at) AS first_added,
    MAX(ci.added_at) AS last_added,
    EXTRACT(DAY FROM CURRENT_TIMESTAMP - MAX(ci.added_at)) AS days_since_last_add,
    CASE 
        WHEN EXTRACT(DAY FROM CURRENT_TIMESTAMP - MAX(ci.added_at)) > 7 THEN 'Abandoned'
        WHEN EXTRACT(DAY FROM CURRENT_TIMESTAMP - MAX(ci.added_at)) > 1 THEN 'At Risk'
        ELSE 'Active'
    END AS cart_status
FROM cart_items ci
JOIN users u ON ci.user_id = u.user_id
JOIN products p ON ci.product_id = p.product_id
WHERE NOT EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.user_id = ci.user_id 
    AND o.order_date > ci.added_at
)
GROUP BY ci.user_id, u.username, u.email
ORDER BY days_since_last_add DESC;

-- View 6: Inventory Status
CREATE OR REPLACE VIEW inventory_status AS
SELECT 
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    p.brand,
    p.stock_quantity,
    p.reorder_level,
    p.price,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Out of Stock'
        WHEN p.stock_quantity <= p.reorder_level THEN 'Low Stock'
        WHEN p.stock_quantity <= p.reorder_level * 2 THEN 'Medium Stock'
        ELSE 'In Stock'
    END AS stock_status,
    CASE 
        WHEN p.stock_quantity <= p.reorder_level THEN p.reorder_level - p.stock_quantity
        ELSE 0
    END AS units_to_reorder,
    p.stock_quantity * p.cost_price AS inventory_value_cost,
    p.stock_quantity * p.price AS inventory_value_retail
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
ORDER BY stock_status, stock_quantity;

-- Verify views created
SELECT table_name, view_definition 
FROM information_schema.views 
WHERE table_schema = 'public'
ORDER BY table_name;