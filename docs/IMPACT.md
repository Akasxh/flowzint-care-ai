# FlowZint Care AI — Real-World Impact

FlowZint Care AI targets a specific gap in Indian ecommerce support: returns and refunds, where policy complexity and language mix create high ticket volume and low customer trust.

---

## Who this is for

| Segment | Pain today | What FlowZint Care AI changes |
|---------|------------|-------------------------------|
| **D2C electronics** (earbuds, chargers, smart home) | Warranty vs return window confusion; damage claims need photos | Cited answers from SKU-level catalog + return policy |
| **Fashion & lifestyle** | Size/exchange questions; COD return anxiety | Hinglish FAQ + clear COD reverse-pickup steps |
| **Marketplace sellers on own site** | Support team repeats same 20 questions daily | 24/7 deflection with document grounding |
| **Ops leads** | No audit trail on what was promised | Citations link back to policy excerpts |

---

## Use cases (with demo mapping)

### 1. Return window lookup

**Customer:** *Wireless earbuds kitne din mein return ho sakte hain?*

**Outcome:** Answer cites `return-policy-zintmart.md` with the 7-day electronics window. No hallucinated dates.

**Demo query:** *What is the return window for wireless earbuds?*

### 2. Damaged delivery (Hinglish)

**Customer:** *Order FZ-8821 ka box damage tha, photo bhej di*

**Outcome:** Collects order ID, explains photo requirement, pickup vs self-ship by pincode — from escalation playbook.

**Demo query:** *Order FZ-8821 ka box damage tha, photo bhej di*

### 3. Refund timeline (COD + prepaid)

**Customer:** *Refund kitne din mein aayega? UPI se pay kiya tha*

**Outcome:** Differentiates prepaid UPI (3–5 business days) vs COD bank transfer (7–10 days) per policy.

**Demo query:** *Refund kitne din mein aayega?*

### 4. Human handoff

**Customer:** *Mujhe human agent chahiye abhi*

**Outcome:** Generates `FZ-TKT-####`, states SLA (e.g. 4-hour callback window), stops guessing on edge cases.

**Demo query:** *Mujhe human agent chahiye abhi*

### 5. Off-topic refusal

**Customer:** *What's the weather in Mumbai?*

**Outcome:** Politely declines; redirects to returns/support scope. Shows guardrails for production deploy.

**Demo query:** *What's the weather in Mumbai?*

---

## Business metrics (expected)

These are directional targets for a mid-size Indian D2C brand (~500 returns tickets/month):

| Metric | Baseline (manual chat) | With FlowZint Care AI |
|--------|------------------------|-------------------------|
| First response time | 2–8 hours (business hours) | Under 30 seconds |
| Policy-accurate answers | Variable (agent training) | Grounded in uploaded docs |
| Ticket deflection | — | 40–60% on FAQ-tier queries (policy lookup, status format, COD process) |
| Escalation quality | Missing order IDs | Structured handoff with ticket ID |

Numbers depend on catalog size, prompt tuning, and integration with order systems (future: Shopify webhook for order-aware context).

---

## Deployment paths

1. **Self-hosted Docker** (this repo) — data stays on your infrastructure
2. **Embed on storefront** — two-line script; works with static HTML, Shopify theme, or React shell
3. **Admin onboarding** — non-engineers upload PDF/Markdown policies and paste system prompt

---

## India-specific design choices

- **Hinglish in corpus and system prompt** — matches how customers actually write
- **COD return flows** — bank details and reverse pickup called out explicitly
- **Metro vs tier-2 logistics** — policy text covers pickup availability differences
- **Citation-first** — reduces legal/compliance risk vs free-form LLM replies

---

## Roadmap (post-hackathon)

- Shopify order webhook → inject order status into chat context
- Ticket creation via HTTP agent skill (Freshdesk / Zoho Desk)
- Hindi voice input for mobile-first shoppers
- Analytics dashboard: top unanswered questions → corpus gaps
