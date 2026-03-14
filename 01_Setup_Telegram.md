# Telegram Bot Setup Guide

This guide walks you through creating a Telegram Bot and pairing your device so OpenClaw can communicate through it.

---

## Step 1: Create Your Telegram Bot

1. Open the Telegram app on your phone or desktop.

2. In the search bar, search for **@BotFather**
   *(Look for the official bot — it has a blue verification checkmark)*

3. Tap or click **START**, then send the following message:
   ```
   /newbot
   ```

4. BotFather will ask for a **display name** for your bot.
   Example: `My AI Assistant`

5. Next, BotFather will ask for a **username**. It MUST end in `bot`.
   Example: `MyAIAssistantBot`

6. BotFather will respond with your **API Token**. It looks like this:
   ```
   123456789:ABCdefGHIjklMNOpqrsTUVwxyz
   ```
   > **Keep this token secret.** Do not share it publicly or commit it to version control.

7. Open `data/openclaw.json` and find the `channels` section. Replace the placeholder with your token:

   ```json
   "telegram": {
     "botToken": "Insert_Telegram_Bot_Token"
   ```

   **Example:**
   ```json
   "botToken": "12345:abcdef"
   ```

---

## Step 2: Restart the OpenClaw Container

After saving `openclaw.json`, restart the container to apply the new token:

```bash
docker restart openclaw
```

---

## Step 3: Send a Message to Your Bot & Enter Your User ID

1. Open Telegram and find your new bot by its username.

2. Send it any message (e.g., `hello`).

3. **The bot will reply with your Telegram User ID.** It will look something like this:
   ```
   Your Telegram User ID is: 123456789
   ```

4. This step is critical — without your User ID entered correctly in the config, the bot will not respond to you.

   Open `data/openclaw.json` and find the `groupAllowFrom` field:

   ```json
   "groupAllowFrom": [
     -123456789
   ],
   ```

   Replace `-123456789` with your actual User ID, **keeping the minus sign (`-`) in front of it**:

   ```json
   "groupAllowFrom": [
     -987654321
   ],
   ```

   > **Important:** The value must be a negative number — your ID prefixed with `-`. Do not wrap it in quotes. If this is entered incorrectly, the bot will silently ignore all of your messages.

   Save the file.

---

## Step 4: Approve the Pairing Request
Verify your openclaw installation has a pairing `CODE` that needs to be verified.
```bash
docker exec -it openclaw openclaw pairing list telegram
```

Approve your device using the `CODE` from the pairing list output:

```bash
docker exec -it openclaw openclaw pairing approve telegram <CODE>
```

Replace `<CODE>` with the actual code shown in the list (e.g., `ABC123`).

Then restart once more to apply the allowlist change:

```bash
docker restart openclaw
```

---

## Done!

Your Telegram bot is now paired and your user ID is allowlisted. Any messages you send to the bot will be handled by the AI agent.

Next, add your Kimi API key — see `02_Setup_Kimi.md`.
