rotex-automation_file_copy.sh

#!/bin/bash
# =============================================================================
# Script Name: rotex-automation_file_copy.sh
# Description: Bash automation script to copy a file to a target directory.
#              Demonstrates input parameters, error handling, logging, and idempotency.
# Usage: ./rotex-automation_file_copy.sh <source_file> <target_directory>
# Example: ./rotex-automation_file_copy.sh myfile.txt /tmp/myfolder
# =============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# -------- Input Parameters --------
SOURCE_FILE="$1"
TARGET_DIR="$2"

# -------- Logging Functions --------
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1"
}

error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1" >&2
}

# -------- Input Validation --------
if [[ -z "$SOURCE_FILE" || -z "$TARGET_DIR" ]]; then
    error "Usage: $0 <source_file> <target_directory>"
    exit 1
fi

if [[ ! -f "$SOURCE_FILE" ]]; then
    error "Source file '$SOURCE_FILE' does not exist."
    exit 1
fi

# -------- Idempotent Directory Creation --------
if [[ ! -d "$TARGET_DIR" ]]; then
    log "Target directory '$TARGET_DIR' does not exist. Creating it..."
    mkdir -p "$TARGET_DIR"
else
    log "Target directory '$TARGET_DIR' already exists. Skipping creation."
fi

# -------- File Copy Operation --------
TARGET_FILE="$TARGET_DIR/$(basename "$SOURCE_FILE")"

if [[ -f "$TARGET_FILE" ]]; then
    log "File '$TARGET_FILE' already exists. Skipping copy (idempotent)."
else
    log "Copying '$SOURCE_FILE' to '$TARGET_DIR'..."
    cp "$SOURCE_FILE" "$TARGET_DIR"
    log "Copy completed successfully."
fi

log "Rotex-automation_file_copy script finished."

