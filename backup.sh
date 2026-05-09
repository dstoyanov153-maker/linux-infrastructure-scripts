#!/bin/bash

# ==============================================================================
# DESCRIPTION: Automated Backup with Logging, Error Handling, and Rotation
# AUTHOR: denis_stoyanov
# ==============================================================================

# --- 1. CONFIGURATION (Variables) ---
SOURCE_DIR="/home/deko/important_data"
DEST_DIR="/mnt/backups"
LOG_FILE="/var/log/backup_script.log"
BACKUP_NAME="backup_$(date +%Y-%m-%d).tar.gz"
RETENTION_DAYS=7

# --- 2. LOGGING SETUP ---
exec > >(tee -a "$LOG_FILE") 2>&1

echo "---------------------------------------------------"
echo "BACKUP PROCESS STARTED: $(date)"

# --- 3. PRE-FLIGHT CHECKS ---
mkdir -p "$DEST_DIR"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory $SOURCE_DIR not found. Exiting."
    exit 1
fi

# --- 4. CREATE ARCHIVE (The Backup) ---
echo "Archiving $SOURCE_DIR to $DEST_DIR/$BACKUP_NAME..."
tar -czf "$DEST_DIR/$BACKUP_NAME" "$SOURCE_DIR"

# --- 5. ERROR HANDLING ---
if [ $? -eq 0 ]; then
    echo "SUCCESS: Backup created successfully."
else
    echo "ERROR: Backup failed! Check disk space or permissions."
    exit 1
fi

# --- 6. HOUSEKEEPING (Rotation) ---
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "BACKUP PROCESS FINISHED: $(date)"
echo "---------------------------------------------------"
