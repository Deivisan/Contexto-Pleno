# test_copilot.ps1
Write-Host "== Test Copilot (gh extension copilot) ==" -ForegroundColor Cyan
$ghver = (gh --version) 2>&1
Write-Host "gh --version -> $ghver"

# Check auth
try {
    gh auth status 2>&1 | Tee-Object -FilePath "$PSScriptRoot\logs\gh-auth-status.txt"
} catch {
    Write-Host "⚠️ gh auth status falhou ou não autenticado" -ForegroundColor Yellow
}

# Check extension
$extensions = gh extension list 2>&1
Write-Host "gh extensions: $extensions"

# Install copilot extension if missing (only if authenticated)
if ($extensions -notmatch 'copilot') {
    $auth = (gh auth status 2>&1)
    if ($auth -match 'Logged in') {
        Write-Host "Instalando extensão copilot..." -ForegroundColor Gray
        try {
            gh extension install github/gh-copilot 2>&1 | Tee-Object -FilePath "$PSScriptRoot\logs\gh-copilot-install.txt"
            Write-Host "✅ Copilot extension instalada (se disponível)" -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Falha ao instalar copilot ext: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠️ gh não autenticado. Rode 'gh auth login' manualmente antes de instalar copilot." -ForegroundColor Yellow
    }
} else {
    Write-Host "Copilot extension já instalada" -ForegroundColor Green
}
