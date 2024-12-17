#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "
    Creting a back up of this WordPress website"

# Define a timestamp variable
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Path to wp-config.php
WP_CONFIG="wp-config.php"

# Check if wp-config.php exists
if [[ ! -f $WP_CONFIG ]]; then
    echo "
    Error: wp-config.php not found in the current directory.
    Run this command from the public_html folder of the wordpress website you want to back up"
    exit 1
fi

# Extract database name from wp-config.php
DB_NAME=$(grep "DB_NAME" $WP_CONFIG | awk -F\' '{print $4}')

# Extract database user from wp-config.php
DB_USER=$(grep "DB_USER" $WP_CONFIG | awk -F\' '{print $4}')

# Extract database password from wp-config.php
DB_PASSWORD=$(grep "DB_PASSWORD" $WP_CONFIG | awk -F\' '{print $4}')

# Extract database host from wp-config.php
DB_HOST=$(grep "DB_HOST" $WP_CONFIG | awk -F\' '{print $4}')

# Check if all database credentials were extracted
if [[ -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$DB_HOST" ]]; then
    echo "Error: Unable to extract database credentials from wp-config.php."
    exit 1
fi

# Define the backup SQL file name with timestamp
DB_FILE="db-backup-${TIMESTAMP}.sql"

# Create a database dump and save it inside public_html
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$DB_FILE"

# Confirm if the database dump was successful
if [[ $? -eq 0 ]]; then
    echo "
    Database downloaded to public_html: $DB_FILE
    
    Now, let's zip the public_html folder
    
    "
else
    echo "Error: Database backup failed."
    exit 1
fi

# Define the zip file name with timestamp, to be saved one level up
ZIP_FILE="../wpbackup${TIMESTAMP}.zip"

# Create a zip archive of the current directory (public_html) and save it one level higher
zip -rq "$ZIP_FILE" .

# Confirm if the zip operation was successful
if [[ $? -eq 0 ]]; then
    echo "
    public_html folder and database backup sucessfully created.
    
    Back up file name: $ZIP_FILE
    
    The website backup is located in the parent directory of the public_html folder.
    
    "
else
    echo "Error: Failed to zip public_html folder."
    exit 1
fi

# Delete the downloaded database dump file
#rm -f "$DB_FILE"
# Delete the current script (wpbackup.sh)
#SCRIPT_NAME="$0"  # This stores the script's full path
#rm -f "$SCRIPT_NAME"
