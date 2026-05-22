#!/usr/bin/env sh
set -eu

BACKEND_IMAGE="${BACKEND_IMAGE:-employee-backend:local}"
FRONTEND_IMAGE="${FRONTEND_IMAGE:-employee-frontend:local}"
APP_URL="${APP_URL:-http://localhost}"

docker compose build
docker build -t "$BACKEND_IMAGE" -f backend/Dockerfile .
docker build -t "$FRONTEND_IMAGE" -f frontend/Dockerfile .
trivy image --severity HIGH,CRITICAL "$BACKEND_IMAGE"
trivy image --severity HIGH,CRITICAL "$FRONTEND_IMAGE"
trivy fs --severity HIGH,CRITICAL .
docker run --rm -t owasp/zap2docker-stable zap-baseline.py -t "$APP_URL" -r zap-report.html
