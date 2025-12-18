-- ============================================
-- PERFORMANCE INDEXES
-- ============================================

-- Users table indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_users_city ON users(city);
CREATE INDEX idx_users_country ON users(country);

-- Products table indexes
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_stock ON products(stock_quantity);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_brand ON products(brand);
CREATE INDEX idx_products_active ON products(is_active) WHERE is_active = TRUE;

-- Orders table indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date DESC);

-- Order items table indexes
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);

-- Cart items table indexes
CREATE INDEX idx_cart_items_user_id ON cart_items(user_id);
CREATE INDEX idx_cart_items_added_at ON cart_items(added_at);
CREATE INDEX idx_cart_items_user_product ON cart_items(user_id, product_id);

-- Composite indexes for common query patterns
CREATE INDEX idx_orders_date_status ON orders(order_date, status);
CREATE INDEX idx_products_category_price ON products(category_id, price);
CREATE INDEX idx_users_state_city ON users(state, city);