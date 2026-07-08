#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$BASE_DIR/outputs"
mkdir -p "$OUT"

echo "[snapshot] writing to: $OUT"

date > "$OUT/snapshot-date.txt"

kubectl version > "$OUT/kubectl-version.txt" 2>&1 || true
kubectl config current-context > "$OUT/current-context.txt" 2>&1 || true

kubectl get nodes -o wide > "$OUT/nodes.txt" 2>&1 || true
kubectl get ns > "$OUT/namespaces.txt" 2>&1 || true
kubectl get pods -A -o wide > "$OUT/pods-all.txt" 2>&1 || true
kubectl top nodes > "$OUT/top-nodes.txt" 2>&1 || true
kubectl top pods -A > "$OUT/top-pods-all.txt" 2>&1 || true

kubectl get all -n demo-light > "$OUT/demo-light-all.txt" 2>&1 || true
kubectl get pods -n demo-light -o wide > "$OUT/demo-light-pods.txt" 2>&1 || true
kubectl get deploy -n demo-light -o yaml > "$OUT/demo-light-deployments.yaml" 2>&1 || true
kubectl get svc -n demo-light -o yaml > "$OUT/demo-light-services.yaml" 2>&1 || true
kubectl top pods -n demo-light > "$OUT/demo-light-top-pods.txt" 2>&1 || true
kubectl logs -n demo-light deploy/traffic-generator --tail=100 > "$OUT/demo-light-traffic-generator.log" 2>&1 || true

if command -v rdctl >/dev/null 2>&1; then
  rdctl list-settings > "$OUT/rancher-desktop-settings.json" 2>&1 || true
fi

echo "[snapshot] done"
