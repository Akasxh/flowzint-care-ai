# ZintMart Care Escalation Playbook

For FlowZint Care AI and human agents.

---

## When to escalate to human

Escalate immediately when customer uses any of:

- "speak to human", "human agent", "real person"
- "manager", "supervisor", "complaint"
- "consumer forum", "legal action", "social media blast"
- Repeated "not helpful" after 2 bot turns on same issue
- Order value **> ₹25,000** with damage/wrong item claim
- Suspected fraud (chargeback threat, multiple accounts)

---

## Bot escalation response template

1. Acknowledge frustration warmly (Hinglish OK)
2. Collect if missing: **Order ID** (`FZ-####`), email, phone
3. Issue ticket: **`FZ-TKT-{4-digit-random}`** (e.g. FZ-TKT-7842)
4. Set expectation: **Human agent callback within 4 business hours** (Mon–Sat, 10am–7pm IST)
5. Do **not** promise exact refund date beyond policy ranges

---

## SLA tiers

| Priority | Trigger | First response | Resolution target |
|----------|---------|----------------|-------------------|
| P1 | Damaged high-value electronics, duplicate charge | 2 hours | 24 hours |
| P2 | Wrong item, return rejected dispute | 4 hours | 48 hours |
| P3 | General policy clarification, wallet delay | 4 hours | 72 hours |

---

## Ticket format

```
Ticket ID: FZ-TKT-7842
Order ID: FZ-8821
Category: Damaged in transit
Customer: [name]
Channel: FlowZint Care embed
Summary: Box crushed; earbuds case cracked — photos attached
Next action: Schedule priority pickup
Assigned: Returns Desk Team
```

---

## Handoff data to capture

- Order ID, SKU, delivery date
- Photo links or attachment IDs
- Payment method (COD / UPI / card)
- Preferred language (English / Hindi / Hinglish)
- Prior bot transcript summary (auto-attached in production)

---

## Refusal boundaries (bot and agent)

- No legal advice
- No competitor price matching
- No invented refund dates
- No off-topic (recipes, politics, etc.)

---

## After-hours

- Tickets queued; auto-reply: "Agent will contact you next business day by 1pm IST"
- P1 keywords still alert on-call lead via Slack/email (production)
