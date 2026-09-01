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
GENERATED_AT="2026-09-01T08:16:50+02:00"
SCRIPT_COUNT=4
BUNDLE_SHA="f2eb6fa1c3626ead"

ORDER=(
    'curl.sh'
    'docker.sh'
    'su.sh'
    'update.sh'
)

declare -A DESC=()
DESC['curl.sh']='📡 Installerer curl'
DESC['docker.sh']='🐳 Installerer Docker'
DESC['su.sh']='🌐 Debian 13 — Installationsmenu'
DESC['update.sh']='🔄 Opdaterer system'

declare -A SHA=()
SHA['curl.sh']='2fd7227525e7'
SHA['docker.sh']='119b92f3f0a2'
SHA['su.sh']='9e91bdfdf202'
SHA['update.sh']='609e05dd4c6a'

# ---------------------- INDLEJREDE SCRIPTS (base64) ----------------------
declare -A PAYLOAD=()

# curl.sh
PAYLOAD['curl.sh']=$(cat <<'__B64_EOF__'
IyEvdXNyL2Jpbi9lbnYgYmFzaApzZXQgLWV1byBwaXBlZmFpbAoKU0NSSVBUX05BTUU9IiQoYmFz
ZW5hbWUgIiQwIikiCmVjaG8gIlskU0NSSVBUX05BTUVdIPCfk6EgSW5zdGFsbGVyZXIgY3VybCIK
CmFwdC1nZXQgdXBkYXRlIC1xcSAmJiBhcHQtZ2V0IGluc3RhbGwgLXkgLXFxIGN1cmwgPi9kZXYv
bnVsbCAyPiYxCmVjaG8gIlskU0NSSVBUX05BTUVdIOKchSIK
__B64_EOF__
)

# docker.sh
PAYLOAD['docker.sh']=$(cat <<'__B64_EOF__'
IyEvdXNyL2Jpbi9lbnYgYmFzaApzZXQgLWV1byBwaXBlZmFpbAoKU0NSSVBUX05BTUU9IiQoYmFz
ZW5hbWUgIiQwIikiCmVjaG8gIlskU0NSSVBUX05BTUVdIPCfkLMgSW5zdGFsbGVyZXIgRG9ja2Vy
IgoKY3VybCAtZnNTTCBodHRwczovL2dldC5kb2NrZXIuY29tIHwgYmFzaApzeXN0ZW1jdGwgZW5h
YmxlIC0tbm93IGRvY2tlciAyPi9kZXYvbnVsbCB8fCB0cnVlCmVjaG8gIlskU0NSSVBUX05BTUVd
IOKchSIK
__B64_EOF__
)

# su.sh
PAYLOAD['su.sh']=$(cat <<'__B64_EOF__'
IyEvdXNyL2Jpbi9lbnYgYmFzaApzZXQgLWV1byBwaXBlZmFpbAoKU0NSSVBUX05BTUU9IiQoYmFz
ZW5hbWUgIiQwIikiClNDUklQVF9ESVI9IiQoY2QgIiQoZGlybmFtZSAiJHtCQVNIX1NPVVJDRVsw
XX0iKSIgJiYgcHdkKSIKUkFXX0JBU0U9Imh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNv
bS9PV05FUi9SRVBPL21haW4vY28vbGludXMvZGViaWFuMTMvc2NyaXB0cy9iYXNoIgoKZWNobyAi
WyRTQ1JJUFRfTkFNRV0g8J+MkCBEZWJpYW4gMTMg4oCUIEluc3RhbGxhdGlvbnNtZW51IgplY2hv
ICIgIOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgCIKCnNjcmlwdHM9
KCkKd2hpbGUgSUZTPSByZWFkIC1yIC1kICcnIGZpbGU7IGRvCiAgICBuYW1lPSIkKGJhc2VuYW1l
ICIkZmlsZSIpIgogICAgW1sgIiRuYW1lIiA9PSAiaW5zdGFsbC5zaCIgXV0gJiYgY29udGludWUK
ICAgIHNjcmlwdHMrPSgiJG5hbWUiKQpkb25lIDwgPChmaW5kICIkU0NSSVBUX0RJUiIgLW1heGRl
cHRoIDEgLW5hbWUgIiouc2giIC1wcmludDAgfCBzb3J0IC16KQoKaWYgW1sgJHsjc2NyaXB0c1tA
XX0gLWVxIDAgXV07IHRoZW4KICAgIGVjaG8gIiAg4pqg77iPICBJbmdlbiBzY3JpcHRzIGZ1bmRl
dCBpICRTQ1JJUFRfRElSIgogICAgZXhpdCAxCmZpCgojIE1FTlVfU1RBUlQKZm9yIGkgaW4gIiR7
IXNjcmlwdHNbQF19IjsgZG8KICAgIGVjaG8gIiAgJCgoaSsxKSkpIPCfk6YgJHtzY3JpcHRzWyRp
XX0iCmRvbmUKIyBNRU5VX0VORAoKZWNobyAiIgplY2hvICIgIGEpIPCfmoAgS8O4ciBhbGxlIgpl
Y2hvICIgIHEpIOKdjCBBZnNsdXQiCmVjaG8gIiIKCnJlYWQgLXJwICIgIFZhbGc6ICIgY2hvaWNl
CgpydW5fc2NyaXB0KCkgewogICAgbG9jYWwgc2NyaXB0PSIkMSIKICAgIGVjaG8gIiIKICAgIGVj
aG8gIiAg4pa277iPICAkc2NyaXB0IgogICAgaWYgW1sgLWYgIiRTQ1JJUFRfRElSLyRzY3JpcHQi
IF1dOyB0aGVuCiAgICAgICAgYmFzaCAiJFNDUklQVF9ESVIvJHNjcmlwdCIKICAgIGVsc2UKICAg
ICAgICBjdXJsIC1mc1NMICIkUkFXX0JBU0UvJHNjcmlwdCIgfCBiYXNoCiAgICBmaQogICAgZWNo
byAiICDinIUgJHNjcmlwdCBmw6ZyZGlnIgp9CgpjYXNlICIkY2hvaWNlIiBpbgogICAgW2FBXSkK
ICAgICAgICBmb3IgcyBpbiAiJHtzY3JpcHRzW0BdfSI7IGRvIHJ1bl9zY3JpcHQgIiRzIjsgZG9u
ZQogICAgICAgIGVjaG8gIiAg8J+OiSBBbGxlIHNjcmlwdHMgZsOmcmRpZ2UhIgogICAgICAgIDs7
CiAgICBbcVFdKSBlY2hvICIgIPCfkYsgQWZzbHV0dGVyIjsgZXhpdCAwIDs7CiAgICAqKQogICAg
ICAgIGlmIFtbICIkY2hvaWNlIiA9fiBeWzAtOV0rJCBdXSAmJiAoKCBjaG9pY2UgPj0gMSAmJiBj
aG9pY2UgPD0gJHsjc2NyaXB0c1tAXX0gKSk7IHRoZW4KICAgICAgICAgICAgcnVuX3NjcmlwdCAi
JHtzY3JpcHRzWyQoKGNob2ljZS0xKSldfSIKICAgICAgICBlbHNlCiAgICAgICAgICAgIGVjaG8g
IiAg4p2MIFVneWxkaWd0IHZhbGciOyBleGl0IDEKICAgICAgICBmaQogICAgICAgIDs7CmVzYWMK
__B64_EOF__
)

# update.sh
PAYLOAD['update.sh']=$(cat <<'__B64_EOF__'
IyEvdXNyL2Jpbi9lbnYgYmFzaApzZXQgLWV1byBwaXBlZmFpbAoKU0NSSVBUX05BTUU9IiQoYmFz
ZW5hbWUgIiQwIikiCmVjaG8gIlskU0NSSVBUX05BTUVdIPCflIQgT3BkYXRlcmVyIHN5c3RlbSIK
CmFwdC1nZXQgdXBkYXRlIC1xcQphcHQtZ2V0IHVwZ3JhZGUgLXkgLXFxCmFwdC1nZXQgYXV0b3Jl
bW92ZSAteSAtcXEKZWNobyAiWyRTQ1JJUFRfTkFNRV0g4pyFIgo=
__B64_EOF__
)

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
