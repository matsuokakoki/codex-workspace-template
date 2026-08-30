# Codex Workspace Rules

## Read first

1. Read `README.md` completely.
2. Read `CODEX_HANDOFF.md` if present.
3. Treat the project README/specification as authoritative.

## Environment discipline

- The workspace is prepared before Codex starts.
- Do not search the filesystem for Docker.
- Do not invoke bare `docker`.
- Always use `.\scripts\docker.ps1`.
- Do not install project runtimes, compilers, package managers, databases, browser tooling, LaTeX, CUDA tooling, or project dependencies directly on the Windows host.
- Use the existing Docker/Compose environment.
- Do not redesign the environment unless implementation genuinely requires a new dependency.
- Declare any new dependency in the appropriate project file and keep it inside Docker.

## Work discipline

- Focus on implementation, tests, debugging, experiments, and deliverables.
- Reuse downloads/assets already listed in `CODEX_HANDOFF.md`.
- Do not repeatedly download large assets.
- Do not fabricate data, results, benchmarks, citations, files, or passing test status.
- Do not weaken tests merely to make them pass.
- Run the project's defined quality checks before claiming completion.
- Preserve reproducibility when relevant.

## Completion

The task is complete only when the project's own Definition of Done is satisfied.
