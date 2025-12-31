#!/usr/bin/env bash
set -euo pipefail

log() {
  echo -e "\n== $1 =="
}

die() {
  echo "ERROR: $1" >&2
  exit 1
}
