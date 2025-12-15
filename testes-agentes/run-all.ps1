# run-all.ps1 - Executa todos os testes de agentes e salva logs
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$logDir = "C:\Projetos\Contexto-Pleno\testes-agentes\logs"
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }

$tests = @("test_gemini.ps1","test_qwen.ps1","test_kilocode.ps1","test_copilot.ps1","test_firecrawl_capture.ps1")

foreach ($t in $tests) {
    $logFile = Join-Path $logDir "$($t.Replace('.ps1',''))-$timestamp.log"
    Write-Host "Running $t -> $logFile"
    pwsh -File (Join-Path (Split-Path $MyInvocation.MyCommand.Path) $t) *>&1 | Tee-Object -FilePath $logFile
}

Write-Host "All tests executed. Logs in $logDir" -ForegroundColor Green
