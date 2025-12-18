#!/bin/bash

# ============================================
# DATABASE RESTORE SCRIPT
# ============================================

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
BACKUP_DIR="backups"

# Check arguments
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: No connection string provided${NC}"
    echo "Usage: $0 <connection_string> [backup_file]"
    echo ""
    echo "Available backups:"
    ls -lh "$BACKUP_DIR"/ecommerce_db_*.sql 2>/dev/null | sort -r
    exit 1
fi

CONNECTION_STRING="$1"
BACKUP_FILE="$2"

# If no backup file specified, use the latest
if [ -z "$BACKUP_FILE" ]; then
    BACKUP_FILE=$(ls -t "$BACKUP_DIR"/ecommerce_db_*.sql 2>/dev/null | head -1)
    
    if [ -z "$BACKUP_FILE" ]; then
        echo -e "${RED}Error: No backup files found in $BACKUP_DIR${NC}"
        exit 1
    fi
fi

# Confirm restore
echo -e "${YELLOW}⚠️  WARNING: This will overwrite the database!${NC}"
echo "Connection: $(echo $CONNECTION_STRING | sed 's/:[^:]*@/:***@/')"
echo "Backup file: $BACKUP_FILE"
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restore cancelled."
    exit 0
fi

echo "Starting database restore..."
echo "This may take a few minutes..."

# Perform restore
if psql "$CONNECTION_STRING" -f "$BACKUP_FILE" 2>restore_error.log; then
    echo -e "${GREEN}✓ Restore completed successfully${NC}"
    echo ""
    echo "Verifying restore..."
    
    # Quick verification
    psql "$CONNECTION_STRING" -c "
        SELECT 
            table_name,
            (xpath('/row/cnt/text()', query_to_xml(format('SELECT COUNT(*) as cnt FROM %I', table_name), false, true, '')))[1]::text::int as rows
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        ORDER BY table_name;"
else
    echo -e "${RED}✗ Restore failed${NC}"
    echo "Error details:"
    cat restore_error.log
    exit 1
fi