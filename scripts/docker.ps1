param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$DockerArgs
)

$ErrorActionPreference = "Stop"

$candidates = New-Object System.Collections.Generic.List[string]

$fromPath = Get-Command docker.exe -ErrorAction SilentlyContinue
if ($fromPath) {
    $candidates.Add($fromPath.Source)
}

if ($env:LOCALAPPDATA) {
    $candidates.Add((Join-Path $env:LOCALAPPDATA "Programs\DockerDesktop\resources\bin\docker.exe"))
    $candidates.Add((Join-Path $env:LOCALAPPDATA "Docker\resources\bin\docker.exe"))
}

if ($env:ProgramFiles) {
    $candidates.Add((Join-Path $env:ProgramFiles "Docker\Docker\resources\bin\docker.exe"))
    $candidates.Add((Join-Path $env:ProgramFiles "Docker\Docker\resources\docker.exe"))
}

$docker = $candidates |
    Where-Object { $_ -and (Test-Path -LiteralPath $_) } |
    Select-Object -First 1

if (-not $docker) {
    throw @"
Docker CLI was not found.
Start Docker Desktop first.
This template intentionally does not install Docker or modify the host PATH.
"@
}

& $docker @DockerArgs
exit $LASTEXITCODE
