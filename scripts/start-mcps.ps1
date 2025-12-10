<#
.SYNOPSIS
    Inicia todos os MCPs via Docker Compose
.DESCRIPTION
    Script para iniciar, parar e gerenciar os MCPs universais
.PARAMETER Action
    start, stop, restart, status, logs, clean
.EXAMPLE
    pwsh ./scripts/start-mcps.ps1 -Action start
#>

param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "restart", "status", "logs", "clean", "pull", "test")]
    [string]$Action = "start"
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DockerDir = Join-Path (Split-Path -Parent $ScriptDir) "MCPS\Docker"
$ComposeFile = Join-Path $DockerDir "docker-compose.yml"
$EnvFile = Join-Path $DockerDir ".env"

# Cores para output
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

# Banner
function Show-Banner {
    Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║  🐳 MCP Universal Manager - DevSan AI                        ║
║  Gerenciador de MCPs via Docker Compose                      ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Magenta
}

# Verificar pré-requisitos
function Test-Prerequisites {
    Write-Info "Verificando pré-requisitos..."
    
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Err "Docker não encontrado. Instale o Docker Desktop."
        exit 1
    }
    
    $dockerInfo = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Docker não está rodando. Inicie o Docker Desktop."
        exit 1
    }
    
    if (-not (Test-Path $ComposeFile)) {
        Write-Err "docker-compose.yml não encontrado em: $ComposeFile"
        exit 1
    }
    
    if (-not (Test-Path $EnvFile)) {
        Write-Warn ".env não encontrado. Criando a partir do exemplo..."
        $exampleEnv = Join-Path $DockerDir ".env.example"
        if (Test-Path $exampleEnv) {
            Copy-Item $exampleEnv $EnvFile
        }
    }
    
    Write-OK "Pré-requisitos OK"
}

# Iniciar MCPs
function Start-MCPs {
    Write-Info "Iniciando MCPs..."
    Push-Location $DockerDir
    try {
        docker compose --env-file $EnvFile up -d
        if ($LASTEXITCODE -eq 0) {
            Write-OK "MCPs iniciados com sucesso!"
            Start-Sleep -Seconds 3
            Get-MCPStatus
        } else {
            Write-Err "Falha ao iniciar MCPs"
        }
    } finally {
        Pop-Location
    }
}

# Parar MCPs
function Stop-MCPs {
    Write-Info "Parando MCPs..."
    Push-Location $DockerDir
    try {
        docker compose down
        Write-OK "MCPs parados"
    } finally {
        Pop-Location
    }
}

# Reiniciar MCPs
function Restart-MCPs {
    Stop-MCPs
    Start-Sleep -Seconds 2
    Start-MCPs
}

# Status dos MCPs
function Get-MCPStatus {
    Write-Info "Status dos MCPs:"
    Write-Host ""
    
    $containers = docker ps -a --filter "name=mcp-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    Write-Host $containers
    
    Write-Host ""
    Write-Info "Portas mapeadas:"
    Write-Host "  context7:         http://localhost:8080"
    Write-Host "  tavily:           http://localhost:3000"
    Write-Host "  memory:           http://localhost:4000"
    Write-Host "  git:              http://localhost:5000"
    Write-Host "  github:           http://localhost:5001"
    Write-Host "  filesystem:       http://localhost:6000"
    Write-Host "  playwright:       http://localhost:7000"
    Write-Host "  desktop-commander: http://localhost:8000"
    Write-Host "  fetch:            http://localhost:9000"
}

# Ver logs
function Get-MCPLogs {
    param([string]$Service = "")
    
    Push-Location $DockerDir
    try {
        if ($Service) {
            docker compose logs -f $Service
        } else {
            docker compose logs -f --tail=50
        }
    } finally {
        Pop-Location
    }
}

# Limpar containers e imagens
function Clear-MCPs {
    Write-Warn "Isso vai remover todos os containers e volumes MCP. Continuar? (y/N)"
    $confirm = Read-Host
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        Push-Location $DockerDir
        try {
            docker compose down -v --remove-orphans
            docker system prune -f
            Write-OK "Limpeza concluída"
        } finally {
            Pop-Location
        }
    }
}

# Atualizar imagens
function Update-MCPImages {
    Write-Info "Atualizando imagens Docker..."
    Push-Location $DockerDir
    try {
        docker compose pull
        Write-OK "Imagens atualizadas"
    } finally {
        Pop-Location
    }
}

# Testar conectividade
function Test-MCPConnectivity {
    Write-Info "Testando conectividade dos MCPs..."
    
    $endpoints = @(
        @{Name="context7"; Port=8080},
        @{Name="tavily"; Port=3000},
        @{Name="memory"; Port=4000},
        @{Name="git"; Port=5000},
        @{Name="github"; Port=5001},
        @{Name="filesystem"; Port=6000},
        @{Name="playwright"; Port=7000},
        @{Name="desktop-commander"; Port=8000},
        @{Name="fetch"; Port=9000}
    )
    
    foreach ($ep in $endpoints) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:$($ep.Port)/health" -TimeoutSec 5 -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                Write-OK "$($ep.Name): OK (porta $($ep.Port))"
            } else {
                Write-Warn "$($ep.Name): Resposta $($response.StatusCode)"
            }
        } catch {
            Write-Err "$($ep.Name): Não acessível (porta $($ep.Port))"
        }
    }
}

# Main
Show-Banner
Test-Prerequisites

switch ($Action) {
    "start" { Start-MCPs }
    "stop" { Stop-MCPs }
    "restart" { Restart-MCPs }
    "status" { Get-MCPStatus }
    "logs" { Get-MCPLogs }
    "clean" { Clear-MCPs }
    "pull" { Update-MCPImages }
    "test" { Test-MCPConnectivity }
}
