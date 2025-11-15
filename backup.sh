#!/bin/bash

# ===============================
# Automated Backup Script
# ===============================

# -------------------------------
# Configuration
# -------------------------------

# Source directory to backup
SOURCE_DIR="$HOME/testdata"      # Change this to your actual source

# Remote server / destination directory
REMOTE_SERVER="$HOME/backup_test"  # For local testing. For remote: user@host:/path

# Log file
LOG_FILE="$HOME/backup.log"

# Date for backup folder
DATE=$(date '+%Y-%m-%d_%H-%M-%S')

# -------------------------------
# Ensure directories exist
# -------------------------------

# Create source directory if it doesn't exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory not found. Creating $SOURCE_DIR..."
    mkdir -p "$SOURCE_DIR"
fi

# Create destination directory if it doesn't exist (for local testing)
if [[ "$REMOTE_SERVER" != *":"* ]]; then
    if [ ! -d "$REMOTE_SERVER" ]; then
        echo "Destination directory not found. Creating $REMOTE_SERVER..."
        mkdir -p "$REMOTE_SERVER"
    fi
fi

# -------------------------------
# Run backup
# -------------------------------

echo "Starting backup from $SOURCE_DIR to $REMOTE_SERVER/$DATE ..."
rsync -avz --delete "$SOURCE_DIR/" "$REMOTE_SERVER/$DATE" &>> "$LOG_FILE"

# -------------------------------
# Check backup result
# -------------------------------

if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Backup successful: $SOURCE_DIR -> $REMOTE_SERVER/$DATE" | tee -a "$LOG_FILE"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') Backup FAILED: $SOURCE_DIR -> $REMOTE_SERVER/$DATE" | tee -a "$LOG_FILE"
fi
