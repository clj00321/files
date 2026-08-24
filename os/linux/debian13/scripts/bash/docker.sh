#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
echo "[$SCRIPT_NAME] 🐳 Installerer Docker"

curl -fsSL https://get.docker.com | bash
systemctl enable --now docker 2>/dev/null || true
echo "[$SCRIPT_NAME] ✅"
