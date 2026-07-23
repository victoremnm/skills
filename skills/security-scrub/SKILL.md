---
name: security-scrub
description: Run a grep-based security audit on changed files before pushing. USE WHEN the user says "security scrub", "secret scan", "pre-push check", "scan for secrets", OR wants a quick review of changed files for obvious security issues.
version: 1.0.0
---

# Security Scrub

Fast pre-push security audit for changed files.

## Run

```bash
bash "$HOME/.claude/skills/security-scrub/scan.sh"
bash "$HOME/.claude/skills/security-scrub/scan.sh" --staged
bash "$HOME/.claude/skills/security-scrub/scan.sh" --head
bash "$HOME/.claude/skills/security-scrub/scan.sh" --all
```

## Workflow

1. Run the scanner on staged files or the recent diff.
2. Stop immediately on any `BLOCK`.
3. For each `WARN`, read nearby lines and classify it as real risk or false positive.
4. Push only when remaining warnings are understood and accepted.

## Meaning

- `BLOCK`: fix before pushing
- `WARN`: inspect context
- `PASS`: no action needed

## Checks

- hardcoded secrets
- hardcoded public IPs
- localhost URLs in non-test files
- unquoted shell variables
- missing `.gitignore` patterns for sensitive files
- prompt strings with raw API response interpolation
- npm or Cargo typosquats and unpinned versions

## Optional Automation

```bash
cat > .git/hooks/pre-push << 'EOF'
#!/usr/bin/env bash
SCAN="$HOME/.claude/skills/security-scrub/scan.sh"
[[ -f "$SCAN" ]] && bash "$SCAN" --head || exit 0
EOF
chmod +x .git/hooks/pre-push
```

## Not this skill

- Not a full dependency or supply-chain audit; it is grep-based and scoped to obvious secrets/patterns.
- Not for code-quality or review feedback; that is [`address-feedback`](../address-feedback/SKILL.md) and [`watch-pr`](../watch-pr/SKILL.md).
- Not for documentation scaffolding; that is [`repo-docs-audit`](../repo-docs-audit/SKILL.md).
