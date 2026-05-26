#!/usr/bin/env bash
# Build FlowZint Care AI from local rebranded source.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="${FLOWZINT_IMAGE:-flowzint-care-ai:local}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed."
  exit 1
fi

echo "Building ${IMAGE} from ${ROOT} ..."
START=$(date +%s)
docker build -f "${ROOT}/docker/Dockerfile" -t "${IMAGE}" "${ROOT}"
END=$(date +%s)
echo "[ok] Built ${IMAGE} in $((END - START))s"
