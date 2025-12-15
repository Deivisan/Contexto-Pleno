# Script para iniciar o container MCP Context7
# Uso: .\scripts\start-mcp-context7.ps1
# Para auto-start: Adicionar ao Task Scheduler

param(
    [switch]$Force,
    [switch]$Stop,
    [switch]$Status
)

$containerName = "mcp-context7"
$imageName = "mcp/context7:latest"
$port = 8080

function Get-ContainerStatus {
    $status = docker ps -a --filter "name=$containerName" --format "{{.Status}}" 2>$null
    return $status
}

function Start-Context7 {
    $status = Get-ContainerStatus
    
    if ($status -like "Up*") {
        Write-Host "✅ Container $containerName já está rodando" -ForegroundColor Green
        Write-Host "   Endpoint: http://localhost:$port/sse"
        return
    }
    
    if ($status) {
        Write-Host "🔄 Removendo container parado..." -ForegroundColor Yellow
        docker rm $containerName 2>$null
    }
    
    Write-Host "🚀 Iniciando $containerName..." -ForegroundColor Cyan
    docker run -d `
        --name $containerName `
        -p ${port}:${port} `
        --restart unless-stopped `
        $imageName
    
    Start-Sleep -Seconds 2
    
    $newStatus = Get-ContainerStatus
    if ($newStatus -like "Up*") {
        Write-Host "✅ Container iniciado com sucesso!" -ForegroundColor Green
        Write-Host "   Endpoint: http://localhost:$port/sse"
    } else {
        Write-Host "❌ Falha ao iniciar container" -ForegroundColor Red
        docker logs $containerName --tail 20
    }
}

function Stop-Context7 {
    $status = Get-ContainerStatus
    
    if (-not $status) {
        Write-Host "⚠️ Container $containerName não existe" -ForegroundColor Yellow
        return
    }
    
    Write-Host "🛑 Parando $containerName..." -ForegroundColor Yellow
    docker stop $containerName 2>$null
    docker rm $containerName 2>$null
    Write-Host "✅ Container parado e removido" -ForegroundColor Green
}

function Show-Status {
    $status = Get-ContainerStatus
    
    Write-Host ""
    Write-Host "=== MCP Context7 Status ===" -ForegroundColor Cyan
    Write-Host ""
    
    if ($status -like "Up*") {
        Write-Host "Status: ✅ Rodando" -ForegroundColor Green
        Write-Host "Endpoint: http://localhost:$port/sse"
        Write-Host ""
        Write-Host "Logs recentes:"
        docker logs $containerName --tail 5
    } elseif ($status) {
        Write-Host "Status: ⚠️ Parado ($status)" -ForegroundColor Yellow
    } else {
        Write-Host "Status: ❌ Não existe" -ForegroundColor Red
    }
    Write-Host ""
}

# Main
if ($Status) {
    Show-Status
} elseif ($Stop) {
    Stop-Context7
} else {
    Start-Context7
}
