#!/usr/bin/env bash
# =============================================================================
# OpenClaw Setup Script
# Pulls the OpenClaw Docker image and starts the container with persistent
# volume mapping. All user data is stored in ./data on the host.
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
echo "  OpenClaw Setup"
echo "============================================="
echo ""

# --- Create data directory if it doesn't exist ---
if [ ! -d "$DATA_DIR" ]; then
    echo "[*] Creating data directory at: $DATA_DIR"
    mkdir -p "$DATA_DIR"
else
    echo "[*] Data directory found: $DATA_DIR"
fi

# --- Pull the latest OpenClaw image ---
echo ""
echo "[*] Pulling OpenClaw Docker image..."
docker pull "$IMAGE"

# --- Stop and remove existing container if running ---
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo ""
    echo "[*] Existing container found. Stopping and removing..."
    docker stop "$CONTAINER_NAME" || true
    docker rm "$CONTAINER_NAME" || true
fi

# --- Start the OpenClaw container ---
echo ""
echo "[*] Starting OpenClaw container..."
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
echo "  OpenClaw is running!"
echo "============================================="
echo ""
echo "  Data dir  : $DATA_DIR  -->  /home/node/.openclaw (inside container)"
echo ""
echo "  NEXT STEPS:"
echo "  1. Add your Telegram bot token and Kimi API key to:"
echo "       $DATA_DIR/openclaw.json"
echo "  2. Follow Setup_Telegram.md to pair your Telegram device."
echo "  3. Follow Setup_Kimi.md to configure your Kimi Moonshot API key."
echo "  4. Restart the container after editing the config:"
echo "       docker restart $CONTAINER_NAME"
echo ""
