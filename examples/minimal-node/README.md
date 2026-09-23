# Minimal Node handoff example

From a fresh repository made from the template, copy this directory's `Dockerfile`, `compose.yaml`, `package.json`, `src/`, `tests/`, and the two PowerShell hooks under `scripts/` to the repository root. Then run `./scripts/prepare-codex.ps1` with Docker Desktop running. The hook builds the image and runs a Node test; a successful run writes `CODEX_HANDOFF.md`.

Expected application output from `docker compose run --rm dev`: `hello from prepared workspace`. The full Docker flow has not been executed in this review environment because Docker CLI is unavailable. Treat this as a runnable example, not a verified result.

2026-09-23にホストのNode.js 22.22.0で `node --test`（1件）と `node src/index.js` を実行し、成功しました。この結果はDocker内での動作確認ではありません。
