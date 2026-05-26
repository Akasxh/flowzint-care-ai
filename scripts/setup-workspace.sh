#!/usr/bin/env bash
# FlowZint Care AI — automate Returns Desk workspace + embed via admin API
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${FLOWZINT_PORT:-3001}"
BASE="http://localhost:${PORT}"
WORKSPACE_NAME="${FLOWZINT_WORKSPACE_NAME:-Returns Desk}"
WORKSPACE_SLUG="${FLOWZINT_WORKSPACE_SLUG:-returns-desk}"
CONFIG_FILE="${ROOT}/config/embed-config.json"

# Load .env if present (never commit .env)
if [[ -f "${ROOT}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT}/.env"
  set +a
fi

if [[ -z "${OPEN_AI_KEY:-}" && -n "${OPENAI_API_KEY:-}" ]]; then
  export OPEN_AI_KEY="$OPENAI_API_KEY"
fi

echo "=== FlowZint Care AI — workspace setup ==="
echo "Target: ${BASE}"
echo ""

# Wait for server
for i in $(seq 1 30); do
  if curl -sf "${BASE}/api/ping" >/dev/null 2>&1; then
    break
  fi
  if [[ $i -eq 30 ]]; then
    echo "ERROR: ${BASE} not reachable. Run ./scripts/start.sh first."
    exit 1
  fi
  sleep 2
done
echo "[ok] Server reachable"

# Get or create API key
if [[ -n "${ANYTHINGLLM_API_KEY:-}" ]]; then
  API_KEY="$ANYTHINGLLM_API_KEY"
  echo "[ok] Using ANYTHINGLLM_API_KEY from environment"
else
  echo "Generating API key..."
  RESP=$(curl -sf -X POST "${BASE}/api/system/generate-api-key" \
    -H "Content-Type: application/json" \
    -d '{"name":"flowzint-setup"}')
  API_KEY=$(echo "$RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['apiKey']['secret'])")
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Save this to your local .env (NOT committed to git):"
  echo "  ANYTHINGLLM_API_KEY=${API_KEY}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
fi

AUTH="Authorization: Bearer ${API_KEY}"

# Check if workspace exists
EXISTING=$(curl -sf -H "$AUTH" "${BASE}/api/v1/workspaces" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for w in data.get('workspaces', []):
    if w.get('slug') == '${WORKSPACE_SLUG}':
        print(w['slug'])
        break
" 2>/dev/null || true)

if [[ -z "$EXISTING" ]]; then
  echo "Creating workspace: ${WORKSPACE_NAME}..."
  curl -sf -X POST "${BASE}/api/v1/workspace/new" \
    -H "$AUTH" -H "Content-Type: application/json" \
    -d "{\"name\":\"${WORKSPACE_NAME}\",\"openAiTemp\":0.2,\"chatMode\":\"chat\",\"topN\":4}" >/dev/null
  echo "[ok] Workspace created"
else
  echo "[ok] Workspace '${WORKSPACE_SLUG}' already exists"
fi

# Upload corpus documents
for f in return-policy-zintmart.md faq-hinglish.md product-catalog-snippet.md escalation-playbook.md; do
  if [[ ! -f "${ROOT}/corpus/${f}" ]]; then
    echo "[fail] Missing corpus/${f}"
    exit 1
  fi
  echo "Uploading corpus/${f}..."
  curl -sf -X POST "${BASE}/api/v1/document/upload" \
    -H "$AUTH" \
    -F "file=@${ROOT}/corpus/${f}" \
    -F "addToWorkspaces=${WORKSPACE_SLUG}" >/dev/null
done
echo "[ok] Corpus uploaded"

# Set system prompt
echo "Applying system prompt..."
python3 << PYEOF
import json, urllib.request

prompt = open("${ROOT}/corpus/system-prompt-returns-desk.txt").read()
payload = {"openAiTemp": 0.2, "openAiPrompt": prompt, "chatMode": "chat", "topN": 4}
req = urllib.request.Request(
    "${BASE}/api/v1/workspace/${WORKSPACE_SLUG}/update",
    data=json.dumps(payload).encode(),
    headers={"Authorization": "Bearer ${API_KEY}", "Content-Type": "application/json"},
    method="POST",
)
with urllib.request.urlopen(req) as r:
    d = json.load(r)
    print(f"[ok] System prompt applied ({len(d['workspace']['openAiPrompt'])} chars)")
PYEOF

# Get or create embed
EMBED_UUID=$(curl -sf -H "$AUTH" "${BASE}/api/v1/embed" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for e in data.get('embeds', []):
    print(e['uuid'])
    break
" 2>/dev/null || true)

if [[ -z "$EMBED_UUID" ]]; then
  echo "Creating chat embed..."
  EMBED_UUID=$(curl -sf -X POST "${BASE}/api/v1/embed/new" \
    -H "$AUTH" -H "Content-Type: application/json" \
    -d "{\"workspace_slug\":\"${WORKSPACE_SLUG}\",\"chat_mode\":\"chat\",\"enabled\":true,\"max_chats_per_day\":500,\"max_chats_per_session\":50}" \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['embed']['uuid'])")
  echo "[ok] Embed created: ${EMBED_UUID}"
else
  echo "[ok] Using existing embed: ${EMBED_UUID}"
fi

# Write embed config
mkdir -p "$(dirname "$CONFIG_FILE")"
python3 << PYEOF
import json
cfg = {
    "embedUuid": "${EMBED_UUID}",
    "workspaceSlug": "${WORKSPACE_SLUG}",
    "baseApiUrl": "${BASE}/api/embed",
    "widgetScript": "${BASE}/embed/anythingllm-chat-widget.min.js",
    "note": "Regenerate via scripts/setup-workspace.sh after fresh Docker install"
}
with open("${CONFIG_FILE}", "w") as f:
    json.dump(cfg, f, indent=2)
    f.write("\n")
print(f"[ok] Wrote {cfg['embedUuid']} to config/embed-config.json")
PYEOF

# Patch demo HTML files with UUID
for HTML in "${ROOT}/demo/storefront/index.html" "${ROOT}/demo/embed-snippet.html"; do
  if [[ -f "$HTML" ]]; then
    if grep -q 'YOUR_EMBED_UUID' "$HTML" 2>/dev/null; then
      sed -i.bak "s/YOUR_EMBED_UUID/${EMBED_UUID}/g" "$HTML" && rm -f "${HTML}.bak"
      echo "[ok] Updated $(basename "$HTML") with embed UUID"
    fi
  fi
done

echo ""
echo "=== Setup complete ==="
echo "Embed UUID: ${EMBED_UUID}"
echo "Admin UI:   ${BASE}"
echo "Storefront: file://${ROOT}/demo/storefront/index.html"
echo ""
echo "Next: ./scripts/demo.sh"
