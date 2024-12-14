#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Path to wp-config.php
WP_CONFIG="wp-config.php"

# Check if wp-config.php exists
if [[ ! -f $WP_CONFIG ]]; then
    echo "Error: wp-config.php not found in the current directory."
    exit 1
fi

# Extract database credentials from wp-config.php
DB_NAME=$(grep "DB_NAME" $WP_CONFIG | awk -F\' '{print $4}')
DB_USER=$(grep "DB_USER" $WP_CONFIG | awk -F\' '{print $4}')
DB_PASSWORD=$(grep "DB_PASSWORD" $WP_CONFIG | awk -F\' '{print $4}')
DB_HOST=$(grep "DB_HOST" $WP_CONFIG | awk -F\' '{print $4}')

# Check if all credentials were found
if [[ -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$DB_HOST" ]]; then
    echo "Error: Unable to extract database credentials from wp-config.php."
    exit 1
fi

# Define backup file name with timestamp
BACKUP_FILE="db-backup-$(date +%Y%m%d%H%M%S).sql"

# Perform the database dump
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"

# Check if mysqldump was successful
if [[ $? -eq 0 ]]; then
    echo "Database backup successful: $BACKUP_FILE"
else
    echo "Error: Database backup failed."
    exit 1
fi

# Navigate one level up
cd ..

# Print the current directory
CURRENT_DIR=$(pwd)
echo "Navigated to parent directory: $CURRENT_DIR"