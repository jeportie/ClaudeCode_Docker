#!/bin/bash

# Path to the read-only mounted API keys file
API_KEYS_FILE="/etc/secrets/ai_api_keys.conf"

# Check if the file exists
if [ -f "$API_KEYS_FILE" ]; then
    # Source the file line-by-line safely
    while IFS= read -r line; do
        # Skip empty lines or comments
        if [[ -n "$line" && "$line" != \#* ]]; then
            eval "$line"
        fi
    done < "$API_KEYS_FILE"
else
    echo "API keys file not found: $API_KEYS_FILE"
fi
