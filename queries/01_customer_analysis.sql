-- Interview Tip: Shows ability to aggregate and rank
SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.status NOT IN ('cancelled', 'refunded')
GROUP BY u.user_id, u.username, u.email
ORDER BY total_spent DESC NULLS LAST
LIMIT 5;