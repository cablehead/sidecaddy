#!/bin/bash
#

sleep infinity

# Exit on any error
set -e

# Function for timestamped logging
log() {
    echo "[$(date -u +"%Y-%m-%d %H:%M:%S UTC")] $*"
}

# Validate required environment variables
if [ -z "$S3_BUCKET_NAME" ]; then
    log "Error: S3_BUCKET_NAME environment variable is required"
    exit 1
fi

if [ -z "$API_TARGET" ]; then
    log "Error: API_TARGET environment variable is required"
    exit 1
fi

# Clear dist directory if it exists
if [ -d "/app/dist" ]; then
    log "Cleaning existing /app/dist directory"
    rm -rf /app/dist/*
fi

# Download assets from S3
log "Downloading assets from s3://${S3_BUCKET_NAME}/${S3_PREFIX}/"
if aws s3 sync "s3://${S3_BUCKET_NAME}/${S3_PREFIX}/" /app/dist; then
    log "Successfully downloaded assets to /app/dist"
else
    log "Error: Failed to download assets from S3"
    exit 1
fi

# Verify index.html exists
if [ ! -f "/app/dist/index.html" ]; then
    log "Error: index.html not found in downloaded assets"
    log "Contents of /app/dist:"
    ls -la /app/dist
    exit 1
fi

# Log dist contents
log "Contents of /app/dist:"
ls -la /app/dist

# Start Caddy
log "Starting Caddy with API target: ${API_TARGET}"
exec caddy run --config /app/Caddyfile
