$ErrorActionPreference = 'Stop'
$source = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts/prefetch.ps1'
$root = Join-Path ([System.IO.Path]::GetTempPath()) ('codex-prefetch-test-' + [guid]::NewGuid().ToString('N'))
$scripts = Join-Path $root 'scripts'
$downloads = Join-Path $root 'downloads'
New-Item -ItemType Directory -Path $scripts, $downloads | Out-Null
Copy-Item -LiteralPath $source -Destination (Join-Path $scripts 'prefetch.ps1')
$manifest = Join-Path $downloads 'manifest.json'

function Expect-Rejected([object]$item) {
    @($item) | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifest -Encoding utf8
    $failed = $false
    try { & (Join-Path $scripts 'prefetch.ps1') } catch { $failed = $true }
    if (-not $failed) { throw "Expected invalid manifest entry to be rejected: $($item.path)" }
}

try {
    '[]' | Set-Content -LiteralPath $manifest -Encoding utf8
    & (Join-Path $scripts 'prefetch.ps1')
    Expect-Rejected @{ url = 'https://example.com/a'; path = '../outside' }
    Expect-Rejected @{ url = 'http://example.com/a'; path = 'data/a' }
    Expect-Rejected @{ url = 'https://example.com/a'; path = 'data/a'; sha256 = 'invalid' }
    if (Test-Path -LiteralPath (Join-Path $root 'data')) { throw 'Validation created an unexpected download directory' }
    Write-Host 'prefetch validation: empty manifest and 3 rejection cases passed'
}
finally {
    $tempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    $resolved = [System.IO.Path]::GetFullPath($root)
    if (-not $resolved.StartsWith($tempRoot, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Split-Path -Leaf $resolved).StartsWith('codex-prefetch-test-')) { throw 'Unexpected test cleanup path' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
