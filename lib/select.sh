#!/usr/bin/env bash
set -euo pipefail

select_apps() {
  local -n all_apps=$1
  local -n selected_apps=$2

  echo
  echo "Discovered apps:"
  for i in "${!all_apps[@]}"; do
    printf "  [%d] %s\n" "$((i + 1))" "${all_apps[$i]}"
  done

  echo
  read -p "Enter numbers to EXCLUDE (comma-separated), or press Enter to deploy all: " input </dev/tty

  if [ -z "$input" ]; then
    selected_apps=("${all_apps[@]}")
    return
  fi

  declare -A exclude
  IFS=',' read -ra nums <<<"$input"

  for n in "${nums[@]}"; do
    [[ "$n" =~ ^[0-9]+$ ]] || die "Invalid selection: $n"
    ((n >= 1 && n <= ${#all_apps[@]})) || die "Out of range: $n"
    exclude["${all_apps[$((n - 1))]}"]=1
  done

  for app in "${all_apps[@]}"; do
    [ -z "${exclude[$app]:-}" ] && selected_apps+=("$app")
  done
}
