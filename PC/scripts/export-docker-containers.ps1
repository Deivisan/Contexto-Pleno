<#
Script to export docker containers metadata to MCPS/Docker/containers.json
Run as: pwsh ./scripts/export-docker-containers.ps1
#>

Write-Host "Exporting docker container info to MCPS/Docker/containers.json"
$lines = docker ps -a --format '{{.ID}}|{{.Image}}|{{.Names}}|{{.Ports}}|{{.Status}}'
$arr = @()
foreach ($l in $lines) {
    $parts = $l -split '\|'
    $obj = [PSCustomObject]@{
        ID = $parts[0]
        Image = $parts[1]
        Name = $parts[2]
        Ports = $parts[3]
        Status = $parts[4]
        HostBindings = @()
    }
    # inspect to find host bindings
    try {
        $inspect = docker inspect $parts[0] | ConvertFrom-Json
        if ($inspect -and $inspect[0].NetworkSettings.Ports) {
            foreach ($p in $inspect[0].NetworkSettings.Ports.psobject.properties) {
                $portsArr = $inspect[0].NetworkSettings.Ports.$($p.Name)
                if ($portsArr) {
                    foreach ($b in $portsArr) { $obj.HostBindings += [PSCustomObject]@{ ContainerPort = $p.Name; HostIP = $b.HostIp; HostPort = $b.HostPort } }
                }
            }
        }
    } catch { }
    $arr += $obj
}

$outPath = Join-Path -Path $PSScriptRoot -ChildPath '..\MCPS\Docker\containers.json'
$arr | ConvertTo-Json -Depth 6 | Out-File -FilePath $outPath -Encoding utf8
Write-Host "Wrote $outPath"
