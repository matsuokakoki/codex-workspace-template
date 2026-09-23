# Codex workspace template

Prepare a project workspace before handing an implementation task to Codex. This is a **template**, not an application or benchmark. It supplies PowerShell wrappers, a download manifest, and a handoff checklist; each new project must add its own code, environment, and verification.

**Status:** usable starting point. Docker-based end-to-end preparation depends on a project-specific Compose file and Docker Desktop. No performance or time savings have been measured.

## What is included

| Path | Purpose |
| --- | --- |
| `scripts/docker.ps1` | Find a local Docker CLI without editing the host PATH |
| `scripts/prefetch.ps1` | Download declared public static inputs and verify optional SHA-256 |
| `scripts/prepare-codex.ps1` | Run Docker checks, project hooks, prefetch, and write `CODEX_HANDOFF.md` |
| `scripts/clean.ps1` | Stop the project's Compose services; default also removes named volumes |
| `downloads/manifest.json` | Empty by default; add only public URLs and repository-relative paths |
| `scripts/project-*.example.ps1` | Examples to adapt into project-specific hooks |
| `profiles/` | Planning notes for common project stacks; not installed dependencies |
| `AGENTS.md`, `CODEX_START_PROMPT.txt` | Reusable agent handoff instructions |

## Use in a new project

1. Create a new repository from this template. Write the project's actual goal, inputs, and Definition of Done in its README.
2. Choose a runtime and add its Dockerfile, `compose.yaml` or `docker-compose.yml`, and lockfiles. Adapt the example project hooks if needed.
3. Declare only public static downloads in `downloads/manifest.json`. Prefer SHA-256 checksums; never put credentials or signed URLs there.
4. Start Docker Desktop and run `./scripts/prepare-codex.ps1` from PowerShell. Review the generated `CODEX_HANDOFF.md` before starting Codex.
5. Hand the project README and `CODEX_HANDOFF.md` to Codex. Run the project's own tests before claiming completion.

`READY FOR CODEX` means the template's checks completed in that environment. It does **not** mean the project or its tests are complete. Without Docker, `prepare-codex.ps1` cannot finish; `prefetch.ps1` can still be checked separately with an empty manifest.

## Cleanup and limits

`./scripts/clean.ps1` runs Compose `down --volumes --remove-orphans` and removes **the project's named volumes**. To keep those volumes, run `./scripts/clean.ps1 -KeepVolumes`. Review the Compose project before using either command. The template does not call `docker system prune`.

`prefetch.ps1` rejects paths outside the repository, symlink/reparse-point parents, non-HTTPS URLs, and malformed SHA-256 values. It cannot verify the trustworthiness or licence of downloaded content. Review each data source before distributing a derived project. See [manifest format](downloads/README.md).

## Public portfolio value

The interesting design choice is the separation of host preparation from implementation: a checked handoff file records which environment and inputs were actually prepared. This repository has no shipped product, CI, or measured productivity result. Its scripts and generic prompts may be reused in a project after adapting them to that project's constraints.
