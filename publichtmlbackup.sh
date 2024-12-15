#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "
    Miguel CSE: 
    Creting a back up of this public_html folder"

# Define a timestamp variable
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Define the zip file name with timestamp, to be saved one level up
ZIP_FILE="../publichtmlbackup${TIMESTAMP}.zip"

# Create a zip archive of the current directory (public_html) and save it one level higher
zip -rq "$ZIP_FILE" .

# Confirm if the zip operation was successful
if [[ $? -eq 0 ]]; then
    echo "
    public_html back up sucessfully created.
    Back up file name: $ZIP_FILE
    The website backup is located in the parent directory of the public_html file."
else
    echo "Error: Failed to zip public_html folder."
    exit 1
fi

# Delete the current script (wpbackup.sh)
SCRIPT_NAME="$0"  # This stores the script's full path
rm -f "$SCRIPT_NAME"
