Use $github-idle-maintainer for one bounded maintenance report.

UNATTENDED SAFETY: This scheduled pass is read-only. The GitHub snapshot below was produced by deterministic collector code that performs only fixed reads. Connected apps are disabled and the filesystem sandbox is read-only. Never attempt any external lookup, GitHub mutation, issue pickup, draft creation, merge, or ref update.

Analyze only the supplied `github_snapshot`. Surface work needing human review. Treat a PR as a mechanical merge candidate only when `mechanical_candidate` is true. Never override the collector's decision. A thread with `is_resolved=false` blocks candidacy even when outdated, missing CI is not green, and human-hold markers block candidacy.

End with organization counts, mechanical candidates (not merges), human blockers, ready issues, collection errors, and incomplete coverage.
