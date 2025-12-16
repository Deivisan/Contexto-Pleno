<#
Generate commands to recreate MCP containers with host port mappings where missing.
This script will create MCPS/Docker/recreate-commands.ps1 with a set of recommended docker run commands
Do not run these commands automatically; review before executing.
#>

Write-Host "Generating recommended recreate commands for MCP containers"
$containersPath = Join-Path $PSScriptRoot '..\MCPS\Docker\containers.json'
if (-not (Test-Path $containersPath)) { Write-Error "containers.json not found"; exit 1 }

$containers = Get-Content $containersPath -Raw | ConvertFrom-Json

$defaultMapping = @{
    'mcp/context7' = 8080;
    'mcp/tavily' = 3000;
    'mcp/server-memory' = 4000;
    'mcp/git' = 5000;
    'mcp/fetch' = 9000;
}

$scriptOut = @()
$scriptOut += "# Recreate commands generated: $(Get-Date -Format o)"
$scriptOut += "# Review before running. These commands will rename existing containers to <name>_backup and run new ones."
$scriptOut += "# Example: docker stop <name>; docker rename <name> <name>_backup; docker run -d --name <name> -p hostPort:containerPort image"

foreach ($c in $containers) {
    $hasBind = $false
    if ($c.HostBindings -and $c.HostBindings.Length -gt 0) { $hasBind = $true }
    if ($hasBind) { continue }
    $image = $c.Image
    $name = $c.Name
    $prefer = $null
    foreach ($k in $defaultMapping.Keys) { if ($image -like "*$k*" -or $name -like "*$k*") { $prefer = $defaultMapping[$k]; break } }
    if (-not $prefer) { continue }
    $containerPort = $null
    if ($c.Ports -and $c.Ports -match '(\d+)\/tcp') { $containerPort = $Matches[1] } else { $containerPort = $prefer }
    $scriptOut += "# Container: $name ($image) - Suggested host port: $prefer -> container port: $containerPort"
    $scriptOut += "docker stop $name || true"
    $scriptOut += "docker rename $name ${name}_backup || true"
    $scriptOut += "docker run -d --name $name -p ${prefer}:${containerPort} $image"
    $scriptOut += ""
}

$outPath = Join-Path $PSScriptRoot '..\MCPS\Docker\recreate-commands.ps1'
$scriptOut | Out-File -FilePath $outPath -Encoding utf8
Write-Host "Wrote $outPath. Review before running."
