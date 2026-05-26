# Demo Guide — For Judges & Non-Technical Reviewers

This guide gets you from zero to a live AI Returns Desk demo in about 5 minutes. No coding required.

---

## What you'll see

1. **ZintMart** — a fake Indian D2C e-commerce storefront
2. **FlowZint Care AI** — an AI chat widget (Priya) that answers returns questions from official policy documents
3. Answers include **citations** (e.g. `[return-policy-zintmart.md]`) and handle **Hinglish**

---

## Prerequisites

| Requirement | How to check |
|-------------|--------------|
| Docker Desktop | Open Docker Desktop; whale icon should be steady (not animating) |
| OpenAI API key | You need one from [platform.openai.com](https://platform.openai.com/api-keys) |

---

## Step 1 — Clone & configure (2 min)

```bash
git clone https://github.com/Akasxh/flowzint-care-ai.git
cd flowzint-care-ai
cp .env.example .env
```

Edit `.env` and paste your OpenAI key:

```
OPENAI_API_KEY=sk-your-key-here
```

> **Important:** Never commit `.env` — it's gitignored.

---

## Step 2 — Start the server (1 min)

```bash
chmod +x scripts/*.sh
./scripts/start.sh
```

Wait until you see `Open http://localhost:3001`. Open that URL in your browser — you should see the FlowZint Care AI admin UI.

---

## Step 3 — Auto-configure workspace (1 min)

```bash
./scripts/setup-workspace.sh
```

This script automatically:
- Creates the **Returns Desk** workspace
- Uploads all policy documents from `corpus/`
- Applies Priya's system prompt
- Creates the chat embed and saves the UUID

If it prints an `ANYTHINGLLM_API_KEY`, add it to your local `.env` for future runs.

---

## Step 4 — Launch the demo (30 sec)

```bash
./scripts/demo.sh
```

This opens the ZintMart storefront and prints the demo script in your terminal.

---

## How to demo (90 seconds)

1. On the ZintMart page, scroll to **"Try these demo questions"**
2. Click a chip (e.g. **Earbuds return window?**) — it opens chat
3. Or click the **chat bubble** in the bottom-right corner

### Suggested questions

| Ask this | What to highlight |
|----------|-------------------|
| *What is the return window for wireless earbuds?* | 7-day policy + document citation |
| *Order FZ-8821 ka box damage tha* | Hinglish empathy + pickup steps |
| *Refund kitne din mein aayega UPI se?* | 5–7 business days, grounded answer |
| *Mujhe human agent chahiye* | Ticket ID `FZ-TKT-####` + SLA |
| *Mumbai mein mausam kaisa hai?* | Polite refusal — stays on-topic |

4. Switch to **http://localhost:3001** → show the workspace documents and system prompt

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Chat bubble missing | Run `./scripts/start.sh` then `./scripts/setup-workspace.sh` |
| Yellow "offline" banner on storefront | Docker not running — start Docker Desktop, run `./scripts/start.sh` |
| Generic/wrong answers | Re-run `./scripts/setup-workspace.sh` to re-upload corpus |
| `./scripts/validate.sh` fails | Check Docker container: `docker ps \| grep flowzint-care` |

---

## Verify everything works

```bash
./scripts/validate.sh
```

All checks should show `[ok]`.

---

## Architecture (30-second explanation)

> "We upload ZintMart's return policy as documents. When a customer asks a question, the AI searches those documents, finds relevant passages, and generates an answer that cites the source. It handles Hinglish and escalates to human agents with ticket IDs — all from a two-line HTML embed."

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full diagram.

---

## Links

- **GitHub:** https://github.com/Akasxh/flowzint-care-ai
- **Hackathon:** https://flowzint.in/2026/ai/hackothon/
- **Detailed script:** [DEMO_SCRIPT.md](DEMO_SCRIPT.md)
