#!/bin/bash

# ============================================
# E-COMMERCE DATABASE SETUP SCRIPT
# ============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }

# Display banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║       E-COMMERCE DATABASE PROJECT SETUP                  ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if connection string is provided
if [ -z "$1" ]; then
    print_error "No connection string provided!"
    echo ""
    echo "Usage: ./setup.sh \"postgresql://username:password@hostname/database\""
    echo ""
    echo "For Neon PostgreSQL:"
    echo "1. Go to https://console.neon.tech"
    echo "2. Copy your connection string"
    echo "3. Run: ./setup.sh \"your_connection_string\""
    echo ""
    echo "For local PostgreSQL:"
    echo "  ./setup.sh \"postgresql://localhost:5432/ecommerce_db\""
    exit 1
fi

CONNECTION_STRING="$1"
print_info "Using connection: $(echo $CONNECTION_STRING | sed 's/:[^:]*@/:***@/')"

# Check if psql is installed
if ! command -v psql &> /dev/null; then
    print_error "PostgreSQL client (psql) is not installed!"
    echo "Install it using:"
    echo "  macOS: brew install postgresql"
    echo "  Ubuntu/Debian: sudo apt-get install postgresql-client"
    echo "  Windows: Download from https://www.postgresql.org/download/"
    exit 1
fi

# Test connection
print_info "Testing database connection..."
if ! psql "$CONNECTION_STRING" -c "SELECT 1;" &> /dev/null; then
    print_error "Cannot connect to database!"
    echo "Please check:"
    echo "1. Connection string is correct"
    echo "2. Database server is running"
    echo "3. You have proper permissions"
    exit 1
fi
print_success "Database connection successful"

# Function to execute SQL file with error handling
execute_sql_file() {
    local file_path=$1
    local description=$2
    
    print_info "Executing: $description"
    
    if [ ! -f "$file_path" ]; then
        print_error "File not found: $file_path"
        return 1
    fi
    
    # Create temporary error log
    TEMP_ERROR_LOG=$(mktemp)
    
    # Execute SQL file
    if psql "$CONNECTION_STRING" -f "$file_path" 2>"$TEMP_ERROR_LOG"; then
        print_success "$description completed"
    else
        print_error "Failed to execute: $description"
        echo "Error details:"
        cat "$TEMP_ERROR_LOG"
        rm "$TEMP_ERROR_LOG"
        return 1
    fi
    
    rm "$TEMP_ERROR_LOG"
    return 0
}

# Main setup process
print_info "Starting database setup..."

# Create tables
execute_sql_file "database/schema/01_create_tables.sql" "Creating tables"

# Create indexes
execute_sql_file "database/schema/02_create_indexes.sql" "Creating indexes"

# Insert data
execute_sql_file "database/data/01_insert_categories.sql" "Inserting categories"
execute_sql_file "database/data/02_insert_users.sql" "Inserting users"
execute_sql_file "database/data/03_insert_products.sql" "Inserting products"
execute_sql_file "database/data/04_insert_orders.sql" "Inserting orders"
execute_sql_file "database/data/05_insert_order_items.sql" "Inserting order items"
execute_sql_file "database/data/06_insert_cart_items.sql" "Inserting cart items"

# Create views
execute_sql_file "database/views/01_create_views.sql" "Creating views"

# Verify setup
print_info "Verifying database setup..."
psql "$CONNECTION_STRING" << 'EOF'
SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as columns,
    (xpath('/row/cnt/text()', query_to_xml(format('SELECT COUNT(*) as cnt FROM %I', table_name), false, true, '')))[1]::text::int as rows
FROM information_schema.tables t
WHERE table_schema = 'public'
ORDER BY table_name;
EOF

# Display success message
echo ""
print_success "================================================"
print_success "   DATABASE SETUP COMPLETED SUCCESSFULLY!"
print_success "================================================"
echo ""
print_info "Next Steps:"
echo "  1. Test basic queries:"
echo "     ./run_query.sh \"$CONNECTION_STRING\" queries/01_basic_queries.sql"
echo ""
echo "  2. Run analytical queries:"
echo "     ./run_query.sh \"$CONNECTION_STRING\" queries/02_analytical_queries.sql"
echo ""
echo "  3. Explore business reports:"
echo "     ./run_query.sh \"$CONNECTION_STRING\" queries/03_business_reports.sql"
echo ""
print_info "Quick Test - Count records:"
psql "$CONNECTION_STRING" -c "
SELECT 
    'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'cart_items', COUNT(*) FROM cart_items
ORDER BY table_name;"