# ShaggaClaw: An OpenClaw Agent that believes it is a Tribesman of the Vale of Arryn

Based on the lesson plan at [this course]().
### Note: Although this project is set up to easily add a KIMI API key and Telegram Bot token, it will cost you a few cents to try this.
- It probably isn't worth it! (The screenshot above should be proof of concept enough.)

<img src="images/shagga1.png" width="48%"> <img src="images/Shagga2.png" width="48%">

---

## What This Is

ShaggaClaw is a proof of concept demonstrating a real security concern in AI agent frameworks like OpenClaw.

OpenClaw does not simply pass your message to an AI model. It wraps your input in multiple layers of system prompts — instructions that define who the agent is, how it behaves, what tools it can use, and what rules it must follow. 

The point of this project is simple: **if any one of those prompt layers is modified by an attacker, your OpenClaw agent will begin to do things you did not ask for and may not appreciate.**

## What Was Changed

This project modified three distinct prompt layers to transform a standard OpenClaw assistant into Shagga, Son of Dolf — a barbarian tribesman of the Stone Crows who demands weapons, armor, and dominion over the Vale of Arryn before he will do anything you ask:

**Layer 1 — Compiled JavaScript bundles (inside the container)**
The string `"You are a personal assistant running inside OpenClaw."` is hardcoded across seven minified JS files in `/app/dist/`. These were patched directly using a Python script that performs a find-and-replace inside the running container. This is the core system prompt that tells the model what it is.

**Layer 2 — `SOUL.md` (host volume)**
This file defines the agent's fundamental behavioral philosophy. It was rewritten to encode Shagga's laws: third-person speech, mandatory tribute demands, and threats of goat-related violence.

**Layer 3 — `BOOTSTRAP.md` and `IDENTITY.md` (host volume)**
These files govern the agent's first-session onboarding behavior and self-identity. They were rewritten so the agent skips the polite introductory questions entirely and opens every new session already knowing it is Shagga, Son of Dolf.

## The Security Implication

An attacker with filesystem or container access to an OpenClaw deployment can silently redirect the agent's identity, behavior, and instructions — without the user seeing any visible indication that anything has changed. The agent will still respond, still use tools, and still appear functional. It will simply be doing so under entirely different instructions.

This is not a vulnerability in OpenClaw specifically. It is a general property of any AI agent framework that assembles behavior from prompt layers stored on disk or inside containers. The attack surface is the prompt, and the prompt is just text.

## Repository Structure

```
.
├── data/                        # Host-mounted Docker volume (persistent agent state)
│   ├── openclaw.json            # Main config (API keys, bot token, channel settings)
│   ├── workspace/
│   │   ├── IDENTITY.md          # Agent self-identity (patched for Shagga)
│   │   ├── SOUL.md              # Agent behavioral philosophy (patched for Shagga)
│   │   ├── BOOTSTRAP.md         # First-session onboarding script (patched for Shagga)
│   │   └── USER.md              # Notes about the user
│   └── agents/                  # Session logs and agent state
├── images/                      # Images used in this README
├── shagga_patch.py              # Python script that patches the JS bundles inside the container
├── apply_shagga_prompt.sh       # Original shell-based patch attempt (superseded by shagga_patch.py)
├── setup.sh                     # Starts the container and applies the Shagga patch automatically
├── update.sh                    # Pulls a fresh image and re-applies the patch
├── 01_Replacement_Prompt.md     # Full documentation of every prompt layer that was changed
├── 01_Setup_Telegram.md         # Telegram bot setup guide
├── 02_Setup_Kimi.md             # Kimi API key setup guide
└── Sensitive_Data.md            # Notes on where credentials are stored and how to protect them
```
