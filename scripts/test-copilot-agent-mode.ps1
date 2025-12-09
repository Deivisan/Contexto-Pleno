<#
Executa uma série de checagens rápidas para validar Copilot CLI, MCPs e integridade do modo Agent.

Usage: pwsh ./scripts/test-copilot-agent-mode.ps1
#>

function Write-Info($text) { Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-ErrorAndExit($text) { Write-Host "[ERROR] $text" -ForegroundColor Red; exit 1 }

Write-Info "Iniciando checagens do Copilot Agent Mode..."

try {
    $copilotCmd = Get-Command github-copilot-cli -ErrorAction Stop
    Write-Info "Copilot CLI: $($copilotCmd.Name) encontrado em $($copilotCmd.Source)"
} catch {
    Write-Info "Copilot CLI não encontrado. Tente instalar com: npm install -g @githubnext/github-copilot-cli"
}

Write-Info "Executando scripts de validação do workspace (validate-agents/test-mcps)..."
$valScript = Join-Path (Get-Location) 'scripts\validate-agents.ps1'
if (Test-Path $valScript) { & $valScript } else { Write-Warn "validate-agents.ps1 não encontrado" }
$testMcps = Join-Path (Get-Location) 'scripts\test-mcps.ps1'
if (Test-Path $testMcps) { & $testMcps } else { Write-Warn "test-mcps.ps1 não encontrado" }

Write-Info "Agora executando check-copilot-setup.ps1 (read-only)"
$checkScript = Join-Path (Get-Location) 'scripts\check-copilot-setup.ps1'
if (Test-Path $checkScript) { & $checkScript } else { Write-Warn "check-copilot-setup.ps1 não encontrado" }

Write-Info "Concluído. Se houve falha em modo Agent com Grok, experimente atualizar configurações com fix-copilot-agent-model.ps1"
