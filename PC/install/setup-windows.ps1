<#
Automated setup for Windows (PowerShell 7)
Instala Node.js via winget, adiciona npm global bin ao PATH, instala agentes:
  - @qwen-code/qwen-code
  - @google/gemini-cli
  - @kilocode/cli
  - @githubnext/github-copilot-cli

Use 'pwsh ./scripts/setup-windows.ps1' to run.
#>

function Write-Info($text) { Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-ErrorAndExit($text) { Write-Host "[ERROR] $text" -ForegroundColor Red; exit 1 }

Write-Info "Verificando versão do PowerShell..."
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-ErrorAndExit "PowerShell 7 é recomendado (pwsh). Versão atual: $($PSVersionTable.PSVersion)"
}

Write-Info "Checando Node.js..."
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCmd) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Info "Node.js não encontrado. Instalando via winget..."
        winget install --accept-package-agreements --accept-source-agreements --exact -e OpenJS.NodeJS.LTS
    } else {
        Write-Info "winget não encontrado. Instale Node.js LTS manualmente: https://nodejs.org/en/download/"
        exit 2
    }
} else { Write-Info "Node.js encontrado: $(node --version)" }

try {
    $nodeVersion = (node --version).TrimStart('v') -split '\.' | Select-Object -First 1
    if ([int]$nodeVersion -lt 25) {
        Write-Info "Atenção: recomenda-se Node.js 25+ para este repositório. Versão atual: $(node --version)."
        Write-Info "Considere atualizar para Node 25+ via nvm, nvm-windows ou winget." 
    }
} catch { }

Write-Info "Checando npm..."
$npmCmd = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmCmd) { Write-ErrorAndExit "npm não encontrado; verifique instalação do Node.js. " }

Write-Info "determinando pasta global do npm..."
$npmBin = npm bin -g 2>$null
if (-not $npmBin) { Write-ErrorAndExit "Não foi possível obter npm global bin path" }
Write-Info "npm global bin: $npmBin"

if ($env:Path -notlike "*${npmBin}*") {
    Write-Info "Adicionando npm global ao PATH do usuário..."
    $userPath = [Environment]::GetEnvironmentVariable('Path','User')
    if ($userPath -notlike "*${npmBin}*") {
        [Environment]::SetEnvironmentVariable('Path', $userPath + ';' + $npmBin, 'User')
        Write-Info "Adicionado. Feche e reabra o PowerShell para herdar o novo PATH."
    } else { Write-Info "npm bin já presente no PATH do usuário." }
} else { Write-Info "npm bin presente no PATH desta sessão." }

Write-Info "Instalando agentes globais via npm..."
$packages = '@qwen-code/qwen-code', '@google/gemini-cli', '@kilocode/cli', '@githubnext/github-copilot-cli'
foreach ($pkg in $packages) {
    Write-Info "Instalando $pkg..."
    npm install -g $pkg --no-fund --no-audit
}

Write-Info "Criando wrapper DevSan (scripts/devsan.ps1) se necessário..."
$devsanScriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'devsan.ps1'
if (-not (Test-Path $devsanScriptPath)) {
    New-Item -Path $devsanScriptPath -ItemType File -Force -Value "Write-Host 'DevSan placeholder — customize scripts/devsan.ps1 para executar o agente' -ForegroundColor Green" | Out-Null
    Write-Info "Criado $devsanScriptPath"
} else { Write-Info "$devsanScriptPath já existe" }

Write-Info "Criando shim no npm global para 'devsan'..."
$shim = Join-Path -Path $npmBin -ChildPath 'devsan.cmd'
if (-not (Test-Path $shim)) {
    $shimContent = "@echo off\npowershell -ExecutionPolicy Bypass -File \"$devsanScriptPath\" %*"
    Set-Content -Path $shim -Value $shimContent -Force -NoNewline
    Write-Info "Shim criado: $shim"
} else { Write-Info "Shim 'devsan' já existe em $shim" }

Write-Info "Verificando versões dos agentes e comandos..."
node --version
npm --version
git --version

Write-Info "Verificando comandos dos agentes (produz 'Get-Command' info se estiverem instalados)..."
Get-Command qwen -ErrorAction SilentlyContinue | Format-List -Property Name,Source,Module
Get-Command gemini -ErrorAction SilentlyContinue | Format-List -Property Name,Source,Module
Get-Command kilocode -ErrorAction SilentlyContinue | Format-List -Property Name,Source,Module
Get-Command copilot -ErrorAction SilentlyContinue | Format-List -Property Name,Source,Module
Get-Command devsan -ErrorAction SilentlyContinue | Format-List -Property Name,Source,Module

Write-Info "Setup concluído — se algum comando não estiver disponível, feche e reabra o PowerShell (pwsh) e execute novamente as verificações."

exit 0
