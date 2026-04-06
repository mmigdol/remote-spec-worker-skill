#!/bin/bash

# --- COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== REMOTE SPEC WORKER DASHBOARD ===${NC}"
echo ""

# --- SECTION 1: LOCAL STATUS ---
echo -e "${GREEN}[LOCAL LAPTOP]${NC}"

# Check Power
if pmset -g batt | grep -q "Battery Power"; then
  echo -e "🔋 Power: ${YELLOW}BATTERY${NC} (Warning: Long tasks may drain battery)"
else
  echo -e "🔌 Power: ${GREEN}AC ADAPTER${NC}"
fi

# Check Stay-Awake (caffeinate)
if pmset -g assertions | grep -E "PreventSystemSleep|PreventUserIdleSystemSleep" | grep -q "1"; then
  echo -e "☕ Sleep: ${GREEN}PREVENTED${NC} (Worker is active)"
else
  echo -e "🌙 Sleep: ${YELLOW}ALLOWED${NC} (System may sleep if idle)"
fi
echo ""

# --- SECTION 2: CLOUD WORKERS ---
echo -e "${GREEN}[CLOUD WORKERS (Codespaces)]${NC}"

# Check if gh CLI is authenticated for codespaces
if ! gh auth status --hostname github.com | grep -q "codespace"; then
  echo -e "${RED}⚠️ Error: 'gh' CLI missing 'codespace' scope.${NC}"
  echo "Run: gh auth refresh -s codespace"
else
  # List codespaces and colorize the state
  # Added the URL for quick opening in the browser
  gh codespace list --json name,repository,state --template '{{range .}}{{if or (eq .state "Available") (eq .state "Shutdown")}}{{printf "✅ %-30s | %-25s | \033[0;32m%s\033[0m\n   🔗 https://github.com/codespaces/%s\n" .name .repository .state .name}}{{else if eq .state "Active"}}{{printf "🚀 %-30s | %-25s | \033[1;33m%s\033[0m (BILLING)\n   🔗 https://github.com/codespaces/%s\n" .name .repository .state .name}}{{else}}{{printf "⏳ %-30s | %-25s | %s\n   🔗 https://github.com/codespaces/%s\n" .name .repository .state .name}}{{end}}{{end}}'
fi
echo ""

# --- SECTION 3: RECENT WORK ---
echo -e "${GREEN}[RECENT SPEC WORK]${NC}"
if [ -d ~/specs-workspace ]; then
  find ~/specs-workspace -maxdepth 1 -mmin -60 -type f | sed 's|.*/||' | awk '{print "📝 Updated in last hour: " $0}'
else
  echo "No local ~/specs-workspace directory found."
fi

echo -e "\n${BLUE}====================================${NC}"
