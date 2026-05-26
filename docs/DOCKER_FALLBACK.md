# Docker Fallback Guide

FlowZint Care AI targets Docker deployment. If Docker is unavailable or the local image build fails, use one of these paths.

## Install Docker (macOS)

```bash
# Install Docker Desktop, open the app once, then:
export OPENAI_API_KEY='sk-...'
./scripts/start.sh
./scripts/validate.sh
```

[Docker Desktop install guide](https://docs.docker.com/desktop/setup/install/mac-install/)

---

## Option A — FlowZint Care AI Docker (primary)

```bash
export OPENAI_API_KEY='sk-...'
./scripts/start.sh
./scripts/apply-appearance-db.sh
./scripts/setup-workspace.sh
```

Admin UI: http://localhost:3001

The start script builds `flowzint-care-ai:local` from source on first run and maps `OPENAI_API_KEY` to the server's `OPEN_AI_KEY`.

---

## Option B — Open WebUI (quick pivot)

```bash
docker run -d -p 3000:8080 \
  -v open-webui:/app/backend/data \
  --name flowzint-openwebui \
  ghcr.io/open-webui/open-webui:main
```

1. Open http://localhost:3000
2. Upload `corpus/*.md` to the knowledge base
3. Paste `corpus/system-prompt-returns-desk.txt` as system prompt
4. Demo via full-page chat (no embed widget)

---

## Option C — Chainlit (no Docker)

```bash
pip install chainlit openai langchain-community
chainlit run support_bot.py
```

Use when Docker cannot be installed. Load corpus Markdown files with simple retrieval. Record terminal/web demo; emphasize custom RAG architecture in README.

---

## After any option works

1. Upload corpus files
2. Apply system prompt
3. Run validation queries from [DEMO_SCRIPT.md](DEMO_SCRIPT.md)
4. Generate embed UUID (Docker path only)
5. Record demo video — see [VIDEO_TODO.md](VIDEO_TODO.md)
