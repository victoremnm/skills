claude_skills_dir := env_var('HOME') / ".claude/skills"
codex_skills_dir := env_var('HOME') / ".agents/skills"

default:
    @just --list

install skill="":
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "{{ claude_skills_dir }}"
    skill="{{ skill }}"
    if [[ -n "$skill" ]]; then
        if [[ -d "skills/$skill" && -f "skills/${skill}/SKILL.md" ]]; then
            rm -rf "{{ claude_skills_dir }}/${skill}"
            ln -sf "$(pwd)/skills/${skill}" "{{ claude_skills_dir }}/${skill}"
            echo "Installed: ${skill}"
        else
            echo "Error: skills/${skill}/SKILL.md not found"
            exit 1
        fi
    else
        echo "Installing all skills..."
        for d in skills/*/; do
            d="${d#skills/}"; d="${d%/}"
            [[ -f "skills/${d}/SKILL.md" ]] || continue
            rm -rf "{{ claude_skills_dir }}/${d}"
            ln -sf "$(pwd)/skills/${d}" "{{ claude_skills_dir }}/${d}"
            echo "Installed: ${d}"
        done
        echo ""
        echo "Done! Skills are symlinked and will auto-update on git pull."
    fi

install-codex:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "{{ codex_skills_dir }}"
    "$(pwd)/scripts/install-codex-skills.sh"

uninstall skill="":
    #!/usr/bin/env bash
    set -euo pipefail
    skill="{{ skill }}"
    if [[ -n "$skill" ]]; then
        rm -rf "{{ claude_skills_dir }}/${skill}"
        echo "Uninstalled: ${skill}"
    else
        echo "Uninstalling all skills..."
        for d in skills/*/; do
            d="${d#skills/}"; d="${d%/}"
            [[ -f "skills/${d}/SKILL.md" ]] || continue
            rm -rf "{{ claude_skills_dir }}/${d}"
            echo "Uninstalled: ${d}"
        done
        echo "Done!"
    fi

list:
    #!/usr/bin/env bash
    echo "Available skills:"
    for d in skills/*/; do
        d="${d#skills/}"; d="${d%/}"
        [[ -f "skills/${d}/SKILL.md" ]] || continue
        echo "  ${d}"
    done
