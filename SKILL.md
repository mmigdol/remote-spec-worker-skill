---
name: remote-spec-worker
description: Handles working on specs in ~/specs-workspace and notifying the remote user via webhook when complete. Use this when the user asks to work on specs, draft documents, or complete a task while they are remote.
---

# Remote Spec Worker

This skill defines the workflow for working on specifications and notifying the user remotely when tasks are completed. It also includes tools to keep the system awake while working.

## Workflow

1.  **Keep System Awake**: Before starting a long-running task, ensure the system won't sleep.
    ```bash
    bash scripts/stay_awake.sh start
    ```
2.  **Work on Specs**: Write, edit, or review the spec files located in `~/specs-workspace`. Ensure the work is comprehensive and meets the user's requirements.
3.  **Notify User**: When the task is completed or you need the user's feedback, run the notification script.
    ```bash
    bash scripts/notify.sh "Your message here. E.g., The architecture spec is ready for review."
    ```
4.  **Allow Sleep**: Once finished, allow the system to sleep normally.
    ```bash
    bash scripts/stay_awake.sh stop
    ```

## Utility Scripts

- **`stay_awake.sh`**: Checks power status and manages `caffeinate` to prevent system sleep.
  - `bash scripts/stay_awake.sh check`: Warns if on battery or if sleep is enabled.
  - `bash scripts/stay_awake.sh start`: Starts a background `caffeinate` process.
  - `bash scripts/stay_awake.sh stop`: Kills the background `caffeinate` process.
- **`notify.sh`**: Sends a message to the user via Slack/Discord.
  - `bash scripts/notify.sh "Message"`: Sends a notification using the webhook at `~/.gemini/remote-spec-webhook.url`.
