$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/docker.ps1" compose build
if ($LASTEXITCODE -ne 0) { throw "Compose build failed with exit code $LASTEXITCODE" }
