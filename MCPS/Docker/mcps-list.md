## MCPs disponíveis via Docker

Este arquivo lista os containers de MCP detectados no momento em que a exportação foi feita.

Arquivos gerados:
- `containers.json` — lista de containers atuais com ID, imagem, nome, portas e status
- `docker-info.json` — saída do `docker info` em JSON

Sumário dos MCPs detectados (extraído de `containers.json`):

| Nome do container | Imagem | Portas | Status |
|---|---|---|---|
| mcp_context7 | mcp/context7 | 8080/tcp | Up About an hour (healthy) |
| mcp_tavily | mcp/tavily | — | Exited |
| mcp_tavily_http | mcp/tavily | — | Exited |
| mcp_fetch | mcp/fetch | — | Exited |
| mcp_fetch_http | mcp/fetch | — | Exited |
| mcp_gateway | docker/mcp-gateway:latest | — | Restarting |
| mcp_filesystem | mcp/filesystem | — | Restarting |
| mcp_dockerhub | mcp/dockerhub | — | Restarting |
| mcp_firecrawl | mcp/firecrawl | — | Restarting |
| mcp_desktop_commander | mcp/desktop-commander | — | Restarting |
| mcp_dockerhub (additional entries) | mcp/dockerhub | — | Up |
| agent-core-local | mcp/agent:local | — | Up |
| local-agent | 44e708dfe897 | — | Up |

Observações:
- Se um container não expõe `hostPort->containerPort` no campo `Ports`, ele não está necessariamente acessível via `localhost` no host (pode estar apenas na rede Docker). Para tornar um MCP acessível a CLIs externas, exponha portas usando `-p hostPort:containerPort` ou configure um proxy reverso.
- Alguns MCPs estão em `Restarting` — verificar logs (`docker logs <container>`) para diagnosticar.

Como usar essas informações para tornar MCPs globais para os agentes CLI:
1. Determine quais MCPs precisam ser acessíveis por `localhost` (ex: Tavily, Context7, Memory)
2. Se o container não expõe um host port, re-crie com: `docker run -d -p 8080:8080 --name mcp_context7 mcp/context7`
3. Atualize suas variáveis de ambiente (ex. `TAVILY_URL=http://localhost:3000`) para apontar para `localhost` caso o host port esteja mapeado.
4. Em Windows/PowerShell, exporte variáveis de ambiente de forma persistente (ex.: `setx TAVILY_URL http://localhost:...`)
