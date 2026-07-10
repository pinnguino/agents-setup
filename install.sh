#!/usr/bin/env bash
set -euo pipefail

# Require running as root (script expects to be invoked via sudo)
if [[ "$(id -u)" -ne 0 ]]; then
    printf 'agents-setup must be run with sudo.\n\nExample:\n  sudo ./install.sh\n' >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_SRC="${SCRIPT_DIR}/templates"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Derive the home directory of the user who invoked sudo; if SUDO_USER is not set, use $HOME
if [[ -n "${SUDO_USER:-}" ]]; then
    USER_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
else
    USER_HOME="${HOME}"
fi

DEST_DIR="${USER_HOME}/.config/agents-setup/templates"

if [[ ! -d "$TEMPLATES_SRC" ]]; then
    printf '%b[!] templates directory not found at: %s%b\n' "$RED" "$TEMPLATES_SRC" "$RESET" >&2
    exit 1
fi

mkdir -p "$DEST_DIR"
cp -- "${TEMPLATES_SRC}/plan.md" "${DEST_DIR}/plan.md"
cp -- "${TEMPLATES_SRC}/build.md" "${DEST_DIR}/build.md"

printf '%b[✔] Templates installed to: %s%b\n' "$GREEN" "$DEST_DIR" "$RESET"

# Make the CLI executable and create a symlink in /usr/local/bin/
chmod +x "${SCRIPT_DIR}/bin/agents-setup" 2>/dev/null || true
# If we installed as root on behalf of another user, make sure that user owns the files
if [[ $(id -u) -eq 0 && -n "${SUDO_USER:-}" ]]; then
    chown -R "${SUDO_USER}:${SUDO_USER}" "${USER_HOME}/.config/agents-setup" 2>/dev/null || true
fi

# Try to create the symlink. If we lack permissions, attempt to escalate with sudo.
if ln -sf "${SCRIPT_DIR}/bin/agents-setup" /usr/local/bin/agents-setup 2>/dev/null; then
    printf '%b[✔] Symlink created at: /usr/local/bin/agents-setup%b\n' "$GREEN" "$RESET"
else
    if command -v sudo >/dev/null 2>&1; then
        if sudo ln -sf "${SCRIPT_DIR}/bin/agents-setup" /usr/local/bin/agents-setup; then
            printf '%b[✔] Symlink created at: /usr/local/bin/agents-setup (via sudo)%b\n' "$GREEN" "$RESET"
        else
            printf '%b[?] Could not create symlink at /usr/local/bin/agents-setup. Run: sudo ln -sf "%s" /usr/local/bin/agents-setup%b\n' "$YELLOW" "${SCRIPT_DIR}/bin/agents-setup" "$RESET" >&2
        fi
    else
        printf '%b[?] Could not create symlink at /usr/local/bin/agents-setup and sudo is not available.%b\n' "$YELLOW" "$RESET" >&2
    fi
fi

printf '%b[✔] Successfully installed.%b\n%b[info] Try: agents-setup --help for usage information.%b\n' "$GREEN" "$RESET" "$BLUE" "$RESET"
