#!/bin/bash
set -e

CONFIG_DIR="/root/.nanobot"
CONFIG_FILE="$CONFIG_DIR/config.json"
TEMPLATE_FILE="/app/config.template.json"

# Generate config.json from template if it doesn't already exist
if [ ! -f "$CONFIG_FILE" ]; then
  echo "No config.json found — generating from template..."
  mkdir -p "$CONFIG_DIR"
  envsubst < "$TEMPLATE_FILE" > "$CONFIG_FILE"
  echo "Config written to $CONFIG_FILE"
else
  echo "Config already exists at $CONFIG_FILE — skipping generation."
fi

exec nanobot "$@"
