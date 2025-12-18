-- ============================================
-- ANALYTICAL QUERIES (Business Intelligence)
-- ============================================

-- Query 1: Customer Lifetime Value (CLV) Analysis
WITH customer_stats AS (
    SELECT 
        u.user_id,
        u.username,
        u.created_at AS signup_date,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_spent,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date,
        AVG(o.total_amount) AS avg_order_value
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id 
        AND o.status NOT IN ('cancelled', 'refunded')
    GROUP BY u.user_id, u.username, u.created_at
)
SELECT 
    user_id,
    username,
    total_orders,
    total_spent,
    avg_order_value,
    CASE 
        WHEN total_spent >= 2000 THEN 'VIP'
        WHEN total_spent >= 500 THEN 'Regular'
        WHEN total_spent > 0 THEN 'Occasional'
        ELSE 'Inactive'
    END AS customer_tier,
    EXTRACT(DAY FROM CURRENT_DATE - first_order_date) AS customer_lifetime_days,
    total_spent / NULLIF(EXTRACT(DAY FROM CURRENT_DATE - first_order_date), 0) * 365 AS projected_yearly_value
FROM customer_stats
ORDER BY total_spent DESC;

-- Query 2: Monthly Revenue Growth
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(total_amount) AS revenue,
        LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)) AS prev_month_revenue
    FROM orders
    WHERE status NOT IN ('cancelled', 'refunded')
        AND order_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') AS month,
    revenue,
    prev_month_revenue,
    ROUND((revenue - prev_month_revenue) * 100.0 / NULLIF(prev_month_revenue, 0), 2) AS growth_percentage
FROM monthly_revenue
ORDER BY month DESC;

-- Query 3: Product Affinity Analysis (Products bought together)
SELECT 
    p1.product_name AS product_a,
    p2.product_name AS product_b,
    COUNT(DISTINCT oi1.order_id) AS times_bought_together,
    ROUND(COUNT(DISTINCT oi1.order_id) * 100.0 / (
        SELECT COUNT(*) FROM orders WHERE status NOT IN ('cancelled', 'refunded')
    ), 2) AS frequency_percentage
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id 
    AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
JOIN orders o ON oi1.order_id = o.order_id
WHERE o.status NOT IN ('cancelled', 'refunded')
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(DISTINCT oi1.order_id) >= 2
ORDER BY times_bought_together DESC
LIMIT 10;

-- Query 4: Customer Retention Rate by Month
WITH customer_cohorts AS (
    SELECT 
        u.user_id,
        DATE_TRUNC('month', u.created_at) AS signup_month,
        DATE_TRUNC('month', o.order_date) AS order_month,
        COUNT(DISTINCT o.order_id) AS orders_in_month
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id 
        AND o.status NOT IN ('cancelled', 'refunded')
        AND o.order_date >= u.created_at
    GROUP BY u.user_id, DATE_TRUNC('month', u.created_at), DATE_TRUNC('month', o.order_date)
),
cohort_size AS (
    SELECT 
        signup_month,
        COUNT(DISTINCT user_id) AS total_users
    FROM customer_cohorts
    GROUP BY signup_month
)
SELECT 
    c.signup_month,
    c.order_month,
    cs.total_users AS cohort_size,
    COUNT(DISTINCT c.user_id) AS retained_users,
    ROUND(COUNT(DISTINCT c.user_id) * 100.0 / cs.total_users, 2) AS retention_rate
FROM customer_cohorts c
JOIN cohort_size cs ON c.signup_month = cs.signup_month
WHERE c.order_month IS NOT NULL
GROUP BY c.signup_month, c.order_month, cs.total_users
ORDER BY c.signup_month DESC, c.order_month;

-- Query 5: RFM Analysis (Recency, Frequency, Monetary)
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
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency) AS f_score,
        NTILE(4) OVER (ORDER BY monetary) AS m_score
    FROM rfm_data
)
SELECT 
    user_id,
    username,
    last_order_date,
    recency_days,
    frequency,
    monetary,
    r_score || f_score || m_score AS rfm_cell,
    CASE 
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 2 THEN 'Loyal Customers'
        WHEN r_score >= 3 THEN 'Recent Customers'
        WHEN r_score = 2 AND f_score >= 2 THEN 'Potential Loyalists'
        WHEN r_score = 1 THEN 'Lost Customers'
        ELSE 'Other'
    END AS customer_segment
FROM rfm_scores
ORDER BY monetary DESC;

-- Query 6: Sales Funnel Analysis
SELECT 
    'Visitors' AS funnel_stage,
    (SELECT COUNT(*) FROM users) AS count,
    NULL AS conversion_rate
UNION ALL
SELECT 
    'Cart Added',
    (SELECT COUNT(DISTINCT user_id) FROM cart_items),
    ROUND((SELECT COUNT(DISTINCT user_id) FROM cart_items) * 100.0 / (SELECT COUNT(*) FROM users), 2)
UNION ALL
SELECT 
    'Orders Placed',
    (SELECT COUNT(DISTINCT user_id) FROM orders),
    ROUND((SELECT COUNT(DISTINCT user_id) FROM orders) * 100.0 / (SELECT COUNT(*) FROM users), 2)
UNION ALL
SELECT 
    'Repeat Customers',
    (SELECT COUNT(DISTINCT user_id) FROM orders GROUP BY user_id HAVING COUNT(*) > 1),
    ROUND((SELECT COUNT(DISTINCT user_id) FROM orders GROUP BY user_id HAVING COUNT(*) > 1) * 100.0 / 
          (SELECT COUNT(DISTINCT user_id) FROM orders), 2)
ORDER BY 
    CASE funnel_stage 
        WHEN 'Visitors' THEN 1
        WHEN 'Cart Added' THEN 2
        WHEN 'Orders Placed' THEN 3
        WHEN 'Repeat Customers' THEN 4
    END;

-- Query 7: Inventory Turnover Ratio
SELECT 
    c.category_name,
    SUM(p.cost_price * p.stock_quantity) AS inventory_cost,
    COALESCE(SUM(oi.quantity * p.cost_price), 0) AS cost_of_goods_sold,
    CASE 
        WHEN SUM(p.cost_price * p.stock_quantity) > 0 
        THEN ROUND(COALESCE(SUM(oi.quantity * p.cost_price), 0) / SUM(p.cost_price * p.stock_quantity), 2)
        ELSE 0 
    END AS turnover_ratio,
    CASE 
        WHEN COALESCE(SUM(oi.quantity * p.cost_price), 0) > 0 
        THEN ROUND(365 * SUM(p.cost_price * p.stock_quantity) / COALESCE(SUM(oi.quantity * p.cost_price), 0), 1)
        ELSE NULL 
    END AS days_inventory_outstanding
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id 
    AND o.status NOT IN ('cancelled', 'refunded')
    AND o.order_date >= CURRENT_DATE - INTERVAL '365 days'
GROUP BY c.category_id, c.category_name
HAVING SUM(p.cost_price * p.stock_quantity) > 0
ORDER BY turnover_ratio DESC;

-- Query 8: Customer Geographic Analysis
SELECT 
    u.country,
    u.state,
    COUNT(DISTINCT u.user_id) AS total_customers,
    COUNT(DISTINCT o.user_id) AS customers_with_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue,
    COALESCE(AVG(o.total_amount), 0) AS avg_order_value,
    ROUND(COUNT(DISTINCT o.user_id) * 100.0 / COUNT(DISTINCT u.user_id), 2) AS conversion_rate
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id 
    AND o.status NOT IN ('cancelled', 'refunded')
WHERE u.country IS NOT NULL
GROUP BY u.country, u.state
HAVING COUNT(DISTINCT u.user_id) > 0
ORDER BY total_revenue DESC;

-- Query 9: Time-Based Sales Pattern
SELECT 
    EXTRACT(HOUR FROM order_date) AS hour_of_day,
    EXTRACT(DOW FROM order_date) AS day_of_week,
    TO_CHAR(order_date, 'Day') AS day_name,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status NOT IN ('cancelled', 'refunded')
    AND order_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY EXTRACT(HOUR FROM order_date), EXTRACT(DOW FROM order_date), TO_CHAR(order_date, 'Day')
ORDER BY day_of_week, hour_of_day;

-- Query 10: Product Profit Margin Analysis
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    p.cost_price,
    ROUND((p.price - p.cost_price) * 100.0 / p.price, 2) AS margin_percentage,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(SUM(oi.subtotal), 0) AS revenue,
    COALESCE(SUM(oi.quantity * p.cost_price), 0) AS cost_of_goods,
    COALESCE(SUM(oi.subtotal) - SUM(oi.quantity * p.cost_price), 0) AS total_profit
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id 
    AND o.status NOT IN ('cancelled', 'refunded')
WHERE p.cost_price IS NOT NULL
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.cost_price
HAVING COALESCE(SUM(oi.quantity), 0) > 0
ORDER BY margin_percentage DESC;

-- Query 11: Abandoned Cart Value Analysis
WITH cart_abandonment AS (
    SELECT 
        ci.user_id,
        SUM(ci.quantity * p.price) AS cart_value,
        MAX(ci.added_at) AS last_activity,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM orders o 
                WHERE o.user_id = ci.user_id 
                AND o.order_date > ci.added_at
            ) THEN 'Converted'
            ELSE 'Abandoned'
        END AS status
    FROM cart_items ci
    JOIN products p ON ci.product_id = p.product_id
    WHERE ci.added_at < CURRENT_TIMESTAMP - INTERVAL '1 day'
    GROUP BY ci.user_id
)
SELECT 
    status,
    COUNT(*) AS carts_count,
    SUM(cart_value) AS total_value,
    AVG(cart_value) AS avg_cart_value,
    MIN(cart_value) AS min_cart_value,
    MAX(cart_value) AS max_cart_value
FROM cart_abandonment
GROUP BY status;

-- Query 12: Customer Acquisition Cost Simulation
WITH monthly_stats AS (
    SELECT 
        DATE_TRUNC('month', u.created_at) AS month,
        COUNT(*) AS new_customers,
        COALESCE(SUM(o.total_amount), 0) AS first_month_revenue
    FROM users u
    LEFT JOIN (
        SELECT user_id, SUM(total_amount) AS total_amount
        FROM orders 
        WHERE status NOT IN ('cancelled', 'refunded')
            AND order_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
        GROUP BY user_id
    ) o ON u.user_id = o.user_id
    WHERE u.created_at >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY DATE_TRUNC('month', u.created_at)
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') AS month,
    new_customers,
    first_month_revenue,
    -- Simulating $10 CAC per customer
    10 * new_customers AS estimated_acquisition_cost,
    ROUND(first_month_revenue / NULLIF(new_customers, 0), 2) AS revenue_per_new_customer,
    ROUND((first_month_revenue - (10 * new_customers)) * 100.0 / NULLIF((10 * new_customers), 0), 2) AS roi_percentage
FROM monthly_stats
ORDER BY month DESC;

-- Query 13: Seasonality Analysis
SELECT 
    EXTRACT(MONTH FROM order_date) AS month_number,
    TO_CHAR(order_date, 'Month') AS month_name,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value,
    COUNT(DISTINCT user_id) AS unique_customers,
    SUM(total_amount) / COUNT(DISTINCT user_id) AS revenue_per_customer
FROM orders
WHERE status NOT IN ('cancelled', 'refunded')
    AND order_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month')
ORDER BY month_number;

-- Query 14: Payment Method Analysis
SELECT 
    payment_method,
    COUNT(*) AS transactions,
    SUM(total_amount) AS total_amount,
    AVG(total_amount) AS avg_transaction_value,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_transactions,
    ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER(), 2) AS percentage_of_revenue
FROM orders
WHERE status NOT IN ('cancelled', 'refunded')
GROUP BY payment_method
ORDER BY total_amount DESC;

-- Query 15: Customer Support Metrics
SELECT 
    'Total Customers' AS metric,
    COUNT(*) AS value
FROM users
WHERE is_active = TRUE
UNION ALL
SELECT 
    'Customers with Issues',
    COUNT(DISTINCT user_id)
FROM orders 
WHERE status IN ('cancelled', 'refunded')
UNION ALL
SELECT 
    'Issue Rate',
    ROUND(COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(*) FROM users), 2)
FROM orders 
WHERE status IN ('cancelled', 'refunded')
UNION ALL
SELECT 
    'Avg Resolution Time (days)',
    ROUND(AVG(EXTRACT(DAY FROM updated_at - order_date)), 1)
FROM orders 
WHERE status IN ('cancelled', 'refunded')
    AND updated_at > order_date;