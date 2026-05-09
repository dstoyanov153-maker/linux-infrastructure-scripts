#!/bin/bash

# ==============================================================================
# DESCRIPTION: Automated Backup with Logging, Error Handling, and Rotation
# AUTHOR: deko
# ==============================================================================

# --- 1. CONFIGURATION (Variables) ---
# We define these at the top so the script is easy to update later.
SOURCE_DIR="/home/deko/important_data"
DEST_DIR="/mnt/backups"
LOG_FILE="/var/log/backup_script.log"
# The $(date...) part creates a unique filename like: backup_2026-05-09.tar.gz
BACKUP_NAME="backup_$(date +%Y-%m-%d).tar.gz"
RETENTION_DAYS=7

# --- 2. LOGGING SETUP ---
# 'exec' redirects all output from this point forward.
# 'tee -a' splits the output to the screen and the log file (Append mode).
# '2>&1' ensures that Error messages (STDERR) are also saved to the log.
exec > >(tee -a "$LOG_FILE") 2>&1

echo "---------------------------------------------------"
echo "BACKUP PROCESS STARTED: $(date)"

# --- 3. PRE-FLIGHT CHECKS ---
# Ensure the backup directory exists. -p prevents errors if it already exists.
mkdir -p "$DEST_DIR"

# Check if the source directory actually exists before starting.
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory $SOURCE_DIR not found. Exiting."
    #!/bin/bash

# ==============================================================================
# DESCRIPTION: Automated Backup with Logging, Error Handling, and Rotation
# AUTHOR: deko
# ==============================================================================

# --- 1. CONFIGURATION (Variables) ---
# We define these at the top so the script is easy to update later.
SOURCE_DIR="/home/deko/important_data"
DEST_DIR="/mnt/backups"
LOG_FILE="/var/log/backup_script.log"
# The $(date...) part creates a unique filename like: backup_2026-05-09.tar.gz
BACKUP_NAME="backup_$(date +%Y-%m-%d).tar.gz"
RETENTION_DAYS=7

# --- 2. LOGGING SETUP ---
# 'exec' redirects all output from this point forward.
# 'tee -a' splits the output to the screen and the log file (Append mode).
# '2>&1' ensures that Error messages (STDERR) are also saved to the log.
exec > >(tee -a "$LOG_FILE") 2>&1

echo "---------------------------------------------------"
echo "BACKUP PROCESS STARTED: $(date)"

# --- 3. PRE-FLIGHT CHECKS ---
# Ensure the backup directory exists. -p prevents errors if it already exists.
mkdir -p "$DEST_DIR"

# Check if the source directory actually exists before starting.
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory $SOURCE_DIR not found. Exiting."
    exit 1
fi
#!/bin/bash
# --- 4. CREATE ARCHIVE (The Backup) ---
# -c: Create, -z: Compress (gzip), -f: Filename
echo "Archiving $SOURCE_DIR to $DEST_DIR/$BACKUP_NAME..."
tar -czf "$DEST_DIR/$BACKUP_NAME" "$SOURCE_DIR"

# --- 5. ERROR HANDLING ---
# $? captures the 'Exit Status' of the tar command. 0 = Success.
if [ $? -eq 0 ]; then
    echo "SUCCESS: Backup created successfully."
else
    echo "ERROR: Backup failed! Check disk space or permissions."
    exit 1
fi

# --- 6. HOUSEKEEPING (Rotation) ---
# Find files older than X days and delete them to prevent disk exhaustion.
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "BACKUP PROCESS FINISHED: $(date)"
echo "---------------------------------------------------"
