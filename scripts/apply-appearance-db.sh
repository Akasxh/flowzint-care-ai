#!/usr/bin/env bash
# Apply FlowZint Care AI branding to a running flowzint-care container (DB + logo assets).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTAINER="${FLOWZINT_CONTAINER_NAME:-flowzint-care}"
PORT="${FLOWZINT_PORT:-3001}"
LOGO_SRC="${ROOT}/frontend/public/flowzint-care-logo.svg"
LOGO_PNG="${ROOT}/frontend/public/flowzint-care-logo.png"
APP_NAME="${FLOWZINT_APP_NAME:-FlowZint Care AI}"
META_TITLE="${FLOWZINT_META_TITLE:-FlowZint Care AI — Returns Desk}"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  echo "ERROR: Container $CONTAINER is not running. Run ./scripts/start.sh first."
  exit 1
fi

if [[ ! -f "$LOGO_PNG" && -f "$LOGO_SRC" ]]; then
  if command -v sips >/dev/null 2>&1; then
    sips -s format png "$LOGO_SRC" --out "$LOGO_PNG" >/dev/null
    echo "[ok] Generated $LOGO_PNG"
  else
    LOGO_PNG="$LOGO_SRC"
  fi
fi

LOGO_FILENAME="flowzint-care-logo.png"
docker cp "$LOGO_PNG" "${CONTAINER}:/app/server/storage/assets/${LOGO_FILENAME}"
docker cp "$LOGO_PNG" "${CONTAINER}:/app/server/public/flowzint-care-logo.png"
docker exec "$CONTAINER" sh -c '
  cp /app/server/public/flowzint-care-logo.png /app/server/public/anything-llm.png
  cp /app/server/public/flowzint-care-logo.png /app/server/public/anything-llm-dark.png
  cp /app/server/public/flowzint-care-logo.png /app/server/public/anything-llm-light.png
  cp /app/server/public/flowzint-care-logo.png /app/server/storage/assets/anything-llm.png
  cp /app/server/public/flowzint-care-logo.png /app/server/storage/assets/anything-llm-invert.png
'

docker exec "$CONTAINER" python3 -c "
import sqlite3, json, time
db = sqlite3.connect('/app/server/storage/anythingllm.db')
now = int(time.time() * 1000)
footer = json.dumps([
    {'label': 'ZintMart Demo', 'url': 'https://github.com/Akasxh/flowzint-care-ai/tree/main/demo/storefront'},
    {'label': 'Hackathon 2026', 'url': 'https://flowzint.in/2026/ai/hackothon/'},
    {'label': 'Documentation', 'url': 'https://github.com/Akasxh/flowzint-care-ai#readme'},
])

def upsert(label, value):
    row = db.execute('SELECT id FROM system_settings WHERE label = ?', (label,)).fetchone()
    if row:
        db.execute('UPDATE system_settings SET value = ?, lastUpdatedAt = ? WHERE label = ?', (value, now, label))
    else:
        db.execute('INSERT INTO system_settings (label, value, createdAt, lastUpdatedAt) VALUES (?, ?, ?, ?)', (label, value, now, now))

upsert('custom_app_name', '''${APP_NAME}''')
upsert('meta_page_title', '''${META_TITLE}''')
upsert('logo_filename', '''${LOGO_FILENAME}''')
upsert('footer_data', footer)
db.commit()
print('[ok] DB: custom_app_name, meta_page_title, logo_filename, footer_data')
"

docker restart "$CONTAINER" >/dev/null
echo "Waiting for health..."
for i in $(seq 1 40); do
  if curl -sf "http://localhost:${PORT}/api/ping" >/dev/null 2>&1; then
    echo "[ok] ${CONTAINER} healthy — http://localhost:${PORT}"
    curl -sf "http://localhost:${PORT}/api/system/custom-app-name" || true
    echo ""
    curl -sf "http://localhost:${PORT}/" | grep -o '<title[^>]*>[^<]*</title>' | head -1 || true
    exit 0
  fi
  sleep 2
done
echo "WARN: Container restarted but ping not ready yet."
exit 0
