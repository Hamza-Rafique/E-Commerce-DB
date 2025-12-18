#!/bin/bash

# ============================================
# QUERY RUNNER SCRIPT
# ============================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <connection_string> <sql_file> [output_format]"
    echo ""
    echo "Examples:"
    echo "  $0 \"postgresql://user:pass@host/db\" queries/01_basic_queries.sql"
    echo "  $0 \"postgresql://user:pass@host/db\" queries/02_analytical_queries.sql csv"
    echo ""
    exit 1
fi

CONNECTION_STRING="$1"
SQL_FILE="$2"
FORMAT="${3:-aligned}"  # Default to aligned (table format)

# Check if file exists
if [ ! -f "$SQL_FILE" ]; then
    echo "Error: SQL file not found: $SQL_FILE"
    exit 1
fi

echo -e "${BLUE}Running: $SQL_FILE${NC}"
echo ""

# Run the query
psql "$CONNECTION_STRING" \
    -f "$SQL_FILE" \
    --set ON_ERROR_STOP=on \
    --pset pager=off \
    --pset format="$FORMAT"

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Query completed successfully${NC}"
else
    echo ""
    echo "✗ Query failed"
    exit 1
fi