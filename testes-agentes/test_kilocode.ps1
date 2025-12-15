# test_kilocode.ps1
Write-Host "== Test Kilocode ==" -ForegroundColor Cyan
$kver = (kilocode --version) 2>&1
Write-Host "kilocode --version -> $kver"

# Sample: scaffolding
$prompt = "Crie scaffolding de um app React (Vite) com um componente Login e testes Playwright para login flow"
try {
    # Kilocode não possui flags yolo/unified; usar prompt positional
    kilocode -p $prompt --mode architect > "$PSScriptRoot\logs\kilocode-prompt-output.txt"
    Write-Host "✅ Kilocode prompt executado, output salvo em logs/"
} catch {
    Write-Host "⚠️ Kilocode falhou: $_" -ForegroundColor Yellow
}
