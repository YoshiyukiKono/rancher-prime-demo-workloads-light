#!/usr/bin/env bash
set -euo pipefail

kubectl delete namespace demo-light --ignore-not-found=true
