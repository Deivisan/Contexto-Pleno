# test_qwen.ps1
Write-Host "== Test Qwen ==" -ForegroundColor Cyan
$qver = (qwen --version) 2>&1
Write-Host "qwen --version -> $qver"

# Sample: gerar route /health em Express
$prompt = "Gere um arquivo src/routes/health.js com um endpoint GET /health que retorna {ok: true}, mais um teste Jest"
try {
    # Uso de prompt positional (compatível com CLI)
    qwen -m qwen3-coder -p $prompt > "$PSScriptRoot\logs\qwen-prompt-output.txt"
    Write-Host "✅ Qwen prompt executado, output salvo em logs/"
} catch {
    Write-Host "⚠️ Qwen falhou: $_" -ForegroundColor Yellow
}
