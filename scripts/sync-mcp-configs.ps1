<#
.SYNOPSIS
    Sincroniza configuração MCP universal para todos os agentes
.DESCRIPTION
    Copia a configuração MCP universal para Kiro, Gemini, VS Code, etc.
.EXAMPLE
    pwsh ./scripts/sync-mcp-configs.ps1
#>

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$UniversalConfig = Join-Path $RepoRoot "MCPS\mcp-config-universal.json"

# Cores
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║  🔄 MCP Config Sync - DevSan AI                              ║
║  Sincroniza configuração MCP para todos os agentes           ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Magenta

# Verificar se config universal existe
if (-not (Test-Path $UniversalConfig)) {
    Write-Err "Configuração universal não encontrada: $UniversalConfig"
    exit 1
}

$config = Get-Content $UniversalConfig -Raw | ConvertFrom-Json

# Destinos de configuração
$destinations = @(
    @{
        Name = "Kiro"
        Path = "$env:USERPROFILE\.kiro\settings\mcp.json"
        Transform = $null
    },
    @{
        Name = "Gemini CLI"
        Path = "$env:USERPROFILE\.gemini\settings.json"
        Transform = {
            param($cfg)
            # Gemini usa formato ligeiramente diferente
            @{
                mcpServers = $cfg.mcpServers
            }
        }
    },
    @{
        Name = "VS Code (User)"
        Path = "$env:APPDATA\Code\User\settings.json"
        Transform = {
            param($cfg)
            # VS Code usa mcp.servers
            @{
                "mcp.servers" = $cfg.mcpServers
            }
        }
    },
    @{
        Name = "Kilocode"
        Path = "$env:USERPROFILE\.kilocode\cli\global\settings\mcp_settings.json"
        Transform = $null
    }
)

foreach ($dest in $destinations) {
    Write-Info "Processando $($dest.Name)..."
    
    $destDir = Split-Path -Parent $dest.Path
    if (-not (Test-Path $destDir)) {
        Write-Warn "Diretório não existe, criando: $destDir"
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    
    try {
        if ($dest.Transform) {
            $transformed = & $dest.Transform $config
            
            # Se arquivo existe, fazer merge
            if (Test-Path $dest.Path) {
                $existing = Get-Content $dest.Path -Raw | ConvertFrom-Json -AsHashtable
                foreach ($key in $transformed.Keys) {
                    $existing[$key] = $transformed[$key]
                }
                $transformed = $existing
            }
            
            $transformed | ConvertTo-Json -Depth 10 | Out-File $dest.Path -Encoding utf8
        } else {
            $config | ConvertTo-Json -Depth 10 | Out-File $dest.Path -Encoding utf8
        }
        
        Write-OK "$($dest.Name): $($dest.Path)"
    } catch {
        Write-Warn "$($dest.Name): Falha - $($_.Exception.Message)"
    }
}

Write-Host ""
Write-OK "Sincronização concluída!"
Write-Info "Reinicie os agentes para aplicar as novas configurações."
