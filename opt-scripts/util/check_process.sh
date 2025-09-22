#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Script: check_process.sh
# Description: Monitor a process by PID and send a WeChat Work webhook notification when it exits.
# Usage: ./check_process.sh <PID> [CHECK_INTERVAL_SECONDS]
# ----------------------------------------------------------------------------

# Exit on any error
set -e

# Arguments and defaults
PID=${1:?Usage: $0 <PID> [CHECK_INTERVAL_SECONDS]}
CHECK_INTERVAL=${2:-60}
WEBHOOK_URL="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=<YOUR_WEBHOOK_KEY>"

# Function to send notification
send_notification() {
  curl -s "$WEBHOOK_URL" \
    -H 'Content-Type: application/json' \
    -d '{
      "msgtype": "text",
      "text": {"content": "Process '$PID' (Yelp) has completed."}
    }'
}

# Monitor loop
echo "Monitoring process $PID. Checking every $CHECK_INTERVAL seconds..."
while kill -0 "$PID" 2>/dev/null; do
  sleep "$CHECK_INTERVAL"
done

echo "Process $PID has exited. Sending notification..."
send_notification

echo "Notification sent."
