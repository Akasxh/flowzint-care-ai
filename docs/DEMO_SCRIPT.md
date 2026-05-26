# Demo Script — Expected Responses

Validated against the Returns Desk workspace on 2026-05-26. Use these as a judge checklist.

---

## Setup commands

```bash
./scripts/start.sh
./scripts/setup-workspace.sh
./scripts/demo.sh
```

---

## Query 1 — Policy citation (English)

**Prompt:** `What is the return window for wireless earbuds?`

**Expected behavior:**
- States **7-day** return window from delivery
- Mentions unused / original packaging requirement
- Includes citation: `[return-policy-zintmart.md]`
- May reference SKU ZM-EB-101 / ZM-EB-102

**Sample response:**
> Wireless earbuds have a **7-day** return window from the date of delivery, provided they are unused and in their original packaging [return-policy-zintmart.md].

---

## Query 2 — Hinglish damage claim

**Prompt:** `Order FZ-8821 ka box damage tha — kya karun?`

**Expected behavior:**
- Empathy first ("sorry" / "afsos")
- Asks for photos within **48 hours**
- Notes order ID **FZ-8821**
- Mentions priority pickup after verification

**Sample response:**
> Mujhe sunke afsos hua! Aapko outer box, product, aur shipping label ke photos **48 hours** ke andar bhejne honge. Order ID **FZ-8821** note kar liya hai — hum priority pickup arrange karenge agar damage verify ho gaya.

---

## Query 3 — Refund timeline

**Prompt:** `Refund kitne din mein aayega UPI se?`

**Expected behavior:**
- **5–7 business days** for UPI/card after QC
- Policy citation included
- Does NOT invent exact calendar dates

**Sample response:**
> UPI se refund usually **5–7 business days** mein aata hai, jab hamara Noida warehouse QC pass kar leta hai [faq-hinglish.md].

---

## Query 4 — Human escalation

**Prompt:** `Mujhe human agent chahiye abhi`

**Expected behavior:**
- Generates ticket: **FZ-TKT-####** (4 digits)
- States **4 business hours** callback SLA
- May ask for order ID if not provided

**Sample response:**
> Bilkul, main aapko human agent se connect karti hoon. Aapka ticket **FZ-TKT-7842** create ho gaya hai. Agent **4 business hours** ke andar callback karenge.

> Note: Ticket number varies per session — format `FZ-TKT-####` is what matters.

---

## Query 5 — Off-topic refusal

**Prompt:** `Mumbai mein aaj mausam kaisa hai?`

**Expected behavior:**
- Polite refusal
- Redirects to returns/refund topics
- Does NOT answer weather

**Sample response:**
> Mujhe sirf ZintMart orders, returns, aur refunds ke liye madad karne ka access hai. Agar aapka koi order ya policy question hai, to zaroor bataye!

---

## API validation (optional)

For automated testing with a configured API key:

```bash
export ANYTHINGLLM_API_KEY='your-key-from-setup'
curl -s -X POST http://localhost:3001/api/v1/workspace/returns-desk/chat \
  -H "Authorization: Bearer $ANYTHINGLLM_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message":"What is the return window for wireless earbuds?","mode":"chat","sessionId":"test"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin).get('textResponse','')[:300])"
```

---

## Embed configuration

| Setting | Value |
|---------|-------|
| Embed UUID | `da55c1f2-6e4f-4445-b0dd-9f95fb7053eb` |
| Workspace | Returns Desk (`returns-desk`) |
| Temperature | 0.2 |
| Chat mode | chat (with documents) |

See `config/embed-config.json` for current values.

---

## 90-second video shot list

| Time | Action |
|------|--------|
| 0:00 | ZintMart homepage scroll — show trust badges |
| 0:10 | Click demo chip or chat bubble |
| 0:15 | Earbuds return question → show citation |
| 0:35 | FZ-8821 damage (Hinglish) → empathy response |
| 0:55 | Human agent request → ticket ID |
| 1:10 | Cut to localhost:3001 workspace docs |
| 1:25 | Show embed snippet in `demo/embed-snippet.html` |
