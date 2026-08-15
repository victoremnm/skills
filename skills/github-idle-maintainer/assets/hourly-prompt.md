Use $github-idle-maintainer for one bounded maintenance pass across the lfefoundation, victoremnm, and abcEDH GitHub organizations.

Inspect all open issues and PRs. Surface work needing human review. Merge only PRs authored by the authenticated GitHub user, after fresh evidence shows the PR is open, non-draft, mergeable, has at least one CI/check and all checks are green, has no CHANGES_REQUESTED review, and has zero unresolved review threads. Revalidate immediately before merging and pass the expected head SHA. Never merge another author's or bot PR. Treat missing CI as not green. Pick up at most one unassigned ready-for-agent issue and open only a draft PR; do not merge work created in this run.

End with counts, merges, human blockers, ready issues, and incomplete coverage.
