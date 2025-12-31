#!/usr/bin/env bash
set -euo pipefail

needs_cert_manager_for_apps() {
  local -n apps=$1

  for app in "${apps[@]}"; do
    if grep -R "cert-manager.io/cluster-issuer" "$ROOT_DIR/$app" >/dev/null 2>&1; then
      return 0
    fi
  done

  return 1
}

ensure_cert_manager_for_apps() {
  local -n apps=$1

  if needs_cert_manager_for_apps apps; then
    log "TLS detected in selected apps → ensuring cert-manager"
    "$ROOT_DIR/cert-manager/install.sh"
    kubectl apply -f "$ROOT_DIR/cert-manager/cluster-issuer.yaml"
  else
    echo "No TLS usage in selected apps"
  fi
}
