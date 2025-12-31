#!/usr/bin/env bash
set -euo pipefail

discover_apps() {
  find "$ROOT_DIR" \
    -mindepth 1 -maxdepth 1 \
    -type d \
    -exec test -f "{}/kustomization.yaml" \; \
    -print |
    xargs -n1 basename |
    sort
}

deploy_app() {
  local app="$1"

  log "Deploying $app"

  create_secret_from_env "$app" "$app"
  kubectl apply -k "$ROOT_DIR/$app"
}
