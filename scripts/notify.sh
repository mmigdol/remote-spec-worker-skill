#!/bin/bash

MESSAGE="$1"
WEBHOOK_FILE="$HOME/.gemini/remote-spec-webhook.url"

if [ -z "$MESSAGE" ]; then
  echo "Error: No message provided."
  echo "Usage: $0 \"Message to send\""
  exit 1
fi

if [ ! -f "$WEBHOOK_FILE" ]; then
  echo "Error: Webhook URL not found."
  echo "Please save your Slack or Discord webhook URL to $WEBHOOK_FILE"
  exit 1
fi

WEBHOOK_URL=$(cat "$WEBHOOK_FILE")

# Simple check to see if it's Discord or Slack
if [[ "$WEBHOOK_URL" == *"discord.com"* ]]; then
  PAYLOAD="{\"content\": \"$MESSAGE\"}"
else
  # Default to Slack format
  PAYLOAD="{\"text\": \"$MESSAGE\"}"
fi

curl -s -X POST -H 'Content-type: application/json' --data "$PAYLOAD" "$WEBHOOK_URL"
echo ""
echo "Notification sent successfully."
