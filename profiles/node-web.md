# Profile: Node / Web

Typical additions before Codex starts:

- pinned Node version
- npm/pnpm/yarn based on the repository
- lockfile present before using clean-install commands
- browser/Playwright dependencies only if needed
- lint/typecheck/test commands
- local services in Compose where appropriate

Avoid letting Codex discover package-manager/lockfile mismatches after implementation begins.
