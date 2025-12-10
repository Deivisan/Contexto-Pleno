# 🚀 ROADMAP: MCPs Universais para Agentes IA

> **Gerado:** 2025-12-09  
> **Autor:** Kiro (DevSan AI)  
> **Objetivo:** Universalizar MCPs via Docker para todos os agentes IA

---

## 📊 DIAGNÓSTICO ATUAL

### 🖥️ Sistema PC (DEIVIPC)
| Componente | Valor |
|------------|-------|
| **OS** | Windows 10 Pro (Build 26220) |
| **CPU** | AMD Ryzen 7 5700G (16 threads) |
| **RAM** | 32GB |
| **Arquitetura** | x64 |
| **Docker** | v29.1.2 (Desktop + WSL2) |
| **Node.js** | v25.2.1 |
| **Python** | 3.14.2 |
| **Git** | 2.52.0 |
| **GitHub CLI** | 2.83.1 |
| **GitHub User** | Deivisan (Deivison Santana) |

### 🤖 Agentes CLI Instalados
| Agente | Versão | Status |
|--------|--------|--------|
| **Gemini CLI** | 0.19.4 | ✅ Instalado |
| **Kilocode CLI** | 0.12.1 | ✅ Instalado |
| **Claude Code** | 2.0.60 | ✅ Instalado |
| **GitHub Copilot** | 0.0.367 | ✅ Instalado |
| **Playwright MCP** | 0.0.50 | ✅ Instalado |
| **Qwen CLI** | - | ❌ Não encontrado no PATH |

### 🐳 Containers Docker Atuais
| Container | Imagem | Status | Portas |
|-----------|--------|--------|--------|
| context7-mcp | mcp/context7 | Exited | 8080/tcp (não mapeada) |
| desktop-commander | mcp/desktop-commander | Exited | - |
| github-mcp | ghcr.io/github/github-mcp-server | Exited | - |
| playwright-mcp | mcp/playwright | Exited | - |
| mcp-platform | fabrica-de-conteudo-mcp-platform | Up | 3000-3001 ✅ |

### 🔧 MCPs Configurados no Kiro
| MCP | Comando | Status |
|-----|---------|--------|
| context7 | npx @upstash/context7-mcp | ✅ Ativo |
| tavily | npx tavily-mcp | ✅ Ativo |
| memory | npx @modelcontextprotocol/server-memory | ✅ Ativo |
| git | uvx mcp-server-git | ✅ Ativo |
| fetch | uvx mcp-server-fetch | ✅ Ativo |
| filesystem | uvx mcp-server-filesystem | ❌ Desabilitado |
| sequential-thinking | npx @modelcontextprotocol/server-sequential-thinking | ❌ Desabilitado |

---

## 🎯 PROBLEMAS IDENTIFICADOS

1. **Containers sem port binding** - MCPs não acessíveis via localhost
2. **Containers em loop de restart** - Configuração incorreta
3. **NPX/UVX criando node_modules aleatórios** - Desperdício de espaço
4. **Cada agente com configuração separada** - Falta de centralização
5. **Containers não persistentes** - Perdem estado ao reiniciar
6. **Sem auto-start no boot** - Precisa iniciar manualmente

---

## 🗺️ ROADMAP COMPLETO

### FASE 1: Limpeza e Preparação (Imediato) ✅
- [x] Diagnóstico completo do sistema
- [x] Identificar containers problemáticos
- [x] Mapear imagens Docker existentes
- [x] Criar estrutura de diretórios padronizada

### FASE 2: Docker Compose Universal (Hoje) ✅
- [x] Criar `docker-compose.yml` definitivo com todos os MCPs
- [x] Criar arquivo `.env` com todas as API keys
- [x] Configurar volumes persistentes
- [x] Mapear portas corretamente
- [x] Configurar healthchecks
- [ ] Testar cada container individualmente

### FASE 3: Configuração dos Agentes (Hoje) 🔄
- [x] Criar configuração universal `mcp-config-universal.json`
- [x] Criar script de sincronização `sync-mcp-configs.ps1`
- [x] Habilitar MCPs via Docker MCP nativo (8 servidores)
- [x] Configurar secrets (GitHub OAuth, Tavily API)
- [ ] Testar conectividade de cada agente

### FASE 4: Auto-Start e Persistência (Amanhã)
- [x] Criar script PowerShell de inicialização `start-mcps.ps1`
- [ ] Configurar Task Scheduler para auto-start
- [ ] Implementar monitoramento de saúde
- [ ] Criar script de backup de configurações

### FASE 5: Documentação e Memória (Hoje) ✅
- [x] Criar arquivo de contexto do PC (PC-Context.md)
- [x] Criar ROADMAP-MCP-UNIVERSAL.md
- [ ] Atualizar DevSan.md com contexto do PC
- [ ] Sincronizar memória entre agentes

---

## 📦 ARQUITETURA PROPOSTA

```
┌─────────────────────────────────────────────────────────────┐
│                    DOCKER COMPOSE                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │  context7   │ │   tavily    │ │   memory    │            │
│  │  :8080      │ │   :3000     │ │   :4000     │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │    git      │ │   fetch     │ │ filesystem  │            │
│  │  :5000      │ │   :9000     │ │   :6000     │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │ playwright  │ │  github     │ │  desktop    │            │
│  │  :7000      │ │   :5001     │ │   :8000     │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    AGENTES IA                                │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │  Kiro   │ │ Gemini  │ │ Claude  │ │ Copilot │           │
│  │  (IDE)  │ │  CLI    │ │  Code   │ │  CLI    │           │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘           │
│  ┌─────────┐ ┌─────────┐                                    │
│  │Kilocode │ │  Qwen   │                                    │
│  │  CLI    │ │  CLI    │                                    │
│  └─────────┘ └─────────┘                                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 MAPEAMENTO DE PORTAS

| MCP Server | Porta Host | Porta Container | Protocolo |
|------------|------------|-----------------|-----------|
| context7 | 8080 | 8080 | HTTP/SSE |
| tavily | 3000 | 3000 | HTTP/SSE |
| memory | 4000 | 4000 | HTTP/SSE |
| git | 5000 | 5000 | HTTP/SSE |
| github | 5001 | 5001 | HTTP/SSE |
| filesystem | 6000 | 6000 | HTTP/SSE |
| playwright | 7000 | 7000 | HTTP/SSE |
| desktop-commander | 8000 | 8000 | HTTP/SSE |
| fetch | 9000 | 9000 | HTTP/SSE |

---

## 🔑 API KEYS (do Banco-Api.md)

| Serviço | Variável | Configurado |
|---------|----------|-------------|
| Tavily | TAVILY_API_KEY | ✅ |
| Context7 | CONTEXT7_API_KEY | ✅ |
| Google AI | GOOGLE_API_KEY | ✅ |
| GitHub | GITHUB_PERSONAL_ACCESS_TOKEN | ✅ |
| OpenRouter | OPENROUTER_API_KEY | ✅ |

---

## 📋 PRÓXIMOS PASSOS IMEDIATOS

1. **Criar docker-compose.yml definitivo**
2. **Criar arquivo .env com todas as API keys**
3. **Parar containers antigos e subir novos**
4. **Testar conectividade de cada MCP**
5. **Atualizar configurações dos agentes**

---

## 📝 NOTAS

- Docker Desktop já tem suporte nativo a MCP via `docker mcp` plugin
- Preferir STDIO para containers locais (mais simples e confiável)
- SSE/HTTP apenas quando precisar de acesso remoto
- Volumes persistentes para memory e dados importantes
- Healthchecks para garantir disponibilidade



---

## ✅ PROGRESSO ATUAL (2025-12-09)

### Arquivos Criados
| Arquivo | Descrição |
|---------|-----------|
| `MCPS/Docker/docker-compose.yml` | Docker Compose com 9 MCPs configurados |
| `MCPS/Docker/.env` | Variáveis de ambiente com todas as API keys |
| `MCPS/mcp-config-universal.json` | Configuração MCP universal para agentes |
| `PC-Context.md` | Contexto completo do PC para agentes |
| `scripts/start-mcps.ps1` | Script de gerenciamento dos MCPs |
| `scripts/sync-mcp-configs.ps1` | Script de sincronização de configs |

### Docker MCP Nativo (8 servidores habilitados)
```
✅ context7        - Documentação de bibliotecas
✅ desktop-commander - Controle do desktop
✅ fetch           - HTTP requests
✅ github-official - GitHub API (OAuth configurado)
✅ memory          - Memória persistente
✅ playwright      - Automação de browser
✅ sequentialthinking - Pensamento sequencial
⚠️ tavily          - Busca web (secret configurado, aguardando validação)
```

### Secrets Configurados
```
✅ github.personal_access_token (OAuth)
✅ TAVILY_API_KEY
```

---

## 🚀 COMO USAR

### Opção 1: Docker MCP Nativo (Recomendado)
O Docker Desktop já tem suporte nativo a MCP. Os servidores já estão habilitados.

```powershell
# Ver servidores habilitados
docker mcp server list

# Conectar a um cliente (ex: Claude Desktop)
docker mcp client connect claude

# Ver detalhes de um servidor
docker mcp server inspect tavily
```

### Opção 2: Docker Compose (Para controle total)
```powershell
# Iniciar todos os MCPs
pwsh ./scripts/start-mcps.ps1 -Action start

# Ver status
pwsh ./scripts/start-mcps.ps1 -Action status

# Ver logs
pwsh ./scripts/start-mcps.ps1 -Action logs

# Parar
pwsh ./scripts/start-mcps.ps1 -Action stop
```

### Opção 3: NPX/UVX (Atual - funciona mas cria node_modules)
A configuração atual do Kiro usa npx/uvx. Funciona, mas cria pastas temporárias.

---

## 📋 PRÓXIMOS PASSOS IMEDIATOS

1. **Testar Docker MCP Gateway**
   ```powershell
   docker mcp gateway run --transport sse
   ```

2. **Configurar auto-start no Windows**
   - Criar tarefa no Task Scheduler
   - Executar `start-mcps.ps1` no login

3. **Validar conectividade de cada MCP**
   ```powershell
   pwsh ./scripts/start-mcps.ps1 -Action test
   ```

4. **Sincronizar configs para todos os agentes**
   ```powershell
   pwsh ./scripts/sync-mcp-configs.ps1
   ```

---

## 🔧 TROUBLESHOOTING

### Container em loop de restart
```powershell
docker logs mcp-<nome> --tail 50
docker inspect mcp-<nome> | jq '.[0].State'
```

### MCP não responde
```powershell
# Verificar se porta está em uso
netstat -an | Select-String ":<porta>"

# Reiniciar container específico
docker restart mcp-<nome>
```

### Secret não configurado
```powershell
# Listar secrets
docker mcp secret ls

# Configurar secret
"sua-api-key" | docker mcp secret set NOME_DA_KEY
```

---

## 📚 REFERÊNCIAS

- [Docker MCP Documentation](https://docs.docker.com/desktop/features/mcp/)
- [Model Context Protocol Spec](https://modelcontextprotocol.io/)
- [MCP Docker Hub](https://hub.docker.com/u/mcp)
- [Tavily MCP](https://docs.tavily.com/documentation/mcp)
