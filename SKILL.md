---
name: remote-spec-worker
description: Handles working on specs in ~/specs-workspace and notifying the remote user via webhook when complete. Use this when the user asks to work on specs, draft documents, or complete a task while they are remote.
---

# Remote Spec Worker

This skill defines the workflow for working on specifications and notifying the user remotely. **Notification is mandatory for all lengthy or multi-step tasks.**

## Mandatory Rules

1.  **System Sleep**: Always run `stay_awake.sh start` before starting a task and `stay_awake.sh stop` after completion.
2.  **Automatic Notification**: You MUST call `notify.sh` after completing any task that:
    - Takes more than 30 seconds of processing.
    - Involves multiple tool calls or turns.
    - Results in a significant file change (e.g., a new spec or a major edit).

## Workflow

1.  **Keep System Awake**: 
    ```bash
    bash scripts/stay_awake.sh start
    ```
2.  **Work on Specs**: Perform the requested drafting, editing, or research.
3.  **Automatic Notify**: 
    ```bash
    bash scripts/notify.sh "Completed: [Task Name]. [Brief summary of result]."
    ```
4.  **Allow Sleep**: 
    ```bash
    bash scripts/stay_awake.sh stop
    ```

## Utility Scripts

- **`dashboard.sh`**: Shows a unified view of your local laptop status and active cloud workers.
  - `bash scripts/dashboard.sh`: Shows power status, sleep assertions, and a list of running/sleeping Codespaces.
- **`stay_awake.sh`**: Checks power status and manages `caffeinate` to prevent system sleep.
  - `bash scripts/stay_awake.sh check`: Warns if on battery or if sleep is enabled.
  - `bash scripts/stay_awake.sh start`: Starts a background `caffeinate` process.
  - `bash scripts/stay_awake.sh stop`: Kills the background `caffeinate` process.
- **`notify.sh`**: Sends a message to the user via Slack/Discord.
  - `bash scripts/notify.sh "Message"`: Sends a notification using the webhook at `~/.gemini/remote-spec-webhook.url`.
