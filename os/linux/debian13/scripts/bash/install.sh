#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAW_BASE="https://raw.githubusercontent.com/clj00321/files/main/co/linus/debian13/scripts/bash"

echo "[$SCRIPT_NAME] 🌐 Debian 13 — Installationsmenu"
echo "  ─────────────────────────────────"

scripts=()
while IFS= read -r -d '' file; do
    name="$(basename "$file")"
    [[ "$name" == "install.sh" ]] && continue
    scripts+=("$name")
done < <(find "$SCRIPT_DIR" -maxdepth 1 -name "*.sh" -print0 | sort -z)

if [[ ${#scripts[@]} -eq 0 ]]; then
    echo "  ⚠️  Ingen scripts fundet i $SCRIPT_DIR"
    exit 1
fi

# MENU_START
for i in "${!scripts[@]}"; do
    echo "  $((i+1))) 📦 ${scripts[$i]}"
done
# MENU_END

echo ""
echo "  a) 🚀 Kør alle"
echo "  q) ❌ Afslut"
echo ""

read -rp "  Valg: " choice

run_script() {
    local script="$1"
    echo ""
    echo "  ▶️  $script"
    if [[ -f "$SCRIPT_DIR/$script" ]]; then
        bash "$SCRIPT_DIR/$script"
    else
        curl -fsSL "$RAW_BASE/$script" | bash
    fi
    echo "  ✅ $script færdig"
}

case "$choice" in
    [aA])
        for s in "${scripts[@]}"; do run_script "$s"; done
        echo "  🎉 Alle scripts færdige!"
        ;;
    [qQ]) echo "  👋 Afslutter"; exit 0 ;;
    *)
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#scripts[@]} )); then
            run_script "${scripts[$((choice-1))]}"
        else
            echo "  ❌ Ugyldigt valg"; exit 1
        fi
        ;;
esac
