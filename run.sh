#!/usr/bin/env bash

set -e

IMAGE_NAME="seqtrace-xfce"
CONTAINER_NAME="seqtrace-xfce"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
FILES_DIR="$PROJECT_DIR/files"

case "$1" in
  start)
    # INFO: remove container only if it exists
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
      # INFO: stopping container if running
      docker stop "$CONTAINER_NAME" 2>/dev/null || true
      # INFO: removing existing container
      docker rm "$CONTAINER_NAME" 2>/dev/null || true
    fi

    # INFO: build image using cache (only rebuild changed layers)
    docker build -t "$IMAGE_NAME" .

    # INFO: start container
    docker run -d \
      --name "$CONTAINER_NAME" \
      -p 6080:6080 \
      -v "$FILES_DIR:/root/Desktop/files" \
      "$IMAGE_NAME"

    echo "[INFO] container started"
    sleep 5
    NO_AT_BRIDGE=1 xdg-open "http://localhost:6080/vnc_lite.html"
    echo "[INFO] access via browser: http://localhost:6080/vnc_lite.html"
    ;;

  stop)
    # INFO: stop and remove container if exists
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
    echo "[INFO] stopped"
    ;;

  *)
    echo "usage: $0 {start|stop}"
    exit 1
    ;;
esac