-- ============================================
-- SAMPLE CATEGORIES DATA
-- ============================================

-- Insert categories (hierarchical structure)
INSERT INTO categories (category_name, description, parent_category_id) VALUES 
('Electronics', 'Electronic devices and accessories', NULL),
('Computers & Laptops', 'Computers, laptops, and peripherals', 1),
('Smartphones', 'Mobile phones and accessories', 1),
('Home & Kitchen', 'Home appliances and kitchenware', NULL),
('Furniture', 'Home and office furniture', 4),
('Clothing', 'Apparel and fashion', NULL),
('Men''s Clothing', 'Clothing for men', 6),
('Women''s Clothing', 'Clothing for women', 6),
('Books', 'Books and educational material', NULL),
('Toys & Games', 'Toys and games for all ages', NULL),
('Audio', 'Headphones, speakers, and audio equipment', 1),
('Wearables', 'Smart watches and fitness trackers', 1),
('Kitchen Appliances', 'Appliances for kitchen use', 4),
('Home Decor', 'Home decoration items', 4),
('Shoes', 'Footwear for all occasions', 6),
('Accessories', 'Jewelry, bags, and other accessories', 6),
('Textbooks', 'Educational and academic books', 9),
('Fiction', 'Novels and fictional works', 9),
('Board Games', 'Traditional board games', 10),
('Video Games', 'Console and PC games', 10);

-- Verify insertion
SELECT 
    c1.category_name AS parent_category,
    c2.category_name AS sub_category,
    c2.description
FROM categories c1
RIGHT JOIN categories c2 ON c1.category_id = c2.parent_category_id
ORDER BY c1.category_name NULLS FIRST, c2.category_name;