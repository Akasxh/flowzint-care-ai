#!/usr/bin/env bash
# FlowZint Care AI — one-command demo launcher
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${FLOWZINT_PORT:-3001}"
STOREFRONT="${ROOT}/demo/storefront/index.html"
CONFIG="${ROOT}/config/embed-config.json"

# Load .env if present
if [[ -f "${ROOT}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT}/.env"
  set +a
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           FlowZint Care AI — Hackathon Demo                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check Docker
if command -v docker >/dev/null 2>&1 && docker ps --format '{{.Names}}' | grep -qx flowzint-care; then
  echo "✓ Docker container flowzint-care is running"
else
  echo "⚠ Docker not running — starting..."
  "${ROOT}/scripts/start.sh"
fi

# Check server
if curl -sf "http://localhost:${PORT}/api/ping" >/dev/null 2>&1; then
  echo "✓ FlowZint Care AI responding on http://localhost:${PORT}"
else
  echo "⚠ Server not ready yet — wait 10s and refresh storefront"
fi

# Check embed config
if [[ -f "$CONFIG" ]]; then
  UUID=$(python3 -c "import json; print(json.load(open('$CONFIG'))['embedUuid'])" 2>/dev/null || echo "unknown")
  echo "✓ Embed UUID: ${UUID}"
else
  echo "⚠ No embed config — run: ./scripts/setup-workspace.sh"
fi

echo ""
echo "Opening ZintMart storefront..."
if [[ "$(uname)" == "Darwin" ]]; then
  open "file://${STOREFRONT}"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "file://${STOREFRONT}"
else
  echo "  file://${STOREFRONT}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  90-SECOND DEMO SCRIPT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  1. Scroll ZintMart homepage → click chat bubble (bottom-right)"
echo "  2. Ask:  What is the return window for wireless earbuds?"
echo "          → Expect: 7-day window + [return-policy-zintmart.md] citation"
echo ""
echo "  3. Ask:  Order FZ-8821 ka box damage tha"
echo "          → Expect: empathy + photo request + pickup steps"
echo ""
echo "  4. Ask:  Refund kitne din mein aayega UPI se?"
echo "          → Expect: 5–7 business days + policy citation"
echo ""
echo "  5. Ask:  Mujhe human agent chahiye"
echo "          → Expect: FZ-TKT-#### ticket + 4hr SLA"
echo ""
echo "  6. Show: Admin UI at http://localhost:${PORT} → workspace docs"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Admin UI:    http://localhost:${PORT}"
echo "Storefront:  file://${STOREFRONT}"
echo "Full guide:  docs/DEMO_GUIDE.md"
echo ""
