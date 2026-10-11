#!/usr/bin/env bash
# Process-detection layer: scan tmux panes for agent processes and infer
# state when no hook wrote state for that pane.
#
# Nacelle: pane_pid is the shell, nacelle is a direct child, and its pid is
# embedded in the transcript filename (~/.nacelle/sessions/*-<pid>.jsonl).
# Transcripts carry only question/answer/tool entries, so:
#   working = last entry is a tool or a fresh question/answer
#   done    = last entry is an answer 3-60s old
#   waiting = nothing new for over 60s after an answer (client at prompt)

set -u

STATE_DIR="${TMUX_AGENT_SIDEBAR_DIR:-$HOME/.cache/tmux-agent-sidebar}"
NACELLE_SESSIONS="$HOME/.nacelle/sessions"
BULLE_SESSIONS="$HOME/.bulle/sessions"
NOW="$(date +%s)"

write_state() {
    local pane="$1" status="$2" summary="$3" window="$4" detected="$5" harness="${6:-}"
    summary="${summary//\"/\\\"}"
    printf '{"pane":"%s","status":"%s","summary":"%s","window":"%s","updated":"%s","detected":%s,"harness":"%s"}\n' \
        "$pane" "$status" "$summary" "$window" "$NOW" "$detected" "$harness" \
        > "$STATE_DIR/$pane.json"
}

nacelle_state() {
    local line who ts epoch age
    line="$(tail -n 1 "$1" 2>/dev/null)"
    [ -n "$line" ] || { echo "idle"; return; }
    who="$(printf '%s' "$line" | sed -n 's/.*"who"[: ]*"\([^"]*\)".*/\1/p')"
    ts="$(printf '%s' "$line" | sed -n 's/.*"t"[: ]*"\([^"]*\)".*/\1/p')"
    epoch="$(date -d "$ts" +%s 2>/dev/null || echo 0)"
    age=$(( NOW - epoch ))
    case "$who" in
        tool)     echo "working" ;;
        question) echo "working" ;;
        answer)
            if [ "$age" -lt 3 ]; then echo "working"
            elif [ "$age" -gt 60 ]; then echo "waiting"
            else echo "done"
            fi
            ;;
        *) echo "idle" ;;
    esac
}

last_question() {
    grep '"who"[: ]*"question"' "$1" 2>/dev/null | tail -1 \
        | sed -n 's/.*"text"[: ]*"\([^"]\{0,48\}\)[^"]*".*/\1/p'
}

mkdir -p "$STATE_DIR"
pane_list="$(tmux list-panes -a -F '#{pane_id}|#{pane_pid}|#{window_index}:#{window_name}' 2>/dev/null || true)"

harness_in_pane() {
    local child
    for child in $(pgrep -P "$1" 2>/dev/null); do
        case "$(ps -o args= -p "$child" 2>/dev/null)" in
            *nacelle*|*claude*|*codex*|*bulle*|*antigravity*|*agy*) return 0 ;;
        esac
    done
    return 1
}

# prune state files for panes that no longer exist
for f in "$STATE_DIR"/*.json; do
    [ -f "$f" ] || continue
    pane="$(sed -n 's/.*"pane"[: ]*"\([^"]*\)".*/\1/p' "$f")"
    [ -n "$pane" ] || continue
    if ! printf '%s\n' "$pane_list" | grep -qF "$pane|"; then
        rm -f "$f"
    fi
done

while IFS='|' read -r pane ppid window; do
    [ -n "$pane" ] || continue

    # hook-written state wins; only refresh detection-owned files
    if [ -f "$STATE_DIR/$pane.json" ] && ! grep -q '"detected":true' "$STATE_DIR/$pane.json"; then
        harness_in_pane "$ppid" || rm -f "$STATE_DIR/$pane.json"
        continue
    fi

    # skip our own sidebar pane
    if tmux list-panes -a -F '#{pane_id} #{pane_start_command}' 2>/dev/null \
        | grep "^$pane " | grep -q sidebar; then
        continue
    fi

    # agent processes = direct children of the pane's shell
    state=""
    summary=""
    for child in $(pgrep -P "$ppid" 2>/dev/null); do
        comm="$(ps -o comm= -p "$child" 2>/dev/null)"
        case "$comm" in
            nacelle)
                f="$(ls -t "$NACELLE_SESSIONS"/*-"$child".jsonl 2>/dev/null | head -1)"
                if [ -n "$f" ]; then
                    state="$(nacelle_state "$f")"
                    summary="$(last_question "$f")"
                else
                    state="idle"
                fi
                [ -n "$summary" ] || summary="nacelle"
                ;;
            bulle)
                f="$(ls -t "$BULLE_SESSIONS"/*-"$child".jsonl 2>/dev/null | head -1)"
                if [ -n "$f" ]; then
                    state="$(nacelle_state "$f")"
                    summary="$(last_question "$f")"
                else
                    state="idle"
                fi
                [ -n "$summary" ] || summary="bulle"
                ;;
            agy|antigravity)
                state="idle"
                summary="antigravity"
                ;;
        esac
    done

    if [ -n "$state" ]; then
        write_state "$pane" "$state" "$summary" "$window" true "$comm"
    else
        rm -f "$STATE_DIR/$pane.json"
    fi
done <<EOF
$pane_list
EOF