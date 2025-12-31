#!/usr/bin/env bash
set -euo pipefail

create_secret_from_env() {
  local app="$1"
  local namespace="$2"

  local env_file="$HOME/.vps-state/secrets/${app}.env"
  local secret_name="${app}-secret"

  if [ ! -f "$env_file" ]; then
    echo "⚠️  No secrets for $app ($env_file missing), skipping secret."
    return
  fi

  echo "Creating/updating secret for $app..."

  kubectl create namespace "$namespace" \
    --dry-run=client -o yaml | kubectl apply -f -

  kubectl create secret generic "$secret_name" \
    --namespace "$namespace" \
    --from-env-file="$env_file" \
    --dry-run=client -o yaml | kubectl apply -f -
}
