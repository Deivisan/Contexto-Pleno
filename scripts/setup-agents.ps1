<#
Instala/atualiza CLIs de agentes via npm global:
 - @qwen-code/qwen-code
 - @google/gemini-cli
 - @kilocode/cli
 - @githubnext/github-copilot-cli

Também garante que %APPDATA%\npm está no PATH do usuário e na sessão atual.
Use: pwsh ./scripts/setup-agents.ps1
#>

function Write-Info($text) { Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-ErrorAndExit($text) { Write-Host "[ERROR] $text" -ForegroundColor Red; exit 1 }

param(
    [switch]$FixCopilotModel,
    [string]$PreferredCopilotModel = 'gpt-4o'
)

Write-Info "Verificando PowerShell 7..."
if ($PSVersionTable.PSVersion.Major -lt 7) { Write-ErrorAndExit "Necessário PowerShell 7 (pwsh)" }

Write-Info "Garantindo npm global path em PATH do usuário..."
$npmBin = (Get-ChildItem Env:APPDATA).Value + '\npm'
if ($env:PATH -notlike "*$npmBin*" -and [Environment]::GetEnvironmentVariable('Path','User') -notlike "*$npmBin*") {
    Write-Info "Adicionando $npmBin ao PATH do usuário"
    $userPath = [Environment]::GetEnvironmentVariable('Path','User')
    [Environment]::SetEnvironmentVariable('Path', $userPath + ';' + $npmBin, 'User'); $env:Path = $npmBin + ';' + $env:Path
    Write-Info "Adicionado. Feche e reabra o PowerShell para herdar o novo PATH";
}

Write-Info "Instalando/Atualizando agent CLIs via npm global..."
$packages = '@qwen-code/qwen-code', '@google/gemini-cli', '@kilocode/cli', '@githubnext/github-copilot-cli'
foreach ($pkg in $packages) {
    Write-Info "Install/Update: $pkg"
    npm install -g $pkg --no-fund --no-audit 2>&1 | Out-Null
}

Write-Info "Criando shims/conveniências quando necessário (qwen -> qwen-mcp, devsan)"
$npmBin = Join-Path $Env:APPDATA 'npm'
if ((Test-Path (Join-Path $npmBin 'qwen-mcp.cmd')) -and -not (Test-Path (Join-Path $npmBin 'qwen.cmd'))) {
    Write-Info "Criando shim qwen.cmd apontando para qwen-mcp"
    Set-Content -Path (Join-Path $npmBin 'qwen.cmd') -Value "@echo off`r`n%~dp0\qwen-mcp.cmd %*" -Force
}
if (-not (Test-Path (Join-Path $npmBin 'devsan.cmd'))) {
    Write-Info "Criando shim devsan.cmd apontando para scripts/devsan.ps1"
    $scriptPath = Join-Path (Get-Location) 'scripts\devsan.ps1'
    Set-Content -Path (Join-Path $npmBin 'devsan.cmd') -Value "@echo off`r`npowershell -ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`" %*" -Force
}

Write-Info "Verificando comandos e versões via PATH..."
try { Get-Command qwen -ErrorAction Stop | Format-List Name,Source -Force } catch { Write-Warning "qwen não encontrado em PATH" }
try { Get-Command gemini -ErrorAction Stop | Format-List Name,Source -Force } catch { Write-Warning "gemini não encontrado em PATH" }
try { Get-Command kilocode -ErrorAction Stop | Format-List Name,Source -Force } catch { Write-Warning "kilocode não encontrado em PATH" }
try { Get-Command copilot -ErrorAction Stop | Format-List Name,Source -Force } catch { Write-Warning "copilot não encontrado em PATH" }

Write-Info "Setup-agents concluído. Se os comandos não estiverem disponíveis, feche e reabra o PowerShell para herdar o PATH atualizado."

Write-Info "Executando checagem de Copilot e modo Agent (se disponível)..."
$testScript = Join-Path (Get-Location) 'scripts\test-copilot-agent-mode.ps1'
if (Test-Path $testScript) { & $testScript } else { Write-Warn "scripts/test-copilot-agent-mode.ps1 não encontrado." }

if ($FixCopilotModel) {
    Write-Info "Aplicando correção de modelo do Copilot: $PreferredCopilotModel"
    $fixScript = Join-Path (Get-Location) 'scripts\fix-copilot-agent-model.ps1'
    if (Test-Path $fixScript) { & $fixScript -ModelToSet $PreferredCopilotModel } else { Write-Warn "scripts/fix-copilot-agent-model.ps1 não encontrado." }
}
