#!/usr/bin/env bash

# Show stats with scrollable pager
# Use less with options: -R (raw control chars), -X (no termcap init), -S (chop long lines)
# Navigation: j/k (up/down), q/ESC (quit), space/b (page up/down), g/G (top/bottom)
~/mybins/wisp stats | less -RXS