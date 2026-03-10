#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AGENT_DIRS=(
  "$HOME/.cursor/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
)

for agent_dir in "${AGENT_DIRS[@]}"; do
  mkdir -p "$agent_dir"
done

linked=0
skipped=0

for skill_dir in "$SCRIPT_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"

  for agent_dir in "${AGENT_DIRS[@]}"; do
    target="$agent_dir/$skill_name"

    if [ -L "$target" ]; then
      existing="$(readlink "$target")"
      if [ "$existing" = "$skill_dir" ] || [ "$existing" = "${skill_dir%/}" ]; then
        skipped=$((skipped + 1))
        continue
      fi
      rm "$target"
    elif [ -e "$target" ]; then
      echo "warning: $target exists and is not a symlink — skipping"
      skipped=$((skipped + 1))
      continue
    fi

    ln -s "$skill_dir" "$target"
    echo "linked: $target -> $skill_dir"
    linked=$((linked + 1))
  done
done

echo ""
echo "done — $linked linked, $skipped skipped"
