Use $github-idle-maintainer for one bounded maintenance pass. Read the comma-separated organization scope from the inherited `IDLE_ORGS` environment variable. Refuse to operate if it is absent or empty.

UNATTENDED SAFETY: This scheduled pass is read-only. Never call merge_pull_request, enable_auto_merge, update_ref, create_pull_request, or any other mutation. Report mechanically eligible candidates for an interactive agent to revalidate and merge.

Inspect all open issues and PRs. Surface work needing human review. Assess merge candidates only when authored by the authenticated GitHub user and fresh evidence shows the PR is open, non-draft, mergeable, has at least one CI/check and all checks are green, has no CHANGES_REQUESTED review, and every review thread has is_resolved=true. A thread with is_resolved=false blocks candidacy even when outdated. Treat missing CI as not green. Do not pick up issues or create draft PRs in an unattended pass; list ready-for-agent issues for interactive pickup.

End with counts, merge candidates (not merges), human blockers, ready issues, and incomplete coverage.
