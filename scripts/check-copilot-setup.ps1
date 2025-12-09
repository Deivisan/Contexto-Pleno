<#
Inspeciona as configurações do VS Code (Insiders e Stable) relacionadas ao GitHub Copilot
e recomenda/ajusta a seleção do modelo quando necessário.

Usage:
  pwsh ./scripts/check-copilot-setup.ps1            # Executa a checagem (Insiders por padrão)
  pwsh ./scripts/check-copilot-setup.ps1 -AutoFix   # Tenta aplicar correção (faça backup primeiro)
  pwsh ./scripts/check-copilot-setup.ps1 -ModelToSet "gpt-4o" -UseStable
#>

param(
    [switch]$AutoFix,
    [string]$ModelToSet = "gpt-4o",
    [switch]$UseStable
)

function Write-Info($text) { Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-Warn($text) { Write-Host "[WARN] $text" -ForegroundColor Yellow }
function Write-ErrorAndExit($text) { Write-Host "[ERROR] $text" -ForegroundColor Red; exit 1 }

Write-Info "Detectando settings.json do VS Code..."
$appdata = [Environment]::GetFolderPath('ApplicationData')
$settingsPath = if ($UseStable) { Join-Path $appdata 'Code\User\settings.json' } else { Join-Path $appdata 'Code - Insiders\User\settings.json' }

if (-not (Test-Path $settingsPath)) {
    Write-Warn "settings.json não encontrado em: $settingsPath"
    Write-Warn "Se você usa Win32 VS Code (stable), tente executar com -UseStable"
    exit 0
}

Write-Info "Carregando $settingsPath"
try {
    $raw = Get-Content -Raw -Path $settingsPath
    $json = $raw | ConvertFrom-Json -ErrorAction Stop
} catch {
    Write-Warn "Não foi possível parsear settings.json. Faça backup e corrija manualmente."
    exit 1
}

function Get-CopilotSettings($json) {
    $keys = @()
    foreach ($prop in $json.psobject.properties) { if ($prop.name -like 'github.copilot*') { $keys += @{Name=$prop.name; Value=$prop.Value } } }
    return $keys
}

$copilotSettings = Get-CopilotSettings $json
if (-not $copilotSettings) {
    Write-Warn "Nenhuma configuração do GitHub Copilot encontrada em settings.json"
} else {
    Write-Info "Configurações do Copilot encontradas:"; $copilotSettings | ForEach-Object { Write-Host "  $_.Name : $($_.Value)" }
}

# Checa especificamente seleção de modelos
$modelsFound = @()
if ($json.'github.copilot.chat.models') { $modelsFound = $json.'github.copilot.chat.models' }
elseif ($json.'github.copilot.chat.model') { $modelsFound = @($json.'github.copilot.chat.model') }

if ($modelsFound -and $modelsFound.Length -gt 0) {
    Write-Info "Modelos configurados: $($modelsFound -join ', ')"
    $hasGrok = $false
    foreach ($m in $modelsFound) { if ($m -match '(?i)grok') { $hasGrok = $true } }
    if ($hasGrok) { Write-Warn "Detectado modelo Grok configurado. Em modo 'Agent', Grok Code Fast pode não suportar chamadas de ferramentas e causar 'invalid_request_body'" }
} else {
    Write-Info "Nenhum modelo de chat Copilot explicitamente configurado (usando 'auto' ou padrão)"
}

if ($AutoFix) {
    Write-Info "AutoFix habilitado: aplicando alteração para usar o modelo recomendado ($ModelToSet)..."
    # Backup
    $bkPath = "$settingsPath.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
    Write-Info "Criando backup: $bkPath"
    Copy-Item -Path $settingsPath -Destination $bkPath -Force

    # Atualiza a chave github.copilot.chat.models
    $json.'github.copilot.chat.models' = @($ModelToSet)
    $json | ConvertTo-Json -Depth 100 | Set-Content -Path $settingsPath -Encoding UTF8
    Write-Info "Atualizado settings.json: github.copilot.chat.models = [$ModelToSet]"
    Write-Info "Reinicie o VS Code Insiders para aplicar a alteração"
}

Write-Info "Buscando por 'grok' no settings.json (case-insensitive) e no workspace .vscode/settings.json"
$searchPattern = '(?i)grok'
$found = Select-String -InputObject $raw -Pattern $searchPattern -SimpleMatch -ErrorAction SilentlyContinue
if ($found) { Write-Warn "Encontrado 'grok' em settings do usuário: $($found.Line.Trim())" }

# Também verifica o settings.json do workspace (./.vscode/settings.json)
$workspaceSettings = Join-Path (Get-Location) '.vscode\settings.json'
if (Test-Path $workspaceSettings) {
    Write-Info "Encontrado settings em workspace: $workspaceSettings"
    $wsRaw = Get-Content -Raw -Path $workspaceSettings
    $wsFound = Select-String -InputObject $wsRaw -Pattern $searchPattern -SimpleMatch -ErrorAction SilentlyContinue
    if ($wsFound) { Write-Warn "Encontrado 'grok' no settings do workspace: $($wsFound.Line.Trim())" }
}

# Salva uma cópia do settings para debug (scripts/logs)
$logDir = Join-Path (Get-Location) 'scripts\logs'
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
$dst = Join-Path $logDir "copilot-settings-$(Get-Date -Format yyyyMMddHHmmss).json"
$raw | Set-Content -Path $dst -Encoding UTF8
Write-Info "Saved a copy of settings.json to: $dst"

Write-Info "Checagem finalizada. Logs salvos em $logDir se necessários (crie para debug manual)."
