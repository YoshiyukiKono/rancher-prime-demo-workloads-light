#!/usr/bin/env bash
set -euo pipefail

kubectl get ns demo-light

echo ""
echo "== pods =="
kubectl get pods -n demo-light -o wide

echo ""
echo "== services =="
kubectl get svc -n demo-light

echo ""
echo "== top pods =="
kubectl top pods -n demo-light || true

echo ""
echo "== recent traffic-generator logs =="
kubectl logs -n demo-light deploy/traffic-generator --tail=20 || true
