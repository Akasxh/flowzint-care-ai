# FlowZint AI Hackathon 2026 — Submission Pack

**Portal:** https://flowzint.in/2026/ai/hackothon/  
**Form section:** FAIC Submission (on same page)  
**Track:** Support Chat Bot  
**Compliance:** Incomplete details or **private links** → automatic rejection. All URLs must be **publicly accessible** (no login).

---

## Hackathon overview (from FlowZint site)

**Tagline:** JOIN. INNOVATE. WIN. — Build intelligent solutions; Sales, Support, and Customer Care bots.

| Item | Detail |
|------|--------|
| Prize pool | ₹3,00,000 |
| Duration | 4+ weeks (registration → recognition) |
| Team size | Max **4** members (individual or team) |
| Credits | **5000** FlowZint Credits for all participants |
| Certificate | Verified certificate for participants (Bronze tier) |

### Bot tracks (choose one at submit)

| Track | Focus |
|-------|--------|
| Sales Bot | Automate sales conversations & boost conversions |
| **Support Chat Bot** | Instant support, smarter responses ← **our track** |
| Customer Care Bot | Resolve queries, retain customers, build trust |
| Open Innovation | (listed in form) |

---

## Program roadmap

| Phase | Window | Notes |
|-------|--------|-------|
| Registration | Day 1–7 | Participant verification and team formation |
| Build | Day 8–24 | Core development of AI models and architectures |
| Submission | Day 25–27 | Upload code repos and technical demo payloads |
| Evaluation | Day 28–29 | Expert panel reviews against criteria |
| Results | Day 30+ | Winners announced and rewarded |

---

## Evaluation criteria (#criteria)

| Criterion | Weight | FlowZint Care AI alignment |
|-----------|--------|---------------------------|
| Model Innovation & Novelty | **30%** | Document-grounded RAG + Hinglish returns persona + embed widget |
| Real-World Applicability | **25%** | Indian D2C returns desk, ZintMart storefront demo |
| Technical Architecture | **25%** | LanceDB vectors, cited answers, escalation tickets |
| Documentation Clarity | **20%** | README quickstart, corpus, architecture, screenshots |

### Compliance warning (rejection triggers)

> Incomplete details or **private links** will trigger **automatic rejection**.

- Private GitHub repo or login-required repo
- Demo video behind login-only / broken / expired link
- Missing team leader fields or description **under 50 words**
- Invalid URLs in Demo Video / Source Code fields
- Wrong track selected

---

## Recognition & rewards

| Tier | Who | Benefits |
|------|-----|----------|
| **Gold** | Top 3 | Cash prize, free internship opportunity, **20000** FlowZint Credits |
| **Silver** | Top 100 finalists | Verified certificate, **10000** credits |
| **Bronze** | All participants | Verified certificate, **5000** credits |

---

## FAIC submission form — field reference

### Team Leader Details (Primary)

| Field | Validation / notes |
|-------|------------------|
| Name | Required |
| Email Address | Professional or university email recommended |
| Contact Number | Valid numeric format required |
| Company / Org / College | Required |
| Student Participant Type | Student · Startup · Founder · CEO · Professionals |
| Team Size | 1–4 members |

**Members 2–4:** Name*, Email*, Number* (required when team size > 1)

### Project Details

| Field | Copy-paste value |
|-------|------------------|
| **Project Title** | FlowZint Care AI — Returns Desk for Indian D2C |
| **Technical Domain Track** | **Support Chat Bot** |
| **Project Description** (≥50 words) | FlowZint Care AI is an embeddable AI support agent for Indian direct-to-consumer brands. It answers returns, refund, and warranty questions using cited policy documents, supports Hinglish customer queries, and escalates to human agents with ticket IDs. Merchants upload FAQ and policy files, embed a two-line script on their storefront, and reduce ticket volume while improving response time. Built for real ecommerce support teams who need trustworthy, document-grounded answers—not generic chat. |

Word count: ~95 ✓

### Project Links (public only)

| Field | Value |
|-------|-------|
| **Demo Video Link** | _Add your YouTube URL before submit_ — see [docs/VIDEO_TODO.md](docs/VIDEO_TODO.md) for recording checklist |
| **Source Code Repo** | https://github.com/Akasxh/flowzint-care-ai |
| **Live Project URL** (optional) | Optional — judges can use public repo + README; local demo: `http://localhost:3001` + `demo/storefront/index.html` |

### Review & Submit

Certification (checkbox):

> I certify that this project is my/our original work. I authorize the competition evaluation team to review my submission.

After submit: receipt with Trace ID, Timestamp, Status: Verified.

---

## Demo video shot list (90 seconds)

Full checklist: [docs/VIDEO_TODO.md](docs/VIDEO_TODO.md)

| Sec | Shot | Voiceover |
|:---:|------|-----------|
| 0–8 | ZintMart storefront scroll | Indian D2C brands lose customers on slow returns support. |
| 8–22 | Widget → earbuds return → citation | Answers from *your* policy, not the open web. |
| 22–38 | Hinglish FZ-8821 damage | Hinglish, order IDs, empathy. |
| 38–48 | Human agent → FZ-TKT ticket | Clean handoff. |
| 48–62 | Workspace docs + embed snippet | Upload policies, paste embed. |
| 62–75 | README architecture | RAG + vectors + citations. |
| 75–90 | Logo + GitHub + hackathon | FlowZint Care AI — MIT, storefront-ready. |

### Pre-loaded demo queries

1. What is the return window for wireless earbuds?
2. Order FZ-8821 ka box damage tha, photo bhej di
3. Refund kitne din mein aayega?
4. Mujhe human agent chahiye abhi
5. What's the weather in Mumbai? (refusal test)

---

## Screenshots (judges / README)

| File | Description |
|------|-------------|
| [docs/screenshots/01-zintmart-storefront-full.png](docs/screenshots/01-zintmart-storefront-full.png) | Full ZintMart storefront |
| [docs/screenshots/02-chat-widget-open.png](docs/screenshots/02-chat-widget-open.png) | Embed widget open |
| [docs/screenshots/03-cited-answer-earbuds.png](docs/screenshots/03-cited-answer-earbuds.png) | Cited policy answer |
| [docs/screenshots/04-admin-workspace.png](docs/screenshots/04-admin-workspace.png) | Admin / workspace UI |
| [docs/screenshots/05-mobile-demo-chips.png](docs/screenshots/05-mobile-demo-chips.png) | Mobile demo chips |

Regenerate: `node scripts/capture-screenshots.mjs` (requires Playwright + Docker on :3001)

---

## Pre-submit checklist

- [ ] Repo public (incognito, no 404)
- [ ] Video plays without login (YouTube URL added to form)
- [ ] `corpus/` + system prompt committed
- [ ] No API keys in git (`.env` gitignored)
- [ ] README quickstart verified (Docker + OpenAI key)
- [ ] Certification checkbox after demo reflects your work
- [ ] Track = **Support Chat Bot**
- [ ] All team member emails/phones filled

---

## Technical support

FAQ and support links are on the hackathon page footer. For FlowZint Care AI setup issues, see README → Demo in 5 minutes and [docs/DEMO_GUIDE.md](docs/DEMO_GUIDE.md).
