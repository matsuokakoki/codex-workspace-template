$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$docker = Join-Path $PSScriptRoot "docker.ps1"
$prefetch = Join-Path $PSScriptRoot "prefetch.ps1"
$projectPrepare = Join-Path $PSScriptRoot "project-prepare.ps1"
$projectVerify = Join-Path $PSScriptRoot "project-verify.ps1"
$handoff = Join-Path $repoRoot "CODEX_HANDOFF.md"

function Run-Checked {
    param(
        [string]$Name,
        [scriptblock]$Action
    )
    Write-Host ""
    Write-Host "== $Name =="
    & $Action
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
}

Push-Location $repoRoot
try {
    Run-Checked "Docker Engine" { & $docker version }
    Run-Checked "Docker Compose" { & $docker compose version }

    if (Test-Path -LiteralPath (Join-Path $repoRoot "compose.yaml")) {
        Run-Checked "Compose config" { & $docker compose config }
    } elseif (Test-Path -LiteralPath (Join-Path $repoRoot "docker-compose.yml")) {
        Run-Checked "Compose config" { & $docker compose config }
    } else {
        Write-Host "No Compose file yet. Project setup must add one before handoff if Docker is required."
    }

    if (Test-Path -LiteralPath $projectPrepare) {
        Run-Checked "Project prepare" { & $projectPrepare }
    } else {
        Write-Host "No scripts/project-prepare.ps1; skipping project-specific preparation."
    }

    Run-Checked "Prefetch" { & $prefetch }

    if (Test-Path -LiteralPath $projectVerify) {
        Run-Checked "Project verify" { & $projectVerify }
    } else {
        Write-Host "No scripts/project-verify.ps1; skipping project-specific verification."
    }

    $dockerVersion = (& $docker --version | Out-String).Trim()
    $composeVersion = (& $docker compose version | Out-String).Trim()
    $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"

    $downloadLines = @()
    $manifestPath = Join-Path $repoRoot "downloads\manifest.json"
    if (Test-Path -LiteralPath $manifestPath) {
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
        foreach ($item in $manifest) {
            if ($item.path) {
                $local = Join-Path $repoRoot $item.path
                $status = if (Test-Path -LiteralPath $local) { "present" } else { "missing" }
                $downloadLines += "- ``$($item.path)``: $status"
            }
        }
    }
    if ($downloadLines.Count -eq 0) {
        $downloadLines = @("- No project-specific downloads configured.")
    }

    $content = @"
# Codex Handoff

Generated: $timestamp

## Base environment

- Docker: $dockerVersion
- Compose: $composeVersion
- Docker wrapper: ``.\scripts\docker.ps1``
- Host dependency installation: not part of this workflow

## Project preparation

- ``scripts/project-prepare.ps1``: $(if (Test-Path $projectPrepare) { "executed" } else { "not present" })
- ``scripts/project-verify.ps1``: $(if (Test-Path $projectVerify) { "executed" } else { "not present" })

## Prepared downloads

$($downloadLines -join "`n")

## Codex instruction

The workspace has been prepared before handoff. Do not spend time searching for Docker or installing dependencies on Windows. Begin with the implementation described in README.md.
"@

    Set-Content -LiteralPath $handoff -Value $content -Encoding UTF8

    Write-Host ""
    Write-Host "========================================"
    Write-Host "READY FOR CODEX"
    Write-Host "========================================"
    Write-Host "Generated CODEX_HANDOFF.md"
}
finally {
    Pop-Location
}
