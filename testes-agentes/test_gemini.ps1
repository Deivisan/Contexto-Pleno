# test_gemini.ps1
Write-Host "== Test Gemini ==" -ForegroundColor Cyan
$version = (gemini --version) 2>&1
Write-Host "gemini --version -> $version"

# Prompt de teste (planejamento curto)
$prompt = "Planeje em 2 passos como criar um endpoint /health para uma API Node.js com testes"
try {
    gemini --yolo --model gemini-2.0-flash-thinking --prompt $prompt --json | Out-File -FilePath "$PSScriptRoot\logs\gemini-prompt-output.json" -Encoding UTF8
    Write-Host "✅ Gemini prompt executado, output salvo em logs/"
} catch {
    Write-Host "⚠️ Gemini prompt falhou: $_" -ForegroundColor Yellow
}
