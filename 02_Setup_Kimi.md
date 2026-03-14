# Kimi Moonshot API Key Setup

## Sign Up

Go to the Moonshot AI developer platform and create an account:

**https://platform.moonshot.ai/console/**

> You can get started for as little as **$10**. You'll get plenty of use out of it, and it's absolutely worth the price of admission to learn. The Kimi K2.5 model is powerful and cost-effective for personal AI agent use.

---

## Generate Your API Key

1. Log in to the Moonshot console.
2. Navigate to **API Keys** in the left sidebar.
3. Click **Create API Key**.
4. Copy the key — you will only see it once.

---

## Add the API Key to openclaw.json

Open `data/openclaw.json` and find the `env` section near the top of the file:

```json
"env": {
  "MOONSHOT_API_KEY": "INSERT_YOUR_API_KEY_HERE"
}
```

Replace `"INSERT_YOUR_API_KEY_HERE"` with your actual API key.

**Example:**

```json
"env": {
  "MOONSHOT_API_KEY": "111222AAABBB"
}
```

Save the file, then restart the container to apply the change:

```bash
docker restart openclaw
```

---

## You're All Set

Send a message to your Telegram bot. OpenClaw will respond using the Kimi K2.5 model.
