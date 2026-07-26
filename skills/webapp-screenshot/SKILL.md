---
name: webapp-screenshot
description: Capture before/after screenshots of web app surfaces as PR evidence. USE WHEN you need visual proof of a UI change, want to show before/after states in a PR, or need to document a web interface with committed screenshots.
version: 1.0.0
---

# WebApp Screenshot — PR Evidence Capture

Capture screenshots of a running dev server and commit them as visual evidence in PRs. Follows the pattern from attention-terminal's PR evidence workflow: screenshots are committed to `docs/pr-evidence/`, embedded in the PR body with commit-pinned raw URLs, and described in a "Before / after proof" section.

## Quick Start

```bash
# Install Playwright ephemerally; do not add evidence tooling to the target app
npm install --no-save --no-package-lock playwright

# Do not commit package.json, package-lock.json, or node_modules changes from this step

# Install browser
npx --no-install playwright install chromium
```

## Screenshot Script

Save this as `scripts/screenshot.mjs`:

```javascript
import { chromium } from 'playwright';
import { writeFileSync, mkdirSync } from 'fs';

const URL = process.argv[2];
const OUTPUT = process.argv[3] || 'screenshot.png';

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto(URL, { waitUntil: 'networkidle' });
await page.waitForTimeout(1000);
await page.screenshot({ path: OUTPUT, fullPage: false });
await browser.close();
console.log(`Saved: ${OUTPUT}`);
```

Usage:

```bash
node scripts/screenshot.mjs http://localhost:3000/trending docs/pr-evidence/trending-attention-mode.png
```

## PR Evidence Workflow

1. **Capture the baseline before editing** — check out the base branch in a separate worktree (or save the current base commit), start its dev server, and take the before screenshots. Keep those files outside the feature worktree temporarily.
2. **Implement the change** on a feature branch.
3. **Start the feature server** — `npm run dev` (or whatever the project's dev command is).
4. **Take after screenshots** showing the new behavior. Capture each mode, panel state, or interaction that reviewers need to see.
5. **Copy both baseline and after screenshots** into `docs/pr-evidence/` on the feature branch and commit them:

    ```
    docs/pr-evidence/trending-attention-mode.png
    docs/pr-evidence/trending-active-commits-mode-with-filters-panel.png
    ```

    Name files descriptively — `{surface}-{state}.png` — so a reader can tell what each screenshot shows without opening it.

6. **Embed in the PR body** using commit-pinned raw URLs:

    ```markdown
    ![Attention mode](https://raw.githubusercontent.com/OWNER/REPO/COMMIT_HASH/docs/pr-evidence/trending-attention-mode.png)
    ```

    Pin to the commit hash that added the screenshot so the URL doesn't break if `main` moves. Use the full 40-char SHA.

7. **Write the "Before / after proof" section**:

    ```markdown
    ### Before / after proof

    - Before: what was broken or missing
    - After: what the reviewer can now observe
    - Evidence: the embedded screenshots above, taken against the live dev server
    ```

## Example

From attention-terminal PR #170 (trending page ranking modes):

| State | File | Description |
|-------|------|-------------|
| Attention mode | `trending-attention-mode.png` | Default ranking mode with sortable columns |
| Active commits + filters panel | `trending-active-commits-mode-with-filters-panel.png` | Active ranking mode with Filters & Columns panel open |

The "Before / after proof" section read:

> - Before: `/trending` showed one static ranking (event volume), with a search box but no sort control, no column visibility, and no way to see commits/pushes rankings.
> - After: five selectable ranking modes, sortable/filterable columns with persisted preferences, and a working `/api/trending-active` endpoint for the anti-noise commits/pushes rankings.
> - Evidence: the two screenshots above, taken against the live ClickHouse-backed dev server (not mocked data).

## Naming Convention

```
docs/pr-evidence/{surface}-{variant}.png
```

- `surface` — the route or component (e.g. `trending`, `chat`, `dashboard`)
- `variant` — what the screenshot demonstrates (e.g. `attention-mode`, `filters-panel-open`, `empty-state`, `error-state`)

Avoid PR-number-based naming — screenshots should be meaningful without knowing which PR they belong to.

## Best Practices

- **Capture against live data, not mocked.** A screenshot of real data proves the integration works. If data is sensitive, use a dev/staging environment.
- **One concept per screenshot.** Don't cram multiple states into one image. If there are three modes, take three screenshots.
- **Set a consistent viewport.** `1280x800` is a good default. Note the viewport in the PR body if it matters.
- **Wait for network idle + settle.** Use `waitUntil: 'networkidle'` and `waitForTimeout(1000)` after navigation to let JS render.
- **Full page vs viewport.** Use `fullPage: false` for screenshots that match what a user sees. Use `fullPage: true` only when the full scrollable content is the point.
- **Commit screenshots on the feature branch.** Don't push to `main` directly. Let the PR review verify the screenshots match the code.

## Not this skill

- Not for one-off debugging screenshots — those go in local `screenshots/` or are discarded.
- Not for recording screen interactions as GIFs or video — use a dedicated recording tool.
- Not for documenting a running production service — use the service's own monitoring.
- Not for addressing review feedback on a PR; that is [`address-feedback`](../address-feedback/SKILL.md).
- Not for polling a PR to merge; that is [`watch-pr`](../watch-pr/SKILL.md).
