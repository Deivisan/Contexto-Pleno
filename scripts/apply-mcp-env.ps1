<#
Sets Windows user environment variables (persistently) for MCP endpoints found in Docker containers.
It parses MCPS/Docker/containers.json and, when it finds host-port bindings, creates environment variables like TAVILY_URL, CONTEXT7_URL.
Runs as: pwsh ./scripts/apply-mcp-env.ps1
#>

param()

Write-Host "Applying MCP endpoints to user environment variables (setx)..."
$containersPath = Join-Path -Path $PSScriptRoot -ChildPath '..\MCPS\Docker\containers.json'
if (-not (Test-Path $containersPath)) { Write-Error "containers.json not found: $containersPath"; exit 1 }

$containers = Get-Content $containersPath -Raw | ConvertFrom-Json

function Get-HostPortForContainer($nameOrID) {
    $inspectJson = docker inspect $nameOrID 2>$null | Out-String
    if (-not $inspectJson) { return $null }
    $ins = $inspectJson | ConvertFrom-Json
    $ports = $ins[0].NetworkSettings.Ports
    if (-not $ports) { return $null }
    foreach ($key in $ports.psobject.properties.name) {
        $bindings = $ports.$key
        if ($bindings -and $bindings.Length -gt 0) { return $bindings[0].HostPort }
    }
    return $null
}

foreach ($c in $containers) {
    $image = $c.Image.ToLower()
    $name = $c.Name.ToLower()
    $envName = $null
    if ($image -like '*tavily*' -or $name -like '*tavily*') { $envName = 'TAVILY_URL' }
    elseif ($image -like '*context7*' -or $name -like '*context7*') { $envName = 'CONTEXT7_URL' }
    elseif ($image -like '*server-memory*' -or $name -like '*memory*') { $envName = 'MEMORY_URL' }
    elseif ($image -like '*git-mcp*' -or $name -like '*git*') { $envName = 'GIT_MCP_URL' }
    elseif ($image -like '*fetch*' -or $name -like '*fetch*') { $envName = 'FETCH_MCP_URL' }
    elseif ($image -like '*dockerhub*' -or $name -like '*dockerhub*') { $envName = 'DOCKERHUB_MCP_URL' }
    else { $envName = $null }
    if ($envName) {
        $hostPort = Get-HostPortForContainer($c.ID)
        if ($hostPort) {
            $val = "http://localhost:$hostPort"
            Write-Host "Setting $envName = $val"
            setx $envName $val | Out-Null
        } else {
            # try parse container ports if present (e.g., '8080/tcp') and set docker hostname mapping as fallback
            if ($c.Ports -and $c.Ports -match '\d+/tcp') {
                $containerPort = ($c.Ports -split '/')[0]
                $val = "http://$($c.Name):$containerPort"
                Write-Host "No host binding found; setting $envName = $val (requires network-aware clients or Docker host mapping)"
                setx $envName $val | Out-Null
            } else {
                Write-Host "No port info for $($c.Name). Skipping $envName"
            }
        }
    }
}

Write-Host "Env vars written. Close and re-open your PowerShell to pick them up, or run the following to refresh the session:"
Write-Host "Get-ChildItem Env: | where { $_.Name -match 'TAVILY|CONTEXT7|MEMORY|GIT_MCP|FETCH_MCP|DOCKERHUB_MCP' }"
