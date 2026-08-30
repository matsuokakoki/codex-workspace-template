param([switch]$KeepVolumes)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$docker = Join-Path $PSScriptRoot "docker.ps1"

Push-Location $repoRoot
try {
    if ($KeepVolumes) {
        & $docker compose down --remove-orphans
    } else {
        & $docker compose down --volumes --remove-orphans
    }

    if ($LASTEXITCODE -ne 0) {
        throw "Cleanup failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}
