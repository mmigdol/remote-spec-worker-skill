#!/bin/bash

# --- COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== REMOTE SPEC WORKER SETUP ===${NC}"

# 1. Get the absolute path of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# 2. Create the symlink in /usr/local/bin
echo -e "🔗 Linking 'spec-status' to /usr/local/bin..."
if ln -sf "$SCRIPT_DIR/dashboard.sh" /usr/local/bin/spec-status 2>/dev/null; then
  echo -e "✅ Linked successfully."
else
  echo -e "⚠️ Permission denied. Trying with sudo..."
  sudo ln -sf "$SCRIPT_DIR/dashboard.sh" /usr/local/bin/spec-status
  echo -e "✅ Linked successfully with sudo."
fi

# 3. Setup Slack Webhook
WEBHOOK_FILE="$HOME/.gemini/remote-spec-webhook.url"
if [ ! -f "$WEBHOOK_FILE" ]; then
  echo -e "\n💬 Slack Webhook Configuration"
  read -p "Enter your Slack Webhook URL (or press Enter to skip): " WEBHOOK_URL
  if [ ! -z "$WEBHOOK_URL" ]; then
    mkdir -p ~/.gemini
    echo "$WEBHOOK_URL" > "$WEBHOOK_FILE"
    echo -e "✅ Webhook saved to $WEBHOOK_FILE"
  fi
fi

# 4. Check for GH CLI and permissions
echo -e "\n🔍 Checking GitHub CLI permissions..."
if ! command -v gh &> /dev/null; then
  echo "⚠️ GitHub CLI (gh) not found. Please install it to see Cloud Worker status."
elif ! gh auth status --hostname github.com | grep -q "codespace"; then
  echo -e "⚠️ GitHub CLI missing 'codespace' scope."
  echo "👉 Action required: Run 'gh auth refresh -s codespace' after this setup."
else
  echo "✅ GitHub CLI is ready."
fi

echo -e "\n${GREEN}Setup Complete!${NC}"
echo "You can now run 'spec-status' from any terminal."
