#!/usr/bin/env bash
set -euo pipefail

if kubectl get ns cert-manager >/dev/null 2>&1; then
  echo "cert-manager already installed"
  exit 0
fi

echo "Installing cert-manager..."

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

echo "Waiting for cert-manager..."
kubectl rollout status deployment cert-manager -n cert-manager
kubectl rollout status deployment cert-manager-webhook -n cert-manager
kubectl rollout status deployment cert-manager-cainjector -n cert-manager

echo "cert-manager installed"
