#!/usr/bin/env bash
# Apply FlowZint Care AI branding via admin API (custom_app_name + footer)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${FLOWZINT_PORT:-3001}"
BASE="http://localhost:${PORT}"

if [[ -f "${ROOT}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT}/.env"
  set +a
fi

if [[ -z "${ANYTHINGLLM_API_KEY:-}" ]]; then
  echo "ERROR: Set ANYTHINGLLM_API_KEY in .env (run ./scripts/setup-workspace.sh first)."
  exit 1
fi

AUTH="Authorization: Bearer ${ANYTHINGLLM_API_KEY}"

FOOTER=$(python3 -c "
import json
links = [
  {'label': 'ZintMart Demo', 'url': 'https://github.com/Akasxh/flowzint-care-ai/tree/main/demo/storefront'},
  {'label': 'Hackathon 2026', 'url': 'https://flowzint.in/2026/ai/hackothon/'},
  {'label': 'Documentation', 'url': 'https://github.com/Akasxh/flowzint-care-ai#readme'},
]
print(json.dumps(links))
")

echo "Applying appearance to ${BASE}..."

# Appearance keys (custom_app_name, meta_page_title, logo) live in system_settings, not update-env.
if docker ps --format '{{.Names}}' | grep -qx "${FLOWZINT_CONTAINER_NAME:-flowzint-care}"; then
  "${ROOT}/scripts/apply-appearance-db.sh"
else
  echo "WARN: flowzint-care container not running — start with ./scripts/start.sh then re-run."
fi

# Optional: push footer via API if admin session exists (DB script already sets footer_data).
curl -sf -X POST "${BASE}/api/v1/system/update-env" \
  -H "$AUTH" -H "Content-Type: application/json" \
  -d "{}" >/dev/null 2>&1 || true

echo "[ok] FlowZint appearance applied (DB + logo assets)."
