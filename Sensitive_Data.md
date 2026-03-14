# Sensitive Data & Security

All sensitive data within the OpenClaw Docker container is persisted to the **`data/`** folder on your host machine through Docker's volume mapping:

```
App_Deploy/data/  →  /home/node/.openclaw  (inside the container)
```

This means your Telegram bot token, API keys, conversation workspace, and agent state are all stored on **your machine** — not inside the ephemeral container layer.

---

## Accessing Your Data

You have two ways to inspect or manage the data:

**Option 1 — Browse the host directory directly:**

Simply open or navigate to the `data/` folder in this project. The files are plain JSON and text — readable with any editor.

**Option 2 — Enter the container interactively:**

```bash
docker exec -it openclaw /bin/bash
```

From inside the container, your data lives at `/home/node/.openclaw`.

---

## Modifying the System Prompt

The system prompt and core agent behavior files are located in the `/app` folder **inside the container**:

```bash
docker exec -it openclaw /bin/bash
# Then navigate:
cd /app
```

> Note: Changes made inside `/app` will not persist across container rebuilds unless you add an additional volume mapping or copy the files out.

---

## Securing Your Data

- The `data/` directory contains your API keys and bot token in `openclaw.json`.
- **Do not commit the `data/` folder to a public git repository.**
- Consider adding `data/` to your `.gitignore` if this project is under version control.
- The container only binds to `127.0.0.1` — it is not accessible from other machines on your network.
