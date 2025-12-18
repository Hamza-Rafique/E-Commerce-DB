-- ============================================
-- BUSINESS REPORTS (Executive Dashboards)
-- ============================================

-- Report 1: Executive Dashboard Summary
WITH metrics AS (
    SELECT 
        -- Revenue Metrics
        (SELECT SUM(total_amount) FROM orders 
         WHERE status NOT IN ('cancelled', 'refunded')
         AND order_date >= CURRENT_DATE - INTERVAL '30 days') AS last_30d_revenue,
        
        (SELECT SUM(total_amount) FROM orders 
         WHERE status NOT IN ('cancelled', 'refunded')
         AND order_date >= CURRENT_DATE - INTERVAL '90 days') / 3 AS avg_monthly_revenue,
        
        -- Order Metrics
        (SELECT COUNT(*) FROM orders 
         WHERE status NOT IN ('cancelled', 'refunded')
         AND order_date >= CURRENT_DATE - INTERVAL '30 days') AS last_30d_orders,
        
        -- Customer Metrics
        (SELECT COUNT(DISTINCT user_id) FROM orders 
         WHERE status NOT IN ('cancelled', 'refunded')
         AND order_date >= CURRENT_DATE - INTERVAL '30 days') AS active_customers_30d,
        
        -- Product Metrics
        (SELECT COUNT(*) FROM products WHERE is_active = TRUE AND stock_quantity > 0) AS active_products_in_stock,
        
        -- Cart Metrics
        (SELECT SUM(ci.quantity * p.price) 
         FROM cart_items ci 
         JOIN products p ON ci.product_id = p.product_id
         WHERE ci.added_at < CURRENT_TIMESTAMP - INTERVAL '1 day') AS abandoned_cart_value,
         
        -- Inventory Metrics
        (SELECT SUM(stock_quantity * cost_price) FROM products) AS inventory_cost_value
)
SELECT 
    'Revenue (Last 30 Days)' AS metric,
    TO_CHAR(last_30d_revenue, 'FM$999,999,999.00') AS value
FROM metrics
UNION ALL
SELECT 'Avg Monthly Revenue', TO_CHAR(avg_monthly_revenue, 'FM$999,999,999.00')
FROM metrics
UNION ALL
SELECT 'Orders (Last 30 Days)', last_30d_orders::TEXT
FROM metrics
UNION ALL
SELECT 'Active Customers (30D)', active_customers_30d::TEXT
FROM metrics
UNION ALL
SELECT 'Avg Order Value', 
    TO_CHAR(last_30d_revenue / NULLIF(last_30d_orders, 0), 'FM$999,999.00')
FROM metrics
UNION ALL
SELECT 'Products in Stock', active_products_in_stock::TEXT
FROM metrics
UNION ALL
SELECT 'Abandoned Cart Value', 
    TO_CHAR(abandoned_cart_value, 'FM$999,999.00')
FROM metrics
UNION ALL
SELECT 'Inventory Value', 
    TO_CHAR(inventory_cost_value, 'FM$999,999.00')
FROM metrics
ORDER BY 
    CASE metric 
        WHEN 'Revenue (Last 30 Days)' THEN 1
        WHEN 'Avg Monthly Revenue' THEN 2
        WHEN 'Orders (Last 30 Days)' THEN 3
        WHEN 'Active Customers (30D)' THEN 4
        WHEN 'Avg Order Value' THEN 5
        WHEN 'Products in Stock' THEN 6
        WHEN 'Abandoned Cart Value' THEN 7
        WHEN 'Inventory Value' THEN 8
    END;

-- Report 2: Sales Performance by Category
SELECT 
    c.category_name,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    SUM(oi.quantity) AS units_sold,
    COUNT(DISTINCT o.user_id) AS unique_customers,
    ROUND(SUM(o.total_amount) / COUNT(DISTINCT o.user_id), 2) AS revenue_per_customer,
    ROUND(SUM(o.total_amount) * 100.0 / SUM(SUM(o.total_amount)) OVER(), 2) AS revenue_percentage
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id 
    AND o.status NOT IN ('cancelled', 'refunded')
    AND o.order_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC NULLS LAST;

-- Report 3: Top 10 Customers Report
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.city || ', ' || u.state AS location,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    EXTRACT(DAY FROM CURRENT_DATE - MAX(o.order_date)) AS days_since_last_order,
    CASE 
        WHEN SUM(o.total_amount) >= 2000 THEN 'VIP'
        WHEN SUM(o.total_amount) >= 500 THEN 'Gold'
        WHEN SUM(o.total_amount) >= 100 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_tier
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id 
    AND o.status NOT IN ('cancelled', 'refunded')
GROUP BY u.user_id, u.username, u.email, u.city, u.state
HAVING COUNT(o.order_id) > 0
ORDER BY total_spent DESC
LIMIT 10;

-- Report 4: Inventory Health Report
SELECT 
    c.category_name,
    COUNT(p.product_id) AS total_products,
    SUM(CASE WHEN p.stock_quantity = 0 THEN 1 ELSE 0 END) AS out_of_stock,
    SUM(CASE WHEN p.stock_quantity <= p.reorder_level AND p.stock_quantity > 0 THEN 1 ELSE 0 END) AS low_stock,
    SUM(CASE WHEN p.stock_quantity > p.reorder_level THEN 1 ELSE 0 END) AS in_stock,
    SUM(p.stock_quantity) AS total_units_in_stock,
    SUM(p.stock_quantity * p.cost_price) AS inventory_cost_value,
    SUM(p.stock_quantity * p.price) AS inventory_retail_value,
    ROUND(SUM(p.stock_quantity * (p.price - p.cost_price)), 2) AS potential_profit
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
WHERE p.is_active = TRUE
GROUP BY c.category_id, c.category_name
ORDER BY inventory_retail_value DESC;

-- Report 5: Abandoned Cart Recovery Report
WITH abandoned_carts AS (
    SELECT 
        ci.user_id,
        u.username,
        u.email,
        u.phone,
        STRING_AGG(p.product_name, ', ') AS cart_items,
        SUM(ci.quantity * p.price) AS cart_value,
        MAX(ci.added_at) AS last_activity,
        EXTRACT(DAY FROM CURRENT_TIMESTAMP - MAX(ci.added_at)) AS days_abandoned
    FROM cart_items ci
    JOIN users u ON ci.user_id = u.user_id
    JOIN products p ON ci.product_id = p.product_id
    WHERE ci.added_at < CURRENT_TIMESTAMP - INTERVAL '1 day'
        AND NOT EXISTS (
            SELECT 1 FROM orders o 
            WHERE o.user_id = ci.user_id 
            AND o.order_date > ci.added_at
        )
    GROUP BY ci.user_id, u.username, u.email, u.phone
    HAVING SUM(ci.quantity * p.price) > 50  -- Only carts worth more than $50
)
SELECT 
    user_id,
    username,
    email,
    phone,
    cart_items,
    cart_value,
    last_activity,
    days_abandoned,
    CASE 
        WHEN days_abandoned <= 1 THEN 'High Priority - Contact Today'
        WHEN days_abandoned <= 3 THEN 'Medium Priority - Contact This Week'
        WHEN days_abandoned <= 7 THEN 'Low Priority - Email Campaign'
        ELSE 'Very Low Priority - Newsletter'
    END AS recovery_strategy,
    ROUND(cart_value * 0.1, 2) AS suggested_discount
FROM abandoned_carts
ORDER BY cart_value DESC;

-- Report 6: Product Performance Ranking
WITH product_metrics AS (
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
    LEFT JOIN orders o ON oi.order_id = o.order_id 
        AND o.status NOT IN ('cancelled', 'refunded')
        AND o.order_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY p.product_id, p.product_name, c.category_name, p.brand, p.price, p.stock_quantity
)
SELECT 
    product_name,
    category_name,
    brand,
    price,
    stock_quantity,
    total_units_sold,
    total_revenue,
    times_ordered,
    avg_order_quantity,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY total_units_sold DESC) AS volume_rank,
    RANK() OVER (ORDER BY times_ordered DESC) AS frequency_rank,
    CASE 
        WHEN total_revenue = 0 THEN 'New/No Sales'
        WHEN total_units_sold >= 100 THEN 'Best Seller'
        WHEN total_units_sold >= 50 THEN 'Popular'
        WHEN total_units_sold >= 10 THEN 'Regular'
        ELSE 'Low Volume'
    END AS performance_category
FROM product_metrics
ORDER BY total_revenue DESC;

-- Report 7: Customer Geographic Heatmap
SELECT 
    u.country,
    u.state,
    COUNT(DISTINCT u.user_id) AS total_customers,
    COUNT(DISTINCT o.user_id) AS customers_with_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue,
    COALESCE(AVG(o.total_amount), 0) AS avg_order_value,
    ROUND(COUNT(DISTINCT o.user_id) * 100.0 / NULLIF(COUNT(DISTINCT u.user_id), 0), 2) AS conversion_rate,
    CASE 
        WHEN COALESCE(SUM(o.total_amount), 0) >= 10000 THEN 'High Value'
        WHEN COALESCE(SUM(o.total_amount), 0) >= 5000 THEN 'Medium Value'
        WHEN COALESCE(SUM(o.total_amount), 0) >= 1000 THEN 'Low Value'
        ELSE 'Very Low Value'
    END AS region_value_category
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id 
    AND o.status NOT IN ('cancelled', 'refunded')
WHERE u.country IS NOT NULL AND u.state IS NOT NULL
GROUP BY u.country, u.state
HAVING COUNT(DISTINCT u.user_id) > 0
ORDER BY total_revenue DESC;

-- Report 8: Shipping & Fulfillment Report
SELECT 
    shipping_method,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    AVG(EXTRACT(DAY FROM updated_at - order_date)) AS avg_processing_days,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_orders
FROM orders
WHERE status IN ('delivered', 'shipped')
GROUP BY shipping_method
ORDER BY orders_count DESC;

-- Report 9: Return & Refund Analysis
SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    TO_CHAR(order_date, 'Month') AS month_name,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    SUM(CASE WHEN status = 'refunded' THEN 1 ELSE 0 END) AS refunded_orders,
    SUM(CASE WHEN status IN ('cancelled', 'refunded') THEN total_amount ELSE 0 END) AS lost_revenue,
    ROUND(SUM(CASE WHEN status IN ('cancelled', 'refunded') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS issue_rate
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month')
ORDER BY month DESC;

-- Report 10: Marketing Channel Performance Simulation
-- (In a real scenario, this would join with marketing data)
WITH channel_performance AS (
    SELECT 
        'Organic Search' AS channel,
        1500 AS visitors,
        45 AS conversions,
        12500 AS revenue
    UNION ALL SELECT 'Paid Social', 800, 25, 6200
    UNION ALL SELECT 'Email Marketing', 1200, 60, 9800
    UNION ALL SELECT 'Direct', 500, 20, 4200
    UNION ALL SELECT 'Referral', 300, 15, 3100
)
SELECT 
    channel,
    visitors,
    conversions,
    revenue,
    ROUND(conversions * 100.0 / visitors, 2) AS conversion_rate,
    ROUND(revenue / NULLIF(conversions, 0), 2) AS avg_order_value,
    ROUND(revenue / NULLIF(visitors, 0), 2) AS revenue_per_visitor,
    ROUND((revenue - (visitors * 2)) * 100.0 / NULLIF((visitors * 2), 0), 2) AS estimated_roi
FROM channel_performance
ORDER BY revenue DESC;