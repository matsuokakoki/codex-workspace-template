# Pre-Codex Checklist

Before launching Codex for a heavy project:

- [ ] Decide whether Docker isolation is appropriate.
- [ ] Identify required runtimes (Python, Node, Java, etc.).
- [ ] Identify required system packages.
- [ ] Identify package-manager dependencies and lockfiles.
- [ ] Identify Compose services (Postgres, Redis, Firebase emulator, etc.).
- [ ] Identify GPU/CUDA requirements if any.
- [ ] Identify public datasets/models/archives that can be downloaded in advance.
- [ ] Identify secrets/authentication that must not be committed.
- [ ] Create/update Dockerfile and compose.yaml.
- [ ] Create/update `scripts/project-prepare.ps1`.
- [ ] Create/update `scripts/project-verify.ps1`.
- [ ] Build successfully.
- [ ] Generate/verify lockfiles.
- [ ] Pre-download known public assets.
- [ ] Run baseline tests/import/type/lint/smoke checks.
- [ ] Generate `CODEX_HANDOFF.md`.
- [ ] Only then open Codex.

Goal:

> Codex begins at implementation, not environment discovery.
