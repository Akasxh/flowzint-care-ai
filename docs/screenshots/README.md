# FlowZint Care AI — screenshot gallery

Screenshots for README, demo video B-roll, and hackathon submission.

| File | Description |
|------|-------------|
| `01-zintmart-storefront-full.png` | Full ZintMart storefront with chat FAB |
| `02-chat-widget-open.png` | Embed widget open on storefront |
| `03-cited-answer-earbuds.png` | Cited policy answer for earbuds return |
| `04-admin-workspace.png` | Admin workspace with corpus documents |
| `05-mobile-demo-chips.png` | Mobile view with demo question chips |
| `after-rebrand-sidebar.png` | Admin sidebar with FlowZint Care AI branding |

Regenerate (requires Playwright + Docker on :3001):

```bash
node scripts/capture-screenshots.mjs
```

Re-apply runtime branding after container recreate:

```bash
./scripts/apply-appearance-db.sh
```

Hard-refresh the browser: **Cmd+Shift+R** (macOS).
