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

    $relative = [string]$item.path
    if ([System.IO.Path]::IsPathRooted($relative) -or $relative -match '(^|[\\/])\.\.([\\/]|$)' -or $relative -match '^[A-Za-z]:') {
        throw "Download path must be repository-relative without '..': $relative"
    }
    $rootFull = [System.IO.Path]::GetFullPath($repoRoot)
    $destination = [System.IO.Path]::GetFullPath((Join-Path $rootFull $relative))
    if (-not $destination.StartsWith($rootFull + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Download destination is outside the repository: $relative"
    }
    $uri = $null
    if (-not [System.Uri]::TryCreate([string]$item.url, [System.UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -ne 'https') {
        throw "Download URL must be HTTPS: $($item.url)"
    }
    if ($item.sha256 -and [string]$item.sha256 -notmatch '^[0-9a-fA-F]{64}$') {
        throw "SHA-256 must be 64 hexadecimal characters: $relative"
    }
    $cursor = $rootFull
    foreach ($part in ($relative -split '[\\/]')) {
        $cursor = Join-Path $cursor $part
        if (Test-Path -LiteralPath $cursor) {
            $attrs = (Get-Item -LiteralPath $cursor -Force).Attributes
            if ($attrs -band [System.IO.FileAttributes]::ReparsePoint) {
                throw "Download path contains a symlink or reparse point: $relative"
            }
        }
    }
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
