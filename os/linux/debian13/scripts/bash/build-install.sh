#!/usr/bin/env bash
# build-install.sh — genererer en selvstændig install.sh med alle scripts i mappen indlejret.
# Kør efter tilføjelse/ændring af *.sh i mappen, eller lad GitHub Actions gøre det.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$SCRIPT_DIR/install.sh"
SELF="$(basename "${BASH_SOURCE[0]}")"

# Reproducerbar tidsstempling: brug seneste commit-dato for mappen, ellers nu.
# Så giver uændrede kildescripts en bit-identisk install.sh — ingen støj-commits.
GEN_DATE="$(git -C "$SCRIPT_DIR" log -1 --format=%cI -- "$SCRIPT_DIR" 2>/dev/null || true)"
[[ -n "$GEN_DATE" ]] || GEN_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# --- Indsaml scripts (alt undtagen install.sh og generatoren selv) -----------
scripts=()
while IFS= read -r -d '' f; do
    n="$(basename "$f")"
    [[ "$n" == "install.sh" || "$n" == "$SELF" ]] && continue
    scripts+=("$n")
done < <(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "*.sh" -print0 | sort -z)

if [[ ${#scripts[@]} -eq 0 ]]; then
    echo "❌ Ingen scripts at indlejre i $SCRIPT_DIR" >&2
    exit 1
fi

# --- Udled menutekst: '# desc:' hvis den findes, ellers første echo-linje ----
describe() {
    local file="$1" d=""
    d="$(grep -m1 -oP '^#\s*desc:\s*\K.*' "$file" || true)"
    if [[ -z "$d" ]]; then
        d="$(grep -m1 -oP '^echo\s+"\[\$SCRIPT_NAME\]\s*\K[^"]*' "$file" || true)"
    fi
    [[ -z "$d" ]] && d="(ingen beskrivelse)"
    printf '%s' "$d"
}

# --- Sikker enkeltcitering (bevarer UTF-8/emoji læsbart, modsat %q) ---------
sq() { local x=${1//\'/\'\\\'\'}; printf "'%s'" "$x"; }

echo "🔧 Genererer $OUT ud fra ${#scripts[@]} script(s)…"

# --- Header ------------------------------------------------------------------
cat > "$OUT" <<'HEADER'
#!/usr/bin/env bash
# ==============================================================================
#  install.sh — Debian 13 installationsmenu (selvstændig / self-contained)
#
#  ⚠️  AUTOGENERERET FIL — REDIGÉR IKKE MANUELT.
#      Redigér de enkelte *.sh i mappen og kør ./build-install.sh
#      (eller push — GitHub Actions genererer automatisk).
#
#  Kræver ingen ekstra filer. Alle scripts ligger indlejret som base64 herunder.
#
#  Brug:
#    bash install.sh                      # interaktiv menu (flere valg ad gangen)
#    curl -fsSL <raw-url> | bash          # interaktiv via /dev/tty
#    curl -fsSL <raw-url> | bash -s -- --all
#    curl -fsSL <raw-url> | bash -s -- --run update.sh,docker.sh
#    bash install.sh --list
#    bash install.sh --extract ./scripts
# ==============================================================================
set -euo pipefail

SCRIPT_NAME="install.sh"
HEADER

{
    printf 'GENERATED_AT="%s"\n' "$GEN_DATE"
    printf 'SCRIPT_COUNT=%d\n' "${#scripts[@]}"
    printf 'BUNDLE_SHA="%s"\n\n' \
        "$(cd "$SCRIPT_DIR" && sha256sum "${scripts[@]}" | sha256sum | cut -c1-16)"

    # Rækkefølge, beskrivelser, checksums
    printf 'ORDER=(\n'
    for n in "${scripts[@]}"; do printf '    %s\n' "$(sq "$n")"; done
    printf ')\n\n'

    printf 'declare -A DESC=()\n'
    for n in "${scripts[@]}"; do
        printf 'DESC[%s]=%s\n' "$(sq "$n")" "$(sq "$(describe "$SCRIPT_DIR/$n")")"
    done
    printf '\n'

    printf 'declare -A SHA=()\n'
    for n in "${scripts[@]}"; do
        printf 'SHA[%s]=%s\n' "$(sq "$n")" "$(sq "$(sha256sum "$SCRIPT_DIR/$n" | cut -c1-12)")"
    done
    printf '\n'

    # Indlejrede payloads
    printf '# ---------------------- INDLEJREDE SCRIPTS (base64) ----------------------\n'
    printf 'declare -A PAYLOAD=()\n\n'
    for n in "${scripts[@]}"; do
        printf '# %s\n' "$n"
        printf 'PAYLOAD[%s]=$(cat <<'"'"'__B64_EOF__'"'"'\n' "$(sq "$n")"
        base64 -w 76 "$SCRIPT_DIR/$n"
        printf '__B64_EOF__\n)\n\n'
    done
} >> "$OUT"

# --- Footer: menu- og kørselslogik ------------------------------------------
cat >> "$OUT" <<'FOOTER'
# ------------------------------- Hjælpefunktioner ----------------------------
INPUT_SRC=""
init_input() {
    # 'curl | bash' giver et rør på stdin — læs derfor fra /dev/tty når den findes,
    # så scriptets egne bytes ikke bliver spist af read.
    if [[ -t 0 ]]; then
        INPUT_SRC=""
    elif ( exec 3< /dev/tty ) 2>/dev/null; then
        INPUT_SRC="/dev/tty"
    else
        INPUT_SRC=""
    fi
}

ask() {
    local prompt="$1" __var="$2" __ans=""
    if [[ -n "$INPUT_SRC" ]]; then
        read -rp "$prompt" __ans < "$INPUT_SRC" || { echo ""; echo "  👋 Afslutter"; exit 0; }
    else
        read -rp "$prompt" __ans || { echo ""; echo "  👋 Afslutter"; exit 0; }
    fi
    printf -v "$__var" '%s' "$__ans"
}

print_menu() {
    echo ""
    echo "[$SCRIPT_NAME] 🌐 Debian 13 — Installationsmenu"
    echo "  ────────────────────────────────────────────────────────────"
    local i
    for i in "${!ORDER[@]}"; do
        printf "  %2d) 📦 %-16s %s\n" "$((i+1))" "${ORDER[$i]}" "${DESC[${ORDER[$i]}]}"
    done
    echo "  ────────────────────────────────────────────────────────────"
    echo "   a) 🚀 Kør alle          q) ❌ Afslut"
    echo ""
    echo "  💡 Flere valg ad gangen: '1 3 4', '1,3,4' eller interval '1-3'"
    echo ""
}

# Oversætter et valg som '1,3-5 7' til unikke scriptnavne i menu-rækkefølge
parse_selection() {
    local raw="$1" tok start end i
    local -a picked=()
    local -A seen=()
    raw="${raw//,/ }"
    for tok in $raw; do
        if [[ "$tok" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            start="${BASH_REMATCH[1]}"; end="${BASH_REMATCH[2]}"
            (( start <= end )) || { local t="$start"; start="$end"; end="$t"; }
            for (( i=start; i<=end; i++ )); do
                (( i >= 1 && i <= ${#ORDER[@]} )) || { echo "  ❌ Uden for interval: $i" >&2; return 1; }
                [[ -n "${seen[$i]:-}" ]] && continue
                seen[$i]=1; picked+=("${ORDER[$((i-1))]}")
            done
        elif [[ "$tok" =~ ^[0-9]+$ ]]; then
            (( tok >= 1 && tok <= ${#ORDER[@]} )) || { echo "  ❌ Uden for interval: $tok" >&2; return 1; }
            [[ -n "${seen[$tok]:-}" ]] && continue
            seen[$tok]=1; picked+=("${ORDER[$((tok-1))]}")
        else
            echo "  ❌ Ugyldigt token: '$tok'" >&2; return 1
        fi
    done
    (( ${#picked[@]} > 0 )) || { echo "  ❌ Tomt valg" >&2; return 1; }
    printf '%s\n' "${picked[@]}"
}

WORKDIR=""
cleanup() {
    if [[ -n "${WORKDIR:-}" && -d "$WORKDIR" ]]; then rm -rf "$WORKDIR"; fi
    return 0
}
trap cleanup EXIT

materialize() {  # udpakker alle indlejrede scripts til en mappe
    local dir="$1" n
    mkdir -p "$dir"
    for n in "${ORDER[@]}"; do
        printf '%s' "${PAYLOAD[$n]}" | base64 -d > "$dir/$n"
        chmod +x "$dir/$n"
    done
}

run_selected() {
    local -a list=("$@")
    local n rc=0 ok=0 fail=0
    WORKDIR="$(mktemp -d)"
    materialize "$WORKDIR"

    echo ""
    echo "  ▶️  Kører ${#list[@]} script(s): ${list[*]}"
    echo ""
    for n in "${list[@]}"; do
        echo "  ──────────────────────────────────────────"
        echo "  ▶️  $n  (sha ${SHA[$n]})"
        rc=0
        bash "$WORKDIR/$n" || rc=$?
        if (( rc == 0 )); then
            echo "  ✅ $n færdig"; ok=$((ok+1))
        else
            echo "  ❌ $n fejlede (exit $rc)"; fail=$((fail+1))
        fi
    done
    echo "  ──────────────────────────────────────────"
    echo "  🎉 Færdig — $ok ok, $fail fejlet"
    (( fail == 0 ))
}

# ---------------------------------- CLI --------------------------------------
case "${1:-}" in
    --list|-l)
        printf '%-18s %-14s %s\n' "SCRIPT" "SHA256" "BESKRIVELSE"
        for n in "${ORDER[@]}"; do printf '%-18s %-14s %s\n' "$n" "${SHA[$n]}" "${DESC[$n]}"; done
        exit 0 ;;
    --extract|-x)
        target="${2:-./extracted}"
        materialize "$target"
        echo "  📂 Udpakket $SCRIPT_COUNT script(s) til $target"
        exit 0 ;;
    --all|-a)
        if run_selected "${ORDER[@]}"; then exit 0; else exit 1; fi ;;
    --run|-r)
        [[ -n "${2:-}" ]] || { echo "  ❌ --run kræver navne, fx --run update.sh,docker.sh" >&2; exit 1; }
        IFS=',' read -r -a want <<< "$2"
        sel=()
        for n in "${want[@]}"; do
            n="${n// /}"; [[ -z "$n" ]] && continue
            [[ -n "${PAYLOAD[$n]:-}" ]] || { echo "  ❌ Ukendt script: $n" >&2; exit 1; }
            sel+=("$n")
        done
        if run_selected "${sel[@]}"; then exit 0; else exit 1; fi ;;
    --version|-v)
        echo "install.sh — genereret $GENERATED_AT — $SCRIPT_COUNT script(s) indlejret"; exit 0 ;;
    --help|-h)
        sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    "") : ;;
    *)  echo "  ❌ Ukendt flag: $1 (se --help)" >&2; exit 1 ;;
esac

# ------------------------------ Interaktiv menu ------------------------------
init_input

while true; do
    print_menu
    ask "  Valg: " choice
    choice="${choice#"${choice%%[![:space:]]*}"}"
    choice="${choice%"${choice##*[![:space:]]}"}"

    case "$choice" in
        [qQ]|"") echo "  👋 Afslutter"; exit 0 ;;
        [aA]|alle|all)
            selection=("${ORDER[@]}") ;;
        *)
            if ! sel_raw="$(parse_selection "$choice")"; then echo ""; continue; fi
            mapfile -t selection <<< "$sel_raw" ;;
    esac

    echo ""
    echo "  📋 Valgt: ${selection[*]}"
    ask "  Bekræft? [J/n]: " confirm
    case "$confirm" in
        [nN]|[nN][eE][jJ]) echo "  ↩️  Fortryder"; continue ;;
    esac

    run_selected "${selection[@]}" || true
    echo ""
    ask "  Tilbage til menu? [J/n]: " again
    case "$again" in
        [nN]|[nN][eE][jJ]) echo "  👋 Afslutter"; exit 0 ;;
    esac
done
FOOTER

chmod +x "$OUT"
bash -n "$OUT"

echo "✅ $OUT genereret — ${#scripts[@]} script(s) indlejret, syntaks OK"
for n in "${scripts[@]}"; do echo "   • $n"; done
