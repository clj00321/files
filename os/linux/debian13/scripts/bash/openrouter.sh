#!/usr/bin/env bash
set -euo pipefail

# Mappe hvor scriptet ligger
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTFILE="$DIR/openrouter_openapi.json"

curl -fsSL "https://openrouter.ai/openapi.json" -o "$OUTFILE"

echo "OpenRouter OpenAPI-spec gemt i: $OUTFILE"
