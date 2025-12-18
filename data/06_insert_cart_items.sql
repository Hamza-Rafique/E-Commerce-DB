-- ============================================
-- INSERT CART ITEMS DATA
-- ============================================

-- Insert abandoned cart items (added more than 1 day ago)
INSERT INTO cart_items (user_id, product_id, quantity, added_at) VALUES 
-- John Doe's cart (active user, will probably check out)
(1, 27, 1, CURRENT_TIMESTAMP - INTERVAL '2 hours'),   -- Blender
(1, 28, 1, CURRENT_TIMESTAMP - INTERVAL '1 hour'),    -- Air Fryer

-- Jane Smith's abandoned cart (added 3 days ago)
(2, 21, 1, CURRENT_TIMESTAMP - INTERVAL '3 days'),    -- Office Chair
(2, 23, 1, CURRENT_TIMESTAMP - INTERVAL '3 days'),    -- Bookshelf
(2, 26, 1, CURRENT_TIMESTAMP - INTERVAL '3 days'),    -- Coffee Maker

-- Bob Johnson's abandoned cart (added 5 days ago)
(3, 6, 1, CURRENT_TIMESTAMP - INTERVAL '5 days'),     -- iPhone 15 Pro
(3, 11, 1, CURRENT_TIMESTAMP - INTERVAL '5 days'),    -- Sony Headphones

-- Alice Brown's cart (recently added)
(4, 36, 1, CURRENT_TIMESTAMP - INTERVAL '6 hours'),   -- Women's Dress
(4, 38, 2, CURRENT_TIMESTAMP - INTERVAL '5 hours'),   -- Women's Blouse (2x)

-- Charlie Wilson's abandoned cart (added 7 days ago)
(5, 41, 2, CURRENT_TIMESTAMP - INTERVAL '7 days'),    -- LEGO Set (2x)
(5, 42, 1, CURRENT_TIMESTAMP - INTERVAL '7 days'),    -- Monopoly Game

-- Diana Miller's cart (active, added today)
(6, 44, 1, CURRENT_TIMESTAMP - INTERVAL '1 hour'),    -- PlayStation 5
(6, 43, 1, CURRENT_TIMESTAMP - INTERVAL '30 minutes'), -- Nintendo Switch

-- Edward Taylor's abandoned cart (added 10 days ago)
(7, 31, 3, CURRENT_TIMESTAMP - INTERVAL '10 days'),   -- Men's T-Shirt (3x)
(7, 33, 1, CURRENT_TIMESTAMP - INTERVAL '10 days'),   -- Men's Hoodie

-- Fiona Clark's cart (added 2 days ago)
(8, 11, 1, CURRENT_TIMESTAMP - INTERVAL '2 days'),    -- Sony Headphones
(8, 13, 1, CURRENT_TIMESTAMP - INTERVAL '2 days'),    -- AirPods Pro

-- George Lewis's abandoned cart (added 14 days ago)
(9, 1, 1, CURRENT_TIMESTAMP - INTERVAL '14 days'),    -- MacBook Pro
(9, 7, 1, CURRENT_TIMESTAMP - INTERVAL '14 days'),    -- Samsung Phone

-- Hannah Walker's active cart
(10, 37, 1, CURRENT_TIMESTAMP - INTERVAL '3 hours'),  -- The Alchemist
(10, 36, 1, CURRENT_TIMESTAMP - INTERVAL '2 hours'),  -- Python Book

-- Ian Hall's abandoned cart (added 30 days ago - definitely abandoned)
(11, 21, 1, CURRENT_TIMESTAMP - INTERVAL '30 days'),  -- Office Chair
(11, 26, 1, CURRENT_TIMESTAMP - INTERVAL '30 days'),  -- Coffee Maker

-- Julia Young's cart (added 1 day ago)
(12, 32, 1, CURRENT_TIMESTAMP - INTERVAL '1 day'),    -- Men's Jeans
(12, 34, 1, CURRENT_TIMESTAMP - INTERVAL '1 day'),    -- Men's Dress Shirt

-- Kevin King's abandoned cart (added 21 days ago)
(13, 27, 1, CURRENT_TIMESTAMP - INTERVAL '21 days'),  -- Blender
(13, 28, 1, CURRENT_TIMESTAMP - INTERVAL '21 days'),  -- Air Fryer

-- Lisa Scott's active cart
(14, 41, 1, CURRENT_TIMESTAMP - INTERVAL '4 hours'),  -- LEGO Set
(14, 42, 2, CURRENT_TIMESTAMP - INTERVAL '3 hours'),  -- Monopoly Game (2x)

-- Michael Adams's abandoned cart (added 15 days ago)
(15, 44, 1, CURRENT_TIMESTAMP - INTERVAL '15 days'),  -- PlayStation 5
(15, 4, 1, CURRENT_TIMESTAMP - INTERVAL '15 days');   -- ASUS Gaming Laptop

-- Verify insertion
SELECT 
    ci.user_id,
    u.username,
    p.product_name,
    ci.quantity,
    p.price,
    ci.quantity * p.price AS potential_value,
    ci.added_at,
    EXTRACT(DAY FROM CURRENT_TIMESTAMP - ci.added_at) AS days_in_cart
FROM cart_items ci
JOIN users u ON ci.user_id = u.user_id
JOIN products p ON ci.product_id = p.product_id
ORDER BY ci.added_at DESC;