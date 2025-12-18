#!/bin/bash

# ============================================
# DATABASE BACKUP SCRIPT
# ============================================

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/ecommerce_db_$TIMESTAMP.sql"

# Check if connection string is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: No connection string provided${NC}"
    echo "Usage: $0 <connection_string>"
    echo "Example: $0 \"postgresql://user:pass@host/db\""
    exit 1
fi

CONNECTION_STRING="$1"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Starting database backup..."
echo "Connection: $(echo $CONNECTION_STRING | sed 's/:[^:]*@/:***@/')"
echo "Backup file: $BACKUP_FILE"

# Perform backup
if pg_dump "$CONNECTION_STRING" \
    --format=plain \
    --no-owner \
    --no-acl \
    --clean \
    --if-exists \
    --verbose \
    --file="$BACKUP_FILE" 2>backup_error.log; then
    
    # Get file size
    FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    
    echo -e "${GREEN}✓ Backup completed successfully${NC}"
    echo "File: $BACKUP_FILE"
    echo "Size: $FILE_SIZE"
    echo ""
    echo "Recent backups:"
    ls -lh "$BACKUP_DIR"/ecommerce_db_*.sql 2>/dev/null | tail -5
    
    # Optional: Clean up old backups (keep last 7 days)
    find "$BACKUP_DIR" -name "ecommerce_db_*.sql" -mtime +7 -delete 2>/dev/null
else
    echo -e "${RED}✗ Backup failed${NC}"
    echo "Error details:"
    cat backup_error.log
    rm -f "$BACKUP_FILE"
    exit 1
fi