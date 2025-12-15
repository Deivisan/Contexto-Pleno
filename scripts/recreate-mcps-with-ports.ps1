<#
Script interativo para recriar containers MCP com portas de host (quando ausentes)
ATENÇÃO: Este script para de forma segura os containers atuais e cria novos com mapeamentos
exemplo, não o rode sem entender. Ele pede confirmação para cada container.
Use: pwsh ./scripts/recreate-mcps-with-ports.ps1
#>

param(
    [switch]$dryRun  # se passado, apenas imprime os comandos sem executar
)

function Write-Info($text) { Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-Warn($text) { Write-Host "[WARN] $text" -ForegroundColor Yellow }
function Write-OK($text) { Write-Host "[OK] $text" -ForegroundColor Green }

$containersPath = Join-Path $PSScriptRoot '..\MCPS\Docker\containers.json'
if (-not (Test-Path $containersPath)) { Write-Warn "containers.json não encontrado. Execute scripts/export-docker-containers.ps1 primeiro."; exit 1 }

$containers = Get-Content $containersPath -Raw | ConvertFrom-Json

# Mapeamento de portas preferenciais por MCP:
$defaultMapping = @{
    'mcp/context7' = 8080;
    'mcp/tavily' = 3000;
    'mcp/server-memory' = 4000;
    'mcp/git' = 5000;
    'mcp/fetch' = 9000;
}

foreach ($c in $containers) {
    $image = $c.Image.ToLower()
    $name = $c.Name
    # detect if it already has host bind via docker inspect
    $inspect = docker inspect $c.ID | ConvertFrom-Json
    $hasHostBind = $false
    $hostPort = $null
    if ($inspect[0].NetworkSettings.Ports) {
        foreach ($p in $inspect[0].NetworkSettings.Ports.psobject.properties) {
            $bindings = $inspect[0].NetworkSettings.Ports.$($p.Name)
            if ($bindings -and $bindings.Length -gt 0 -and $bindings[0].HostPort) { $hasHostBind = $true; $hostPort = $bindings[0].HostPort; break }
        }
    }

    if ($hasHostBind) { Write-OK "$name ($image) já tem host bind em $hostPort"; continue }

    # Decide mapping
    $preferHostPort = $null
    foreach ($k in $defaultMapping.Keys) { if ($image -like "*$k*" -or $name -like "*$k*") { $preferHostPort = $defaultMapping[$k]; break } }
    if (-not $preferHostPort) { $preferHostPort = Read-Host "Escreva port host a mapear para $name (ou Enter para pular)" }
    if (-not $preferHostPort) { Write-Warn "Pulando $name"; continue }

    $containerPort = $null
    if ($c.Ports -and $c.Ports -match '(\d+)\/tcp') { $containerPort = [int]($Matches[1]) }
    if (-not $containerPort) { $containerPort = $preferHostPort }

    $cmd = "docker rename $name ${name}_backup || true; docker run -d --name $name -p ${preferHostPort}:${containerPort} $image"

    Write-Info "Proposta para $name: mapear host $preferHostPort -> container $containerPort na imagem $image"
    if ($dryRun) { Write-Host "[DRYRUN] $cmd" } else {
        $do = Read-Host "Executar? (Y/n)"
        if ($do -eq 'Y' -or $do -eq 'y' -eq $true -or $do -eq '') {
            Write-Info "Parando $name..."
            docker stop $name 2>&1 | Out-Null
            Write-Info "Renomeando $name -> ${name}_backup"
            docker rename $name "${name}_backup" 2>&1 | Out-Null
            Write-Info "Criando novo container com mapeamento $preferHostPort:$containerPort"
            docker run -d --name $name -p ${preferHostPort}:${containerPort} $image
            Write-OK "$name re-criado com host port ${preferHostPort}" 
        } else { Write-Warn "Ignorado $name" }
    }
}

Write-Info "Operação finalizada. Verifique logs e status com docker ps -a";
