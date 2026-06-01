#!/bin/bash
set -euo pipefail

WIN_ID=$(xdotool search --classname "ChatGPT" 2>/dev/null | head -n 1 || true)

if [ -n "${WIN_ID:-}" ]; then
  i3-msg "[id=$WIN_ID] focus" >/dev/null
else
    google-chrome --class=ChatGPT --app=https://chatgpt.com >/dev/null 2>&1 &
  fi
fi
