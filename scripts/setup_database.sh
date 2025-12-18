#!/bin/bash

# ============================================
# E-COMMERCE DATABASE SETUP SCRIPT
# ============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if connection string is provided
if [ -z "$1" ]; then
    print_error "Please provide Neon PostgreSQL connection string"
    echo "Usage: ./setup_database.sh \"postgresql://user:password@endpoint/database\""
    exit 1
fi

CONNECTION_STRING="$1"

print_message "Starting e-commerce database setup..."
print_message "Connection: $(echo $CONNECTION_STRING | sed 's/:[^:]*@/:***@/')"

# Function to execute SQL file
execute_sql() {
    local file=$1
    local description=$2
    
    print_message "Executing: $description"
    
    if psql "$CONNECTION_STRING" -f "$file" 2>/tmp/sql_error.log; then
        print_message "✓ $description completed successfully"
    else
        print_error "Failed to execute $description"
        cat /tmp/sql_error.log
        exit 1
    fi
}

# Step 1: Create tables
execute_sql "database/schema/01_create_tables.sql" "Creating tables"

# Step 2: Create indexes
execute_sql "database/schema/02_create_indexes.sql" "Creating indexes"

# Step 3: Insert sample data
execute_sql "database/data/01_insert_categories.sql" "Inserting categories"
execute_sql "database/data/02_insert_users.sql" "Inserting users"
execute_sql "database/data/03_insert_products.sql" "Inserting products"
execute_sql "database/data/04_insert_orders.sql" "Inserting orders"
execute_sql "database/data/05_insert_cart_items.sql" "Inserting cart items"

# Step 4: Verify setup
print_message "Verifying database setup..."

psql "$CONNECTION_STRING" << EOF
-- Count records in each table
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
EOF

print_message ""
print_message "========================================"
print_message "✅ DATABASE SETUP COMPLETED SUCCESSFULLY"
print_message "========================================"
print_message ""
print_message "Next steps:"
print_message "1. Test basic queries: psql \"$CONNECTION_STRING\" -f queries/01_basic_queries.sql"
print_message "2. Run analytical queries: psql \"$CONNECTION_STRING\" -f queries/02_analytical_queries.sql"
print_message "3. Explore business reports: psql \"$CONNECTION_STRING\" -f queries/04_business_reports.sql"
print_message ""
print_message "For help: cat docs/Query_Guide.md"