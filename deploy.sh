#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Imports
source "$ROOT_DIR/lib/log.sh"
source "$ROOT_DIR/lib/secrets.sh"
source "$ROOT_DIR/lib/apps.sh"
source "$ROOT_DIR/lib/select.sh"
source "$ROOT_DIR/lib/tls.sh"

main() {
  log "k3s App Deployment"

  mapfile -t ALL_APPS < <(discover_apps)

  [ "${#ALL_APPS[@]}" -gt 0 ] || {
    echo "No apps found. Nothing to deploy."
    exit 0
  }

  declare -a APPS_TO_DEPLOY=()
  select_apps ALL_APPS APPS_TO_DEPLOY

  ensure_cert_manager_for_apps APPS_TO_DEPLOY

  for app in "${APPS_TO_DEPLOY[@]}"; do
    deploy_app "$app"
  done

  log "Deployment complete"
}

main "$@"
