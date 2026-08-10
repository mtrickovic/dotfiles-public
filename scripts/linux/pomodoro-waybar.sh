#!/usr/bin/env bash
# Waybar Pomodoro module — 20/50/90 min work sessions with auto-breaks.

set -uo pipefail

CACHE_DIR="$HOME/.cache/waybar-pomodoro"
STATE_FILE="$CACHE_DIR/state"
PID_FILE="$CACHE_DIR/pid"
SIGNAL_NUM=8
LAUNCHER="rofi -dmenu"
PROMPT_FLAG="-p"

mkdir -p "$CACHE_DIR"

now() { date +%s; }

break_for() {
  case "$1" in
    20) echo 5 ;;
    50) echo 15 ;;
    90) echo 30 ;;
    *) echo "$(($1 / 4))" ;;
  esac
}

read_state() {
  if [[ -f "$STATE_FILE" ]]; then
    cat "$STATE_FILE"
  else
    echo "idle 0 0"
  fi
}

current_end() {
  local _ end _
  read -r _ end _ <<<"$(read_state)"
  echo "${end:-0}"
}

write_state() {
  echo "$1 $2 $3" >"$STATE_FILE"
}

notify_waybar() {
  pkill -RTMIN+"$SIGNAL_NUM" waybar 2>/dev/null || true
}

notify() {
  if command -v notify-send &>/dev/null; then
    notify-send -a "Waybar Pomodoro" "Pomodoro Timer" "$1"
  fi
}

stop_timer() {
  if [[ -f "$PID_FILE" ]]; then
    local pid
    pid="$(cat "$PID_FILE")"
    kill "$pid" 2>/dev/null || true
    rm -f "$PID_FILE"
  fi
  write_state "idle" 0 0
  notify_waybar
}

run_cycle() {
  local work_mins="$1"
  local break_mins
  break_mins="$(break_for "$work_mins")"

  while true; do
    local end=$(($(now) + work_mins * 60))
    write_state "running" "$end" "work"
    notify_waybar
    sleep "$((work_mins * 60))"
    [[ "$(current_end)" == "$end" ]] || return
    notify "Focus session done — ${break_mins} min break 🎉"

    end=$(($(now) + break_mins * 60))
    write_state "running" "$end" "break"
    notify_waybar
    sleep "$((break_mins * 60))"
    [[ "$(current_end)" == "$end" ]] || return
    notify "Break's over — back to focus 󱎫 "
  done
}

start_timer() {
  local minutes="$1"
  stop_timer
  (run_cycle "$minutes") &
  echo $! >"$PID_FILE"
  disown
}

show_status() {
  read -r status end phase <<<"$(read_state)"
  if [[ "$status" == "running" ]]; then
    local remaining=$((end - $(now)))
    ((remaining < 0)) && remaining=0
    local mins=$((remaining / 60))
    local secs=$((remaining % 60))
    local tip="Focus session — right-click to stop"
    local cls="work"
    if [[ "$phase" != "work" ]]; then
      tip="Break — right-click to stop"
      cls="break"
    fi
    printf '{"text":"%02d:%02d","tooltip":"%s","class":"%s"}\n' \
      "$mins" "$secs" "$tip" "$cls"
  else
    local tip="Click to start a pomodoro (20 / 50 / 90 min)"
    printf '{"text":"Idle","tooltip":"%s","class":"idle"}\n' "$tip"
  fi
}

show_menu() {
  local menu_opts="20 min\n50 min\n90 min\nStop"
  local choice
  choice=$(printf "%b" "$menu_opts" | $LAUNCHER $PROMPT_FLAG "Pomodoro")
  case "$choice" in
    "20 min") start_timer 20 ;;
    "50 min") start_timer 50 ;;
    "90 min") start_timer 90 ;;
    "Stop") stop_timer ;;
    *) ;;
  esac
}

case "${1:-}" in
  status) show_status ;;
  menu) show_menu ;;
  stop) stop_timer ;;
  start) start_timer "${2:?minutes required, e.g. start 50}" ;;
  *)
    echo "Usage: $0 {status|menu|stop|start MINUTES}" >&2
    exit 1
    ;;
esac
