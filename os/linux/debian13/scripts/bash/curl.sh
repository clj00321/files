#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
echo "[$SCRIPT_NAME] 📡 Installerer curl"

apt-get update -qq && apt-get install -y -qq curl >/dev/null 2>&1
echo "[$SCRIPT_NAME] ✅"
