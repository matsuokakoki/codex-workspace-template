$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $repoRoot "downloads\manifest.json"

if (-not (Test-Path -LiteralPath $manifestPath)) {
    Write-Host "No download manifest; skipping."
    exit 0
}

$items = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json

if (-not $items -or $items.Count -eq 0) {
    Write-Host "No project-specific downloads configured."
    exit 0
}

foreach ($item in $items) {
    if (-not $item.url -or -not $item.path) {
        throw "Each download entry must contain url and path."
    }

    $destination = Join-Path $repoRoot $item.path
    $directory = Split-Path -Parent $destination
    New-Item -ItemType Directory -Force -Path $directory | Out-Null

    if (-not (Test-Path -LiteralPath $destination)) {
        Write-Host "Downloading $($item.url)"
        Invoke-WebRequest -Uri $item.url -OutFile $destination
    } else {
        Write-Host "Already present: $($item.path)"
    }

    if ($item.sha256) {
        $actual = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash.ToLowerInvariant()
        $expected = ([string]$item.sha256).ToLowerInvariant()
        if ($actual -ne $expected) {
            throw "SHA-256 mismatch for $($item.path)"
        }
        Write-Host "SHA-256 verified: $($item.path)"
    }
}
