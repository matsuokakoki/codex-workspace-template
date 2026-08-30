# codex-workspace-template

A reusable, **language-agnostic** starter for handing heavy implementation work to Codex without wasting tokens on environment discovery.

The guiding rule is:

> Prepare the environment, dependencies, downloads, and baseline checks **before** Codex starts. Then hand Codex a workspace where it can begin implementation immediately.

This repository intentionally does **not** hard-code Python, Node.js, Firebase, LaTeX, CUDA, or any specific stack. Add only what the current project needs.

## What stays common across projects

These files are intended to be reused:

- `AGENTS.md`
- `CODEX_START_PROMPT.txt`
- `scripts/docker.ps1`
- `scripts/prefetch.ps1`
- `scripts/prepare-codex.ps1`
- `scripts/clean.ps1`
- `docs/PRE_CODEX_CHECKLIST.md`

## What changes per project

Usually customize or create:

- `README.md` — the actual project specification
- `Dockerfile`
- `compose.yaml`
- dependency/lock files (`pyproject.toml`, `uv.lock`, `package.json`, `package-lock.json`, etc.)
- `scripts/project-prepare.ps1`
- `scripts/project-verify.ps1`
- `downloads/manifest.json`

## Standard workflow

1. Create a new repository from this template.
2. Decide the project stack with ChatGPT.
3. Add only the Docker/runtime/dependencies/services the project needs.
4. Identify public datasets, model files, archives, browser binaries, etc. that can be fetched in advance.
5. Put known public downloads in `downloads/manifest.json`.
6. Make `scripts/project-prepare.ps1` and `scripts/project-verify.ps1` project-specific.
7. Start Docker Desktop.
8. Run:

```powershell
.\scripts\prepare-codex.ps1
```

9. Do **not** start Codex until the script ends with:

```text
READY FOR CODEX
```

10. Open the project in Codex and paste `CODEX_START_PROMPT.txt`.

## Docker wrapper

Codex must not waste time searching for Docker.

Use:

```powershell
.\scripts\docker.ps1 compose ps
```

The wrapper finds Docker Desktop from PATH, the per-user installation, or the standard system-wide installation.

## Project-specific hooks

`prepare-codex.ps1` automatically calls these if they exist:

```text
scripts/project-prepare.ps1
scripts/project-verify.ps1
```

Examples:

- Python research: lock/sync with uv, install LaTeX inside Docker, verify imports, run pytest.
- Next.js: `npm ci`, Playwright dependencies, lint, typecheck, smoke test.
- Firebase: Node + Java + Firebase CLI, emulator boot check.
- GPU ML: CUDA image, PyTorch import, `nvidia-smi`, model/data prefetch.

These hooks are intentionally project-specific instead of forcing one universal environment.

## Safe cleanup

```powershell
.\scripts\clean.ps1
```

To preserve named volumes:

```powershell
.\scripts\clean.ps1 -KeepVolumes
```

Avoid routine use of `docker system prune` because it can affect unrelated projects.
