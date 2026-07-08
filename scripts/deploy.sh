#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

kubectl apply -k "$ROOT_DIR/k8s"

echo ""
echo "Waiting for deployments..."
kubectl -n demo-light rollout status deploy/frontend-nginx --timeout=120s
kubectl -n demo-light rollout status deploy/backend-httpbin --timeout=120s
kubectl -n demo-light rollout status deploy/traffic-generator --timeout=120s
kubectl -n demo-light rollout status deploy/debug-curl --timeout=120s

echo ""
kubectl get pods -n demo-light -o wide
