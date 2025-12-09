<#
Generates a human-readable MCPS/Docker/PORTS.md based on containers.json
#>

Write-Host "Generating MCPS Docker ports report"
$containersPath = Join-Path $PSScriptRoot '..\MCPS\Docker\containers.json'
if (-not (Test-Path $containersPath)) { Write-Error "containers.json not found"; exit 1 }

$containers = Get-Content $containersPath -Raw | ConvertFrom-Json

$out = @()
$out += "# MCPs Port Mapping"
$out += "Generated: $(Get-Date -Format o)"
$out += ""
$out += "| Container Name | Image | Ports | Host Bind | Status |"
$out += "|---|---|---|---|---|"
foreach ($c in $containers) {
    $inspect = docker inspect $c.ID | ConvertFrom-Json
    $hostBind = $null
    if ($inspect[0].NetworkSettings.Ports) {
        foreach ($p in $inspect[0].NetworkSettings.Ports.psobject.properties) {
            $bindings = $inspect[0].NetworkSettings.Ports.$($p.Name)
            if ($bindings -and $bindings.Length -gt 0) { $hostBind = $bindings[0].HostPort; break }
        }
    }
    if (-not $hostBind) { $hostBind = "(none)" }
    $out += "| $($c.Name) | $($c.Image) | $($c.Ports) | $hostBind | $($c.Status) |"
}

[IO.File]::WriteAllLines("$PSScriptRoot\..\MCPS\Docker\PORTS.md", $out)
Write-Host "Wrote MCPS/Docker/PORTS.md"
