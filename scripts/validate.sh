#!/usr/bin/env bash
# Quick smoke checks (no LLM calls)
set -euo pipefail

PORT="${FLOWZINT_PORT:-3001}"
URL="http://localhost:${PORT}"
FAIL=0

echo "=== FlowZint Care AI validation ==="

if command -v docker >/dev/null 2>&1; then
  if docker ps --format '{{.Names}}' | grep -qx flowzint-care; then
    echo "[ok] Docker container flowzint-care is running"
  else
    echo "[warn] Docker installed but flowzint-care container not running — run ./scripts/start.sh"
    FAIL=1
  fi
else
  echo "[warn] Docker not installed"
  FAIL=1
fi

if [[ -n "${OPENAI_API_KEY:-}" || -n "${OPEN_AI_KEY:-}" ]]; then
  echo "[ok] OpenAI API key present in environment"
else
  echo "[warn] Set OPENAI_API_KEY before start for non-interactive setup"
fi

CORPUS_DIR="$(cd "$(dirname "$0")/.." && pwd)/corpus"
for f in return-policy-zintmart.md faq-hinglish.md product-catalog-snippet.md escalation-playbook.md system-prompt-returns-desk.txt; do
  if [[ -f "$CORPUS_DIR/$f" ]]; then
    echo "[ok] corpus/$f"
  else
    echo "[fail] missing corpus/$f"
    FAIL=1
  fi
done

CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 "$URL" 2>/dev/null) || CODE="000"
CODE="${CODE:-000}"
if [[ "$CODE" =~ ^[23] ]]; then
  echo "[ok] $URL responds HTTP $CODE"
else
  echo "[warn] $URL not reachable (HTTP $CODE) — start Docker first"
  FAIL=1
fi

CONFIG="$(cd "$(dirname "$0")/.." && pwd)/config/embed-config.json"
if [[ -f "$CONFIG" ]]; then
  UUID=$(python3 -c "import json; print(json.load(open('$CONFIG'))['embedUuid'])" 2>/dev/null || echo "")
  if [[ -n "$UUID" && "$UUID" != "YOUR_EMBED_UUID" ]]; then
    echo "[ok] embed UUID configured ($UUID)"
  else
    echo "[warn] embed UUID not set — run ./scripts/setup-workspace.sh"
  fi
else
  echo "[warn] config/embed-config.json missing — run ./scripts/setup-workspace.sh"
fi

if [[ -f "$(cd "$(dirname "$0")/.." && pwd)/demo/storefront/index.html" ]]; then
  echo "[ok] demo/storefront/index.html"
fi

if [[ $FAIL -eq 0 ]]; then
  echo "=== All automated checks passed ==="
else
  echo "=== Some checks failed (see above) ==="
  exit 1
fi
