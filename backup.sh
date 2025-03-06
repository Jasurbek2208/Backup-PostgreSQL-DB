#!/bin/bash

echo "Backup script started"

# Load environment variables from .env file
if [ -f .env ]; then
    source <(sed 's/\r$//' .env)
else
    echo ".env file not found"
    exit 1
fi

# Prompt for PostgreSQL database name
read -s -p "Enter Postgre DB name: " DB_NAME
echo

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S.%3N')

BASE_BACKUP_DIR="${BACKEND_FULL_PATH}${BACKUPS_FOLDER_NAME}"
BACKUP_DIR="$BASE_BACKUP_DIR/$DB_NAME/$TIMESTAMP"
SCHEMA_FILE="$BACKUP_DIR/schema-0.sql"
DATA_FILE="$BACKUP_DIR/data.sql"
BACKUP_FILE="$BACKUP_DIR/backup.sql"
DB_HOST="${DB_HOST}"
DB_PORT="${DB_PORT}"
DB_USER="${DB_USER}"
DB_PASSWORD="${DB_PASSWORD}"

# Export the PostgreSQL password for pg_dump
export PGPASSWORD=$DB_PASSWORD

echo "Variables set: TIMESTAMP=$TIMESTAMP, BACKUP_DIR=$BACKUP_DIR"

# Check if the base backup directory exists
if [ ! -d "$BASE_BACKUP_DIR" ]; then
    echo "Error: Backup directory does not exist: $BASE_BACKUP_DIR"
    exit 1
fi
echo "Base backup directory exists: $BASE_BACKUP_DIR"

# Create the timestamped backup directory
mkdir -p "$BACKUP_DIR"
echo "Created backup directory: $BACKUP_DIR"

# Check if pg_dump exists
if ! command -v pg_dump &>/dev/null; then
    echo "Error: pg_dump command not found. Please check your PostgreSQL installation."
    exit 1
fi
echo "pg_dump is available."

# Export schema only
echo "Exporting schema to $SCHEMA_FILE..."
pg_dump --host=$DB_HOST --port=$DB_PORT --username=$DB_USER --no-owner --schema-only --file="$SCHEMA_FILE" $DB_NAME
if [ $? -ne 0 ]; then
    echo "Error: Failed to export schema."
    exit 1
fi
echo "Schema export completed: $SCHEMA_FILE"

# Export data only
echo "Exporting data to $DATA_FILE..."
pg_dump --host=$DB_HOST --port=$DB_PORT --username=$DB_USER --no-owner --data-only --file="$DATA_FILE" $DB_NAME
if [ $? -ne 0 ]; then
    echo "Error: Failed to export data."
    exit 1
fi
echo "Data export completed: $DATA_FILE"

# Export full backup (schema + data)
echo "Exporting full backup to $BACKUP_FILE..."
pg_dump --host=$DB_HOST --port=$DB_PORT --username=$DB_USER --no-owner --file="$BACKUP_FILE" $DB_NAME
if [ $? -ne 0 ]; then
    echo "Error: Failed to export full backup."
    exit 1
fi
echo "Full backup completed: $BACKUP_FILE"

# Cleanup old backups (keep only the last 7 backups by directory)
echo "Cleaning up old backups..."
find "$BASE_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;
echo "Old backups cleaned up."

echo "Backup completed successfully: $BACKUP_DIR"
