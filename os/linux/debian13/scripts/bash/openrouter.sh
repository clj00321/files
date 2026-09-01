#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")" && pwd)"

# Hent ALT - intet frasorteret
curl -s https://openrouter.ai/api/v1/models -o "$DIR/models-raw.json"

# Hele outputtet, alle felter, som det kommer
jq '.' "$DIR/models-raw.json" > "$DIR/models-alle.json"
