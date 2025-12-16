<#
Validate that quartet agent CLIs are installed and reachable via PATH.
Generates MCPS/Docker/agents-validation.json with versions and basic connectivity tests.
Usage: pwsh ./scripts/validate-agents.ps1
#>

function Write-Info($text) { Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-OK($text) { Write-Host "[OK] $text" -ForegroundColor Green }
function Write-Warn($text) { Write-Host "[WARN] $text" -ForegroundColor Yellow }

$outDir = Join-Path $PSScriptRoot '..\MCPS\Docker'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

$agents = @(
    @{ Name = 'qwen'; Cmd = 'qwen'; Args = '--version' },
    @{ Name = 'gemini'; Cmd = 'gemini'; Args = '--version' },
    @{ Name = 'kilocode'; Cmd = 'kilocode'; Args = '--version' },
    @{ Name = 'copilot'; Cmd = 'copilot'; Args = '--version' }
)

$results = @()
foreach ($agent in $agents) {
    $rec = [PSCustomObject]@{
        Name = $agent.Name
        Cmd = $agent.Cmd
        Installed = $false
        VersionOutput = $null
        ExitCode = $null
        Error = $null
    }
    try {
        $cmdPath = Get-Command $agent.Cmd -ErrorAction Stop
        $rec.Installed = $true
    } catch {
        $rec.Error = "Command not found in PATH"
        $results += $rec; continue
    }
    try {
        $proc = Start-Process -FilePath $agent.Cmd -ArgumentList $agent.Args -NoNewWindow -RedirectStandardOutput ([System.IO.Path]::GetTempFileName()) -RedirectStandardError ([System.IO.Path]::GetTempFileName()) -PassThru -Wait
        $out = Get-Content $proc.StandardOutput -Raw -ErrorAction SilentlyContinue
        $err = Get-Content $proc.StandardError -Raw -ErrorAction SilentlyContinue
        $rec.VersionOutput = $out.Trim() + "`n" + $err.Trim()
        $rec.ExitCode = $proc.ExitCode
    } catch {
        $rec.Error = $_.Exception.Message
    }
    $results += $rec
}

$outFile = Join-Path $outDir 'agents-validation.json'
$results | ConvertTo-Json -Depth 4 | Out-File -FilePath $outFile -Encoding utf8
Write-Info "Wrote validation results to $outFile"
