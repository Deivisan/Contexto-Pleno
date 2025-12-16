<# DevSan wrapper (Windows pwsh)
   Customize this script to load and run DevSan agent locally.
   Example: call a node script inside the repo: node ./devsan/index.js or run a .NET/py script
#>

param([string[]]$args)

Write-Host "DevSan placeholder — personalize scripts/devsan.ps1 para executar o agente real" -ForegroundColor Green
if ($args.Length -gt 0) { Write-Host "Args: $($args -join ' ')" }
