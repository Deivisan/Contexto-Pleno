# Verificar configuração OpenCode MCP
Write-Host "=== Configuração OpenCode MCP ===" -ForegroundColor Green

$configPath = "C:\Projetos\Contexto-Pleno\.opencode\opencode.json"
if (Test-Path $configPath) {
    Write-Host "✅ Arquivo de configuração encontrado" -ForegroundColor Green
    $config = Get-Content $configPath | ConvertFrom-Json
    Write-Host "MCPs configurados:" -ForegroundColor Yellow
    $config.mcp | Get-Member -MemberType NoteProperty | ForEach-Object {
        Write-Host "  - $($_.Name)" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ Arquivo de configuração não encontrado" -ForegroundColor Red
}

Write-Host "`n=== Teste Context7 ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/sse" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Context7 respondendo" -ForegroundColor Green
} catch {
    Write-Host "❌ Context7 não responde" -ForegroundColor Red
}

Write-Host "`n=== Containers Ativos ===" -ForegroundColor Yellow
docker ps --filter "name=DevSan-MCP" --format "{{.Names}}: {{.Status}}" 2>$null | Select-Object -First 5