#!/usr/bin/env bash
set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RESET='\033[0m'

rm -f /usr/local/bin/agents-setup

printf '%b[✔] Successfully uninstalled.%b\n' "$GREEN" "$RESET"
printf '%b[info] Your agent configurations still reside in ~/.config/agents-setup%b\n' "$BLUE" "$RESET"
