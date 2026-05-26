#!/usr/bin/env bash
# FlowZint Care AI — start from local Docker image (rebranded source)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTAINER_NAME="${FLOWZINT_CONTAINER_NAME:-flowzint-care}"
IMAGE="${FLOWZINT_IMAGE:-flowzint-care-ai:local}"
PORT="${FLOWZINT_PORT:-3001}"
VOLUME="${FLOWZINT_VOLUME:-flowzint-care-storage}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed."
  echo ""
  echo "macOS: install Docker Desktop, then re-run:"
  echo "  ./scripts/start.sh"
  echo ""
  echo "  https://docs.docker.com/desktop/setup/install/mac-install/"
  echo ""
  echo "Without Docker, see docs/DOCKER_FALLBACK.md (Open WebUI or Chainlit)."
  exit 1
fi

# Map common env name → server's OPEN_AI_KEY
if [[ -z "${OPEN_AI_KEY:-}" && -n "${OPENAI_API_KEY:-}" ]]; then
  export OPEN_AI_KEY="$OPENAI_API_KEY"
fi

ENV_ARGS=()
if [[ -n "${OPEN_AI_KEY:-}" ]]; then
  ENV_ARGS+=(
    -e "LLM_PROVIDER=openai"
    -e "OPEN_AI_KEY=${OPEN_AI_KEY}"
    -e "OPEN_MODEL_PREF=${OPEN_MODEL_PREF:-gpt-4o-mini}"
    -e "VECTOR_DB=lancedb"
    -e "EMBEDDING_ENGINE=native"
  )
  echo "Using OpenAI (OPEN_AI_KEY from environment)."
else
  echo "No OPEN_AI_KEY or OPENAI_API_KEY set — you will enter the key in the setup wizard."
  echo "  export OPENAI_API_KEY='sk-...'"
  echo "  ./scripts/start.sh"
fi

ENV_ARGS+=(-e "STORAGE_DIR=/app/server/storage")

ensure_image() {
  if docker image inspect "$IMAGE" >/dev/null 2>&1; then
    return 0
  fi
  echo "Local image $IMAGE not found — building from source (first run)..."
  "${ROOT}/scripts/build-docker.sh"
}

recreate_container() {
  echo "Recreating $CONTAINER_NAME with $IMAGE (preserving volume $VOLUME) ..."
  docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
  docker rm "$CONTAINER_NAME" >/dev/null 2>&1 || true
  docker run -d --name "$CONTAINER_NAME" \
    -p "${PORT}:3001" \
    -v "${VOLUME}:/app/server/storage" \
    "${ENV_ARGS[@]}" \
    "$IMAGE"
}

ensure_image

if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  CURRENT_IMAGE="$(docker inspect -f '{{.Config.Image}}' "$CONTAINER_NAME" 2>/dev/null || true)"
  if [[ "$CURRENT_IMAGE" != "$IMAGE" ]]; then
    recreate_container
  else
    echo "Container $CONTAINER_NAME exists — starting..."
    docker start "$CONTAINER_NAME" >/dev/null
  fi
else
  echo "Starting $CONTAINER_NAME on http://localhost:${PORT} ..."
  docker run -d --name "$CONTAINER_NAME" \
    -p "${PORT}:3001" \
    -v "${VOLUME}:/app/server/storage" \
    "${ENV_ARGS[@]}" \
    "$IMAGE"
fi

echo ""
echo "Open http://localhost:${PORT}"
if [[ -n "${OPEN_AI_KEY:-}" ]]; then
  echo "OpenAI key passed via env — wizard should be pre-configured."
else
  echo "Complete the wizard and choose OpenAI (paste your API key)."
fi
echo ""
echo "Next steps:"
echo "  ./scripts/apply-appearance-db.sh  # apply FlowZint branding to running container"
echo "  ./scripts/setup-workspace.sh    # create Returns Desk + embed (automated)"
echo "  ./scripts/demo.sh               # open storefront + print demo script"
echo ""
echo "See README.md → Demo in 5 minutes"
