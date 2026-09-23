$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/docker.ps1" compose run --rm dev node --test
if ($LASTEXITCODE -ne 0) { throw "Node test failed with exit code $LASTEXITCODE" }
