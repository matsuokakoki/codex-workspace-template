# Copy this to scripts/project-prepare.ps1 and customize it for the current project.
#
# Examples:
#
# Python:
#   & "$PSScriptRoot\docker.ps1" compose build
#   & "$PSScriptRoot\docker.ps1" compose run --rm dev uv lock
#   & "$PSScriptRoot\docker.ps1" compose run --rm dev uv sync --locked
#
# Node:
#   & "$PSScriptRoot\docker.ps1" compose build
#   & "$PSScriptRoot\docker.ps1" compose run --rm dev npm ci
#
# Firebase:
#   build images and verify Node/Java/Firebase CLI versions here.
#
# Keep everything on/in Docker, not the Windows host.
