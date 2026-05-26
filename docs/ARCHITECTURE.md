# FlowZint Care AI — Architecture

## Overview

FlowZint Care AI is a self-hosted RAG stack built for **Indian D2C returns workflows**. Customer chat runs through an embeddable widget; knowledge lives in markdown corpora in this repository and in workspace uploads.

---

## Components

| Layer | Responsibility |
|-------|----------------|
| **Embed widget** | `<script>` on merchant storefront; calls Embed API |
| **Embed API** | Session management, workspace routing, streaming responses |
| **RAG engine** | Chunk retrieval + prompt assembly + citation metadata |
| **Vector store** | LanceDB — embedded document chunks per workspace |
| **LLM provider** | OpenAI (MVP); swappable via admin settings |
| **Admin UI** | Workspace setup, document upload, appearance, embed UUID |

---

## Data flow

```
Storefront widget
    → POST /api/embed/{uuid}/chat
        → Load workspace "Returns Desk"
        → Embed user query
        → LanceDB top-K (default 4 chunks)
        → System prompt (Priya persona) + retrieved chunks
        → LLM completion (temperature 0.2)
        → Response + source citations
    → Widget renders markdown + citation links
```

---

## Ingestion pipeline

1. Operator uploads `.md` / `.pdf` via admin UI (or copies from `corpus/`)
2. Collector service extracts text and splits into chunks
3. Embedding model vectorizes each chunk
4. Vectors stored in LanceDB scoped to workspace slug
5. Status indicator turns green when indexing completes

Committed corpus files:

| File | Contents |
|------|----------|
| `return-policy-zintmart.md` | Windows, exclusions, refund SLAs |
| `faq-hinglish.md` | 20+ Q&A in English/Hinglish |
| `product-catalog-snippet.md` | SKU-level warranty hints |
| `escalation-playbook.md` | Ticket format, SLA, handoff rules |
| `system-prompt-returns-desk.txt` | Priya persona + citation rules |

---

## Generation and safety

The system prompt enforces:

- Citation of policy docs for factual claims
- Order ID collection on damage/wrong-item flows
- Escalation ticket pattern `FZ-TKT-####`
- Refusal of off-topic and legal advice
- No fabricated refund calendar dates

---

## Embed integration

Merchants add one script tag (see `demo/embed-snippet.html`):

| Attribute | Purpose |
|-----------|---------|
| `data-embed-id` | UUID from admin after workspace creation |
| `data-base-api-url` | FlowZint Care AI server (e.g. `https://care.example.com/api/embed`) |
| `data-assistant-name` | Widget header label |
| `data-brand-image-url` | Logo in chat header |
| `data-button-color` | FAB color |

**CORS note:** A static demo on GitHub Pages cannot call `localhost`. For public demos, tunnel the API (ngrok, Cloudflare Tunnel) or deploy FlowZint Care AI to HTTPS.

---

## Deployment topologies

### Docker (recommended)

Single container on port 3001 with a named volume for storage and database.

```bash
./scripts/start.sh              # builds flowzint-care-ai:local if needed
./scripts/apply-appearance-db.sh
./scripts/setup-workspace.sh
```

### Development (no Docker)

```bash
yarn setup && yarn dev:all
```

Frontend :3000 · server :3001 · collector worker.

### Fallback stack

See [DOCKER_FALLBACK.md](DOCKER_FALLBACK.md) for Open WebUI or Chainlit alternatives using the same corpus.

---

## Security

- No customer PII in committed corpus
- API keys only in `.env` (gitignored)
- Self-hosted — documents stay on your infrastructure
- Admin auth required for workspace and document management

---

## Extension points

| Integration | Purpose |
|-------------|---------|
| Shopify webhook | Order-aware context injection |
| HTTP agent skill | Create tickets in Freshdesk / Zoho |
| Custom embed styling | Appearance JSON + CSS overrides |
| Additional LLM providers | Admin → LLM preference |
