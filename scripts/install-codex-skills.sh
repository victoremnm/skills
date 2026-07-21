#!/usr/bin/env bash
set -euo pipefail

# Symlink every skill in this repo into the Codex / Agent-Skills directory
# (~/.agents/skills). Each entry is a symlink into this repo, so a `git pull`
# keeps the installed skills up to date.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CODEX_SKILLS_DIR="${HOME}/.agents/skills"

mkdir -p "$CODEX_SKILLS_DIR"

for skill_md in "$REPO_ROOT"/skills/*/SKILL.md; do
    [[ -f "$skill_md" ]] || continue
    src="$(dirname "$skill_md")"
    name="$(basename "$src")"
    target="$CODEX_SKILLS_DIR/$name"
    rm -rf "$target"
    ln -s "$src" "$target"
    echo "Linked: $name -> $src"
done

echo
echo "Codex skills installed in $CODEX_SKILLS_DIR"
