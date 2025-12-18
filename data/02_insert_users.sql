-- ============================================
-- INSERT USERS DATA
-- ============================================

-- Insert 15 sample users
INSERT INTO users (username, email, password_hash, full_name, phone, address, city, state, zip_code, country) VALUES 
('john_doe', 'john.doe@email.com', 'hashed_password_123', 'John Doe', '555-0101', '123 Main St', 'New York', 'NY', '10001', 'USA'),
('jane_smith', 'jane.smith@email.com', 'hashed_password_456', 'Jane Smith', '555-0102', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA'),
('bob_johnson', 'bob.johnson@email.com', 'hashed_password_789', 'Bob Johnson', '555-0103', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA'),
('alice_brown', 'alice.brown@email.com', 'hashed_password_101', 'Alice Brown', '555-0104', '321 Maple Ln', 'Houston', 'TX', '77001', 'USA'),
('charlie_wilson', 'charlie.wilson@email.com', 'hashed_password_202', 'Charlie Wilson', '555-0105', '654 Cedar St', 'Phoenix', 'AZ', '85001', 'USA'),
('diana_miller', 'diana.miller@email.com', 'hashed_password_303', 'Diana Miller', '555-0106', '987 Birch Dr', 'Philadelphia', 'PA', '19101', 'USA'),
('edward_taylor', 'edward.taylor@email.com', 'hashed_password_404', 'Edward Taylor', '555-0107', '147 Spruce Ct', 'San Antonio', 'TX', '78201', 'USA'),
('fiona_clark', 'fiona.clark@email.com', 'hashed_password_505', 'Fiona Clark', '555-0108', '258 Willow Way', 'San Diego', 'CA', '92101', 'USA'),
('george_lewis', 'george.lewis@email.com', 'hashed_password_606', 'George Lewis', '555-0109', '369 Elm St', 'Dallas', 'TX', '75201', 'USA'),
('hannah_walker', 'hannah.walker@email.com', 'hashed_password_707', 'Hannah Walker', '555-0110', '741 Oak St', 'San Jose', 'CA', '95101', 'USA'),
('ian_hall', 'ian.hall@email.com', 'hashed_password_808', 'Ian Hall', '555-0111', '852 Pine Ave', 'Austin', 'TX', '73301', 'USA'),
('julia_young', 'julia.young@email.com', 'hashed_password_909', 'Julia Young', '555-0112', '963 Maple Rd', 'Jacksonville', 'FL', '32201', 'USA'),
('kevin_king', 'kevin.king@email.com', 'hashed_password_010', 'Kevin King', '555-0113', '159 Cedar Ln', 'Fort Worth', 'TX', '76101', 'USA'),
('lisa_scott', 'lisa.scott@email.com', 'hashed_password_111', 'Lisa Scott', '555-0114', '357 Birch Dr', 'Columbus', 'OH', '43201', 'USA'),
('michael_adams', 'michael.adams@email.com', 'hashed_password_222', 'Michael Adams', '555-0115', '753 Spruce Way', 'Charlotte', 'NC', '28201', 'USA');

-- Set some users as inactive
UPDATE users SET is_active = FALSE WHERE user_id IN (3, 7, 12);

-- Update last login dates (randomly distributed)
UPDATE users SET last_login = CURRENT_TIMESTAMP - INTERVAL '1 day' WHERE user_id IN (1, 2, 5, 8);
UPDATE users SET last_login = CURRENT_TIMESTAMP - INTERVAL '3 days' WHERE user_id IN (4, 6, 9, 11);
UPDATE users SET last_login = CURRENT_TIMESTAMP - INTERVAL '7 days' WHERE user_id IN (10, 13, 14);
UPDATE users SET last_login = CURRENT_TIMESTAMP - INTERVAL '30 days' WHERE user_id IN (15);

-- Verify insertion
SELECT 
    user_id,
    username,
    email,
    city,
    state,
    country,
    is_active,
    last_login
FROM users 
ORDER BY user_id;