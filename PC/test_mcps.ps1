# Teste de MCPs ativos
Write-Host "=== Teste de MCPs Ativos ===" -ForegroundColor Green

# Test Context7 (HTTP/SSE)
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/sse" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Context7: Ativo" -ForegroundColor Green
} catch {
    Write-Host "❌ Context7: Inativo" -ForegroundColor Red
}

# Test Desktop Commander
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Desktop Commander: Ativo" -ForegroundColor Green
} catch {
    Write-Host "❌ Desktop Commander: Inativo" -ForegroundColor Red
}

# Test Agent MCP
try {
    $response = Invoke-WebRequest -Uri "http://localhost:4000/health" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Agent MCP: Ativo" -ForegroundColor Green
} catch {
    Write-Host "❌ Agent MCP: Inativo" -ForegroundColor Red
}

# Test Firecrawl
try {
    $response = Invoke-WebRequest -Uri "http://localhost:6000/health" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Firecrawl: Ativo" -ForegroundColor Green
} catch {
    Write-Host "❌ Firecrawl: Inativo" -ForegroundColor Red
}

Write-Host "`n=== Containers Docker ===" -ForegroundColor Yellow
docker ps --filter "name=DevSan-MCP" --format "table {{.Names}}\t{{.Status}}" | Select-Object -First 10