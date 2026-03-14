#!/usr/bin/env bash
# =============================================================================
# OpenClaw Update Script
# Stops the current container, removes it, pulls the latest image, and
# restarts with the same volume mappings — user data is preserved.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
IMAGE="ghcr.io/openclaw/openclaw:latest"
CONTAINER_NAME="openclaw"
HOST_PORT="127.0.0.1:8080"
CONTAINER_PORT="8080"

echo ""
echo "============================================="
echo "  OpenClaw Updater"
echo "============================================="
echo ""

# --- Stop the running container ---
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[*] Stopping container: $CONTAINER_NAME"
    docker stop "$CONTAINER_NAME"
else
    echo "[*] Container '$CONTAINER_NAME' is not running. Skipping stop."
fi

# --- Remove the old container ---
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[*] Removing old container: $CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
else
    echo "[*] No existing container to remove."
fi

# --- Pull the latest image ---
echo ""
echo "[*] Pulling latest OpenClaw image..."
docker pull "$IMAGE"

# --- Start the updated container with the same volume mapping ---
echo ""
echo "[*] Starting updated OpenClaw container..."
docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p "${HOST_PORT}:${CONTAINER_PORT}" \
    -v "${DATA_DIR}:/home/node/.openclaw" \
    "$IMAGE"

# --- Apply Shagga-Claw persona patch ---
echo ""
echo "[*] Applying Shagga-Claw persona..."
docker cp "$SCRIPT_DIR/shagga_patch.py" "$CONTAINER_NAME:/tmp/shagga_patch.py"
docker exec "$CONTAINER_NAME" python3 /tmp/shagga_patch.py
docker restart "$CONTAINER_NAME"
echo "[*] Shagga-Claw persona applied. Halfman... prepare yourself."

echo ""
echo "============================================="
echo "  Update complete!"
echo "============================================="
echo ""
echo "  Your data in $DATA_DIR has been preserved."
echo "  Container '$CONTAINER_NAME' is now running the latest version."
echo ""
