#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting n8n on Render.com..."

# Wait a moment for environment to be ready
sleep 2


# Set webhook URL dynamically
if [ -n "$RENDER_EXTERNAL_URL" ]; then
    export WEBHOOK_URL="$RENDER_EXTERNAL_URL"
    export N8N_EDITOR_BASE_URL="$RENDER_EXTERNAL_URL"
    echo "✅ Webhook URL set to: $WEBHOOK_URL"
fi

# Import workflows if they exist and aren't already imported
if [ -d "/home/node/.n8n/workflows" ]; then
    echo "📂 Workflows directory found"
    ls -la /home/node/.n8n/workflows/
fi

# Start n8n
echo "🎯 Launching n8n..."
exec n8n start