# test_firecrawl_capture.ps1
Write-Host "== Test Firecrawl Capture ==" -ForegroundColor Cyan
$log = "$PSScriptRoot\logs\firecrawl-capture-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"

# Lista de URLs de teste (substitua por URLs reais de exemplo)
$urls = @(
    "https://grok.com/share/EXEMPLO_CURTO",
    "https://grok.com/share/EXEMPLO_MEDIO",
    "https://grok.com/share/EXEMPLO_LONGO"
)

foreach ($u in $urls) {
    Write-Host "Testando $u"
    try {
        # Se existir um cliente CLI firecrawl local, chamá-lo, caso contrário, registrar instrução
        if (Get-Command firecrawl -ErrorAction SilentlyContinue) {
            firecrawl scrape --url $u --format markdown | Tee-Object -FilePath $log -Append
        } else {
            "[INSTRUÇÃO] Use mcp_firecrawl_fir_firecrawl_scrape para $u" | Tee-Object -FilePath $log -Append
        }
    } catch {
        "Erro capturando $u: $_" | Tee-Object -FilePath $log -Append
    }
}
Write-Host "✅ Teste Firecrawl concluído (log: $log)" -ForegroundColor Green
