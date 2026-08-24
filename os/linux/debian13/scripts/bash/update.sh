#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
echo "[$SCRIPT_NAME] 🔄 Opdaterer system"

apt-get update -qq
apt-get upgrade -y -qq
apt-get autoremove -y -qq
echo "[$SCRIPT_NAME] ✅"
