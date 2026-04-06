#!/bin/bash

# Function to check for power adapter
check_power() {
  if pmset -g batt | grep -q "Battery Power"; then
    echo "⚠️ Warning: Laptop is on battery power. Long-running tasks may drain the battery."
  else
    echo "✅ Laptop is connected to a power adapter."
  fi
}

# Function to check if sleep is currently prevented
check_sleep_prevention() {
  if pmset -g assertions | grep -E "PreventSystemSleep|PreventUserIdleSystemSleep" | grep -q "1"; then
    echo "✅ System sleep is currently being prevented."
  else
    echo "❌ System sleep is ENABLED. The laptop might sleep if left idle."
    echo "💡 Tip: Use 'caffeinate' or a similar tool to keep the laptop awake."
  fi
}

case "$1" in
  "check")
    check_power
    check_sleep_prevention
    ;;
  "start")
    echo "Starting 'caffeinate' to keep the laptop awake during the task..."
    # Start caffeinate in the background (prevents idle and system sleep)
    caffeinate -is & 
    CAFFEINATE_PID=$!
    echo $CAFFEINATE_PID > ~/.gemini/caffeinate.pid
    echo "✅ Caffeinate started with PID $CAFFEINATE_PID."
    ;;
  "stop")
    if [ -f ~/.gemini/caffeinate.pid ]; then
      CAFFEINATE_PID=$(cat ~/.gemini/caffeinate.pid)
      kill $CAFFEINATE_PID 2>/dev/null
      rm ~/.gemini/caffeinate.pid
      echo "✅ Caffeinate stopped. The system can now return to normal sleep settings."
    else
      echo "No active caffeinate process found."
    fi
    ;;
  *)
    echo "Usage: $0 {check|start|stop}"
    exit 1
    ;;
esac
