#!/usr/bin/env bash
# egg-install.sh – clone + install egg

set -euo pipefail
IFS=$'\n\t'

echo "ℹ️  Installing egg (tmux layout manager)…"

# ─── check deps ──────────────────────────────────────────────────────────────
command -v git >/dev/null || {
  echo "❌  git not found."
  exit 1
}
command -v bash >/dev/null || {
  echo "❌  bash not found."
  exit 1
}

TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

git clone --depth 1 https://github.com/saravenpi/egg.git "$TMPDIR/egg"

chmod +x "$TMPDIR/egg/install.sh"
bash "$TMPDIR/egg/install.sh"

echo "✅  egg installed successfully."
