<#
Wrapper para trocar modelo do Copilot no settings.json para um valor recomendado (para reduzir erros em modo Agent).

Usage: pwsh ./scripts/fix-copilot-agent-model.ps1 -ModelToSet "gpt-4o" -UseStable
#>

param(
    [string]$ModelToSet = "gpt-4o",
    [switch]$UseStable
)

Write-Host "[INFO] Aplicando correção para GitHub Copilot Chat model: $ModelToSet"
$script = Join-Path (Get-Location) 'scripts\check-copilot-setup.ps1'
& $script -AutoFix -ModelToSet $ModelToSet $(if ($UseStable) { '-UseStable' } )
