<#
Test MCP endpoints, health status and collect logs for each container in MCPS/Docker/containers.json
Generates MCPS/Docker/test-results.json and log files in MCPS/Docker/logs/
Usage: pwsh ./scripts/test-mcps.ps1
#>

function Write-Info($text) { Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-Warn($text) { Write-Host "[WARN] $text" -ForegroundColor Yellow }
function Write-OK($text) { Write-Host "[OK] $text" -ForegroundColor Green }

$containersPath = Join-Path $PSScriptRoot '..\MCPS\Docker\containers.json'
if (-not (Test-Path $containersPath)) { Write-Error "containers.json not found. Run export-docker-containers.ps1 first."; exit 1 }

$containers = Get-Content $containersPath -Raw | ConvertFrom-Json
$results = @()
$logDir = Join-Path $PSScriptRoot '..\MCPS\Docker\logs'
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }

foreach ($c in $containers) {
    $rec = [PSCustomObject]@{
        Name = $c.Name
        Image = $c.Image
        ID = $c.ID
        Running = $false
        HostChecks = @()
        ContainerChecks = @()
    }
    # check running
    $inspect = docker inspect $c.ID 2>$null | ConvertFrom-Json
    if ($inspect) { $state = $inspect[0].State; $rec.Running = ($state.Running -eq $true) }

    # try host bindings
    if ($c.HostBindings -and $c.HostBindings.Length -gt 0) {
        foreach ($hb in $c.HostBindings) {
            $hostUrl = "http://localhost:$($hb.HostPort)/"
            try {
                $status = (Invoke-WebRequest -Uri $hostUrl -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop).StatusCode
                $ok = $true
            } catch { $status = $_.Exception.Message; $ok = $false }
            $rec.HostChecks += [PSCustomObject]@{ HostPort = $hb.HostPort; Url = $hostUrl; Status = $status; Ok = $ok }
        }
    }

    # try container-local curl via docker exec using container port
    if ($rec.Running) {
        # iterate exposed ports
        if ($inspect[0].NetworkSettings.Ports) {
            foreach ($p in $inspect[0].NetworkSettings.Ports.psobject.properties) {
                $containerPort = ($p.Name -split '/')[0]
                $cmd = "curl -sS -o /dev/null -w \"%{http_code}\" http://127.0.0.1:$containerPort/"
                try {
                    $out = docker exec $c.ID sh -c $cmd 2>$null
                    $ok = $true
                } catch { $out = $_.Exception.Message; $ok = $false }
                $rec.ContainerChecks += [PSCustomObject]@{ ContainerPort = $containerPort; HttpCode = $out; Ok = $ok }
            }
        }
        # collect logs
        $logFile = Join-Path $logDir "$($c.Name).log"
        docker logs --tail 200 $c.ID 2>&1 | Out-File -FilePath $logFile -Encoding utf8 -Force
        $rec.LogFile = $logFile
    }

    $results += $rec
}

$outFile = Join-Path $PSScriptRoot '..\MCPS\Docker\test-results.json'
$results | ConvertTo-Json -Depth 6 | Out-File -FilePath $outFile -Encoding utf8
Write-Info "Wrote results to $outFile"
