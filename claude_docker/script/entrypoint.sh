#!/bin/bash
# entrypoint.sh

# If an argument is provided (a mounted project directory), configure it as a safe git directory.
if [ -n "$1" ]; then
    folder_name=$(basename "$1")
    echo "Adding /root/projects/${folder_name} as a safe git directory."
    git config --global --add safe.directory "/root/projects/${folder_name}"
fi

# Disable dubious ownership check globally.
git config --global --add safe.directory "*"

# Load API keys from the secrets file
if [ -f /sh/load_api_keys.sh ]; then
    echo "Running /sh/load_api_keys.sh to load environment variables..."
    source /sh/load_api_keys.sh
else
    echo "Warning: /sh/load_api_keys.sh not found. Skipping API key loading."
fi

# Function to display a progress bar
show_progress() {
    echo -n "Processing"
    for i in {1..10}; do
        echo -n "."
        sleep 0.01
    done
    echo ""
}

# Initialize NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    echo "nvm initialized."
else
    echo "nvm initialization script not found at $NVM_DIR/nvm.sh. Skipping Node.js setup."
fi

# Ensure Node.js version and mcp-hub are installed
NODE_VERSION="v22.14.0"
MCP_VERSION="2.1.0"

# Install Node.js version if not already installed
if command -v nvm > /dev/null 2>&1; then
    if ! nvm ls "$NODE_VERSION" > /dev/null 2>&1; then
        echo "Installing Node.js $NODE_VERSION via nvm..."
        nvm install "$NODE_VERSION"
    else
        echo "Node.js $NODE_VERSION is already installed."
    fi
else
    echo "nvm not available after initialization attempt."
fi

# Use the desired Node.js version explicitly before npm install
if command -v nvm > /dev/null 2>&1; then
    nvm use "$NODE_VERSION"
fi

# Check if npm is available now before installing mcp-hub
if command -v npm > /dev/null 2>&1; then
    if ! npm list -g mcp-hub > /dev/null 2>&1; then
        echo "Installing mcp-hub globally..."
        npm install -g mcp-hub
    else
        echo "mcp-hub@$MCP_VERSION is already installed."
    fi
else
    echo "npm not found. Skipping mcp-hub installation."
fi

# Define the desired version of @anthropic-ai/claude-code
CLAUDE_CODE_VERSION="latest"

# Check if @anthropic-ai/claude-code is installed globally
if ! npm list -g @anthropic-ai/claude-code@"$CLAUDE_CODE_VERSION" > /dev/null 2>&1; then
    echo "Installing @anthropic-ai/claude-code@$CLAUDE_CODE_VERSION globally..."
    npm install -g @anthropic-ai/claude-code@"$CLAUDE_CODE_VERSION" > /dev/null 2>&1 &
    show_progress 10
else
    echo "@anthropic-ai/claude-code@$CLAUDE_CODE_VERSION is already installed."
fi

# Launch zsh.
exec zsh
