#!/bin/bash

# --- COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PROMPT="$1"
CODESPACE_NAME="potential-enigma-vxvp5q56c6gvg"
SPEC_REPO_DIR="/Users/mmigdol/codespaces-spec-test"

if [ -z "$PROMPT" ]; then
  echo -e "${RED}Error: No prompt provided.${NC}"
  echo "Usage: worker-launch \"Your instructions for Gemini\""
  exit 1
fi

echo -e "${BLUE}=== REMOTE WORKER LAUNCHER (WITH SYNC) ===${NC}"

# 1. LOCAL SYNC (Git Push)
if [ -d "$SPEC_REPO_DIR/.git" ]; then
  echo -e "📤 ${BLUE}Syncing local changes to GitHub...${NC}"
  cd "$SPEC_REPO_DIR"
  git add .
  # Only commit if there are changes
  if ! git diff-index --quiet HEAD --; then
    git commit -m "Local sync before remote launch"
    git push origin main
    echo -e "✅ Local changes pushed to GitHub."
  else
    echo -e "ℹ️  No local changes to sync."
  fi
else
  echo -e "${YELLOW}⚠️  Warning: Local directory $SPEC_REPO_DIR is not a git repo. Skipping sync.${NC}"
fi

echo -e "🚀 Waking up Codespace: ${YELLOW}$CODESPACE_NAME${NC}..."

# 2. REMOTE SYNC & LAUNCH (Git Pull + Gemini)
# We chain the commands: 
#   cd into the repo -> pull the latest -> launch gemini in background
echo -e "🛰️  Sending sync & launch command to cloud..."

REMOTE_CMD="cd /workspaces/codespaces-spec-test && git pull origin main && nohup gemini '$PROMPT' > ~/gemini-last-run.log 2>&1 &"

# Note: The remote path might be different depending on how Codespaces clones it.
# Standard codespace path is usually /workspaces/<repo-name>
gh codespace ssh -c "$CODESPACE_NAME" -- "$REMOTE_CMD"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Success! Cloud worker has synced and is now processing.${NC}"
  echo -e "💬 You will receive a Slack notification when the task is complete."
  echo -e "🔒 You can safely close your laptop now."
else
  echo -e "${RED}❌ Error: Failed to launch the worker.${NC}"
  echo "Check your internet connection and run 'worker-status' to troubleshoot."
fi
echo -e "${BLUE}========================================${NC}"
