# Expected Test Results

## Test 1: Table Record Counts
- users: Should have 15 records
- categories: Should have ~25 records (including subcategories)
- products: Should have ~45 records
- orders: Should have 20 records
- order_items: Should have 40+ records
- cart_items: Should have 30+ records

## Test 2: Foreign Key Relationships
- All tests should return 0 issues

## Test 3: Data Integrity
- All tests should return 0 issues

## Test 4: Calculated Fields
- Order total mismatch: Should be 0

## Test 5: Business Rules
- Invalid status/payment status: Should be 0
- Price lower than cost: Should be 0

## Test 6: Index Usage
- Should show "Index Scan" on users.email

## Test 7: Performance Test
- Should complete in < 100ms

## Test 8: Data Completeness
- Missing data tests: All should be 0

## Test 9: Sample Query Results
- Active Users: Should be 12 (3 inactive users)
- Products in Stock: Should be 40+
- Recent Orders: Should be 5+
- Total Revenue: Should be > $10,000

## Test 10: Final Summary
- Should show "✅ Database is properly populated"