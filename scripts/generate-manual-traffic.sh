#!/usr/bin/env bash
set -euo pipefail

POD="$(kubectl -n demo-light get pod -l app=debug-curl -o jsonpath='{.items[0].metadata.name}')"

echo "Using pod: $POD"

echo ""
echo "frontend-nginx"
kubectl -n demo-light exec "$POD" -- curl -sS http://frontend-nginx | head -20

echo ""
echo "backend-httpbin /get"
kubectl -n demo-light exec "$POD" -- curl -sS http://backend-httpbin:8000/get

echo ""
echo "backend-httpbin /headers"
kubectl -n demo-light exec "$POD" -- curl -sS http://backend-httpbin:8000/headers
