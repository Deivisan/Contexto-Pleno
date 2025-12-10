# 🛠️ Comandos Úteis - MCPs Docker

Referência rápida de comandos para gerenciar os MCPs Docker.

---

## 🐳 DOCKER COMPOSE

### Iniciar Context7
```powershell
docker compose -f MCPS/Docker/docker-compose.yml --env-file MCPS/Docker/.env up -d
```

### Parar Context7
```powershell
docker compose -f MCPS/Docker/docker-compose.yml down
```

### Reiniciar Context7
```powershell
docker compose -f MCPS/Docker/docker-compose.yml restart
```

### Ver Logs
```powershell
docker compose -f MCPS/Docker/docker-compose.yml logs -f
```

---

## 📊 MONITORAMENTO

### Ver Containers Ativos
```powershell
docker ps --filter "name=mcp"
```

### Ver Todos os Containers (incluindo parados)
```powershell
docker ps -a --filter "name=mcp"
```

### Ver Logs de um Container
```powershell
docker logs mcp-context7 --tail 50 -f
```

### Ver Status Detalhado
```powershell
docker inspect mcp-context7
```

---

## 🧪 TESTES

### Testar Context7 (HTTP/SSE)
```powershell
curl http://localhost:8080/sse
```

### Testar Tavily (STDIO)
```powershell
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm -e TAVILY_API_KEY=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 mcp/tavily
```

### Testar Memory (STDIO)
```powershell
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm -v mcp-memory-data:/data mcp/memory
```

### Testar Fetch (STDIO)
```powershell
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm mcp/fetch
```

---

## 🔧 MANUTENÇÃO

### Limpar Containers Parados
```powershell
docker container prune -f
```

### Limpar Imagens Não Usadas
```powershell
docker image prune -a -f
```

### Limpar Tudo (CUIDADO!)
```powershell
docker system prune -a --volumes -f
```

### Recriar Volume do Memory
```powershell
docker volume rm mcp-memory-data
docker volume create mcp-memory-data
```

---

## 📦 IMAGENS

### Listar Imagens MCP
```powershell
docker images --filter "reference=mcp/*" --filter "reference=ghcr.io/github/*"
```

### Atualizar Imagens
```powershell
docker pull mcp/context7:latest
docker pull mcp/tavily:latest
docker pull mcp/memory:latest
docker pull mcp/fetch:latest
docker pull mcp/filesystem:latest
docker pull mcp/playwright:latest
docker pull mcp/sequentialthinking:latest
docker pull mcp/git:latest
docker pull ghcr.io/github/github-mcp-server:latest
```

### Remover Imagem
```powershell
docker rmi mcp/nome-da-imagem
```

---

## 💾 VOLUMES

### Listar Volumes MCP
```powershell
docker volume ls --filter "name=mcp"
```

### Inspecionar Volume
```powershell
docker volume inspect mcp-memory-data
```

### Backup do Volume Memory
```powershell
docker run --rm -v mcp-memory-data:/data -v ${PWD}:/backup alpine tar czf /backup/mcp-memory-backup.tar.gz -C /data .
```

### Restaurar Volume Memory
```powershell
docker run --rm -v mcp-memory-data:/data -v ${PWD}:/backup alpine tar xzf /backup/mcp-memory-backup.tar.gz -C /data
```

---

## ⚙️ CONFIGURAÇÃO

### Ver Configuração Atual do Kiro
```powershell
Get-Content "$env:USERPROFILE\.kiro\settings\mcp.json" | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

### Aplicar Configuração ao Kiro
```powershell
Copy-Item "MCPS/configs/kiro-mcp-docker.json" "$env:USERPROFILE\.kiro\settings\mcp.json" -Force
```

### Aplicar Configuração ao Gemini CLI
```powershell
Copy-Item "MCPS/configs/kiro-mcp-docker.json" "$env:USERPROFILE\.gemini\settings\mcp.json" -Force
```

### Aplicar Configuração ao Claude Code
```powershell
Copy-Item "MCPS/configs/kiro-mcp-docker.json" "$env:USERPROFILE\.claude\settings\mcp.json" -Force
```

### Aplicar Configuração ao Windsurf
```powershell
Copy-Item "MCPS/configs/kiro-mcp-docker.json" "$env:USERPROFILE\.codeium\windsurf\mcp_config.json" -Force
```

---

## 🔍 DIAGNÓSTICO

### Verificar Docker
```powershell
docker --version
docker info
```

### Verificar Rede
```powershell
docker network ls
docker network inspect mcp-universal-network
```

### Verificar Uso de Recursos
```powershell
docker stats --no-stream
```

### Verificar Espaço em Disco
```powershell
docker system df
```

---

## 🚀 SCRIPTS ÚTEIS

### Testar Todos os MCPs
```powershell
pwsh ./scripts/test-all-mcps.ps1
```

### Iniciar MCPs
```powershell
pwsh ./scripts/start-mcps.ps1 -Action start
```

### Ver Status dos MCPs
```powershell
pwsh ./scripts/start-mcps.ps1 -Action status
```

### Ver Logs dos MCPs
```powershell
pwsh ./scripts/start-mcps.ps1 -Action logs
```

### Parar MCPs
```powershell
pwsh ./scripts/start-mcps.ps1 -Action stop
```

---

## 🔐 VARIÁVEIS DE AMBIENTE

### Ver Variáveis Configuradas
```powershell
Get-Content "MCPS/Docker/.env"
```

### Editar Variáveis
```powershell
notepad "MCPS/Docker/.env"
```

### Aplicar Variáveis ao Sistema (Windows)
```powershell
pwsh ./scripts/apply-mcp-env.ps1
```

---

## 📝 LOGS E RELATÓRIOS

### Gerar Relatório de Containers
```powershell
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}" > MCPS/Docker/containers-report.txt
```

### Gerar Relatório de Imagens
```powershell
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" > MCPS/Docker/images-report.txt
```

### Gerar Relatório de Volumes
```powershell
docker volume ls --format "table {{.Name}}\t{{.Driver}}" > MCPS/Docker/volumes-report.txt
```

---

## 🆘 TROUBLESHOOTING

### Container em Loop de Restart
```powershell
# Ver logs
docker logs mcp-nome-do-container --tail 50

# Parar container
docker stop mcp-nome-do-container

# Remover container
docker rm mcp-nome-do-container

# Recriar
docker compose -f MCPS/Docker/docker-compose.yml up -d
```

### Porta Já em Uso
```powershell
# Ver processo usando a porta
netstat -ano | findstr :8080

# Matar processo (substitua PID)
taskkill /PID <PID> /F
```

### Context7 Unhealthy
```powershell
# Ver logs
docker logs mcp-context7 --tail 50

# Reiniciar
docker restart mcp-context7

# Recriar
docker compose -f MCPS/Docker/docker-compose.yml down
docker compose -f MCPS/Docker/docker-compose.yml up -d
```

### MCP STDIO Não Responde
```powershell
# Testar manualmente
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm mcp/nome-do-mcp

# Verificar imagem
docker pull mcp/nome-do-mcp:latest

# Verificar variáveis de ambiente
docker run -i --rm mcp/nome-do-mcp env
```

---

## 📚 REFERÊNCIAS

- [Docker Documentation](https://docs.docker.com/)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MCP Docker Hub](https://hub.docker.com/u/mcp)
- [Kiro Documentation](https://docs.kiro.ai/)

---

**Última Atualização:** 2025-12-10  
**Autor:** Kiro (DevSan AI)  
**Workspace:** C:/Projetos/Contexto-Pleno
