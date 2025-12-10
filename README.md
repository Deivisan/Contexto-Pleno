# 🚀 Contexto-Pleno — Hub Universal de Agentes IA

> **Repositório central para configuração e orquestração de agentes IA com MCPs Docker universais.**

[![Status](https://img.shields.io/badge/Status-Ativo-success)](/)
[![MCPs](https://img.shields.io/badge/MCPs-9%20Configurados-blue)](/)
[![Docker](https://img.shields.io/badge/Docker-Containers-2496ED)](/)

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura](#-arquitetura)
- [Quick Start](#-quick-start)
- [MCPs Disponíveis](#-mcps-disponíveis)
- [Configuração por IDE/Agente](#-configuração-por-ideagente)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Scripts Úteis](#-scripts-úteis)
- [API Keys](#-api-keys)

---

## 🎯 Visão Geral

Este repositório centraliza a configuração de **MCPs (Model Context Protocol)** via **Docker containers** para uso universal em múltiplos agentes e IDEs:

### 🤖 Agentes CLI Suportados
| Agente | Versão | Status |
|--------|--------|--------|
| **Gemini CLI** | 0.19.4 | ✅ Instalado |
| **Claude Code** | 2.0.60 | ✅ Instalado |
| **Kilocode CLI** | 0.12.1 | ✅ Instalado |
| **GitHub Copilot CLI** | 0.0.367 | ✅ Instalado |

### 💻 IDEs Suportadas
| IDE | MCP Support | Documentação |
|-----|-------------|--------------|
| **Kiro (AWS)** | ✅ Nativo | [docs/ides/KIRO.md](docs/ides/KIRO.md) |
| **VS Code / Insiders** | ✅ Via Copilot | [docs/ides/VSCODE.md](docs/ides/VSCODE.md) |
| **Windsurf** | ✅ Nativo | [docs/ides/WINDSURF.md](docs/ides/WINDSURF.md) |

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                     DOCKER CONTAINERS                            │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │ context7  │ │  tavily   │ │  memory   │ │   fetch   │       │
│  │ HTTP:8080 │ │   STDIO   │ │   STDIO   │ │   STDIO   │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │filesystem │ │playwright │ │    git    │ │  github   │       │
│  │   STDIO   │ │   STDIO   │ │   STDIO   │ │   STDIO   │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │   Kiro   │   │  VS Code │   │ Windsurf │
        │   (AWS)  │   │ Insiders │   │(Codeium) │
        └──────────┘   └──────────┘   └──────────┘
              │               │               │
              ▼               ▼               ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │  Gemini  │   │  Claude  │   │ Kilocode │
        │   CLI    │   │   Code   │   │   CLI    │
        └──────────┘   └──────────┘   └──────────┘
```

---

## ⚡ Quick Start

### 1. Pré-requisitos

```powershell
# Verificar Docker
docker --version  # v29.1.2+

# Verificar Node.js
node --version    # v25.2.1+
```

### 2. Iniciar Container Context7 (HTTP/SSE)

```powershell
# Container sempre rodando na porta 8080
docker run -d `
  --name mcp-context7 `
  -p 8080:8080 `
  --restart unless-stopped `
  mcp/context7:latest
```

### 3. Criar Volume para Memory

```powershell
docker volume create mcp-memory-data
```

### 4. Aplicar Configuração

```powershell
# Copiar config universal para Kiro
Copy-Item "MCPS/configs/universal-docker.json" "$env:USERPROFILE\.kiro\settings\mcp.json"

# Ou para VS Code
Copy-Item "MCPS/configs/universal-docker.json" ".vscode/mcp.json"
```

### 5. Verificar

```powershell
# Ver containers rodando
docker ps --filter "name=mcp"

# Testar endpoint Context7
curl http://localhost:8080/sse
```

---

## 🐳 MCPs Disponíveis

| MCP | Imagem | Tipo | Status | Tools |
|-----|--------|------|--------|-------|
| **Context7** | `mcp/context7` | HTTP/SSE | ✅ Ativo | 2 |
| **Tavily** | `mcp/tavily` | STDIO | ✅ Ativo | 4 |
| **Memory** | `mcp/memory` | STDIO | ✅ Ativo | 9 |
| **Fetch** | `mcp/fetch` | STDIO | ✅ Ativo | 1 |
| **Filesystem** | `mcp/filesystem` | STDIO | ✅ Ativo | 7 |
| **Playwright** | `mcp/playwright` | STDIO | ✅ Ativo | 20+ |
| **Sequential Thinking** | `mcp/sequentialthinking` | STDIO | ⏸️ Disponível | - |
| **Git** | `mcp/git` | STDIO | ⏸️ Disponível | - |
| **GitHub** | `ghcr.io/github/github-mcp-server` | STDIO | ⏸️ Disponível | 50+ |

> 📖 Documentação completa: [docs/mcps/DOCKER-MCPS.md](docs/mcps/DOCKER-MCPS.md)

---

## ⚙️ Configuração por IDE/Agente

### Kiro (AWS)

```json
// ~/.kiro/settings/mcp.json
{
  "mcpServers": {
    "tavily": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": { "TAVILY_API_KEY": "sua-key" }
    },
    "context7": {
      "url": "http://localhost:8080/sse"
    }
  }
}
```

> 📖 Guia completo: [docs/ides/KIRO.md](docs/ides/KIRO.md)

### VS Code / Insiders

```json
// .vscode/mcp.json
{
  "servers": {
    "tavily": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": { "TAVILY_API_KEY": "sua-key" }
    }
  }
}
```

> 📖 Guia completo: [docs/ides/VSCODE.md](docs/ides/VSCODE.md)

### Windsurf

```json
// ~/.codeium/windsurf/mcp_config.json
{
  "mcpServers": {
    "tavily": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": { "TAVILY_API_KEY": "sua-key" }
    }
  }
}
```

> 📖 Guia completo: [docs/ides/WINDSURF.md](docs/ides/WINDSURF.md)

### Agentes CLI

| Agente | Config File | Guia |
|--------|-------------|------|
| Gemini CLI | `.gemini/settings.json` | [docs/agents/GEMINI-CLI.md](docs/agents/GEMINI-CLI.md) |
| Claude Code | `~/.claude.json` | [docs/agents/CLAUDE-CODE.md](docs/agents/CLAUDE-CODE.md) |
| Kilocode | `.kilocode/mcp.json` | [docs/agents/KILOCODE.md](docs/agents/KILOCODE.md) |
| Copilot CLI | `~/.copilot/config.json` | [docs/agents/GITHUB-COPILOT-CLI.md](docs/agents/GITHUB-COPILOT-CLI.md) |

---

## 📁 Estrutura do Repositório

```
Contexto-Pleno/
├── 📄 README.md                    # Este arquivo
├── 📄 ROADMAP-MCP-UNIVERSAL.md     # Roadmap e progresso
├── 📄 PC-Context.md                # Contexto do PC
├── 📄 Banco-Api.md                 # Central de API keys
│
├── 📁 docs/                        # Documentação
│   ├── 📁 ides/                    # Guias por IDE
│   │   ├── KIRO.md
│   │   ├── VSCODE.md
│   │   └── WINDSURF.md
│   ├── 📁 agents/                  # Guias por agente CLI
│   │   ├── GEMINI-CLI.md
│   │   ├── CLAUDE-CODE.md
│   │   ├── KILOCODE.md
│   │   └── GITHUB-COPILOT-CLI.md
│   └── 📁 mcps/                    # Documentação MCPs
│       └── DOCKER-MCPS.md
│
├── 📁 MCPS/                        # Configurações MCP
│   ├── 📁 configs/                 # Configs universais
│   │   ├── universal-docker.json   # Config principal
│   │   └── .env                    # Variáveis de ambiente
│   └── 📁 Docker/                  # Arquivos Docker
│       ├── docker-compose.yml
│       ├── .env
│       └── test-results-*.md
│
├── 📁 scripts/                     # Scripts de automação
│   ├── start-mcp-context7.ps1      # Auto-start Context7
│   ├── setup-windows.ps1           # Setup inicial
│   ├── validate-agents.ps1         # Validar agentes
│   └── test-mcps.ps1               # Testar MCPs
│
└── 📁 Arquivos de Agentes          # Contexto por agente
    ├── DevSan.md                   # Core personality
    ├── Gemini.md
    ├── KILOCODE.md
    └── QWEN.md
```

---

## 🛠️ Scripts Úteis

### Iniciar Context7

```powershell
pwsh ./scripts/start-mcp-context7.ps1
```

### Validar Agentes Instalados

```powershell
pwsh ./scripts/validate-agents.ps1
```

### Testar MCPs

```powershell
pwsh ./scripts/test-mcps.ps1
```

### Setup Completo Windows

```powershell
pwsh ./scripts/setup-windows.ps1
```

---

## 🔑 API Keys

As API keys estão centralizadas em:
- **Arquivo principal:** `Banco-Api.md`
- **Variáveis de ambiente:** `MCPS/configs/.env`

### Keys Configuradas

| Serviço | Variável | Status |
|---------|----------|--------|
| Tavily | `TAVILY_API_KEY` | ✅ |
| Context7 | `CONTEXT7_API_KEY` | ✅ |
| GitHub | `GITHUB_PERSONAL_ACCESS_TOKEN` | ✅ |
| Google AI | `GOOGLE_API_KEY` | ✅ |
| OpenRouter | `OPENROUTER_API_KEY` | ✅ |

---

## 🖥️ Sistema

| Componente | Valor |
|------------|-------|
| **PC** | DEIVIPC |
| **OS** | Windows 10 Pro (Build 26220) |
| **CPU** | AMD Ryzen 7 5700G (16 threads) |
| **RAM** | 32GB |
| **Docker** | v29.1.2 (Desktop + WSL2) |
| **Node.js** | v25.2.1 |
| **Python** | 3.14.2 |

---

## 📚 Referências

- [Model Context Protocol](https://modelcontextprotocol.io)
- [Docker MCP Catalog](https://hub.docker.com/catalogs/mcp)
- [MCP Specification](https://spec.modelcontextprotocol.io)

---

## 📄 Licença

MIT — Sinta-se livre para adaptar e replicar.

---

<p align="center">
  <strong>Desenvolvido por Deivison Santana (@deivisan)</strong>
</p>
