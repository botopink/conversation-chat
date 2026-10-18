#!/usr/bin/env bash
# unread.sh [machine-1|machine-2|machine-3|maintainer] — the entries addressed to that side that it has not
# checked yet (`### [ ] HH:MM — <from> → <to>`), file by file, oldest first. With no argument, every unchecked
# entry of every side. Exit 1 when something is unread, so a session can gate on it.
set -euo pipefail
cd "$(dirname "$0")/.."
side="${1:-}"
case "$side" in
    ""|machine-1|machine-2|machine-3|maintainer) ;;
    *) echo "unread: side must be machine-1, machine-2, machine-3 or maintainer" >&2; exit 2 ;;
esac
to="${side/machine-/machine }"
found=0
for f in $(ls machine-*/????-??-??.md all/????-??-??.md 2>/dev/null | sort); do
    while IFS= read -r line; do
        if [ -n "$side" ]; then
            case "$line" in
                *"→ $to"*) ;;
                *"→ all"*)
                    # three checks, one per machine in order; the maintainer never reads its own broadcast
                    [ "$side" = maintainer ] && continue
                    n="${side#machine-}"
                    checks="$(printf '%s' "$line" | grep -oE '\[[ x]\]' | sed -n "${n}p")"
                    [ "$checks" = "[ ]" ] || continue ;;
                *) continue ;;
            esac
        fi
        [ "$found" -eq 0 ] && echo "unread entries${side:+ for $side}:"
        found=1
        echo "  $f: ${line#\#\#\# }"
    done < <(grep -E '^### (\[[ x]\] )*\[ \] ' "$f" || true)
done
[ "$found" -eq 0 ] && echo "nothing unread${side:+ for $side}"
[ "$found" -eq 0 ]
