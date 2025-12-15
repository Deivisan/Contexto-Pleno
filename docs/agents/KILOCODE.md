# ⚡ Kilocode CLI — Configuração MCP

> **Agente:** Kilocode CLI  
> **Versão:** 0.12.1+  
> **Documentação:** https://kilo.ai/docs/features/mcp/overview

---

## 📋 Visão Geral

Kilocode é um agente CLI focado em geração rápida de código e scaffolding. Suporta MCP para estender capacidades com ferramentas externas, incluindo modo orquestrador.

---

## 📁 Arquivos de Configuração

| Escopo | Caminho | Descrição |
|--------|---------|-----------|
| **Global** | `~/.kilocode/settings.json` | Configuração global |
| **Projeto** | `.kilocode/mcp.json` | Configuração do projeto |
| **Alternativo** | `kilocode.config.json` | Na raiz do projeto |

---

## 🔧 Estrutura de Configuração

### Formato Principal

```json
{
  "mcpServers": {
    "nome-do-servidor": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "imagem"],
      "tools": ["tool1", "tool2"],
      "env": {
        "API_KEY": "valor"
      }
    }
  }
}
```

### Formato Alternativo (TOML-like em JSON)

```json
{
  "mcp_servers": {
    "context7": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/context7"],
      "startup_timeout_ms": 20000
    }
  }
}
```

---

## 🐳 Configuração Docker Universal

### Exemplo Completo

```json
{
  "mcpServers": {
    "tavily": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "tools": ["tavily-search", "tavily-extract", "tavily-crawl", "tavily-map"],
      "env": {
        "TAVILY_API_KEY": "<TAVILY_API_KEY>"
      }
    },
    "memory": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"],
      "tools": ["create_entities", "read_graph", "search_nodes", "open_nodes"]
    },
    "fetch": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/fetch"],
      "tools": ["fetch"]
    },
    "filesystem": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "C:/Projetos:/workspace", "mcp/filesystem", "/workspace"],
      "tools": ["read_file", "write_file", "list_directory", "search_files"]
    },
    "playwright": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/playwright"],
      "tools": ["playwright_navigate", "playwright_click", "playwright_screenshot"]
    },
    "context7": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/context7"],
      "tools": ["resolve-library-id", "get-library-docs"],
      "startup_timeout_ms": 30000
    },
    "github": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server", "stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "seu-token-github"
      }
    }
  }
}
```

---

## 🎭 Modos de Operação

### Modo Normal
```bash
kilocode "Create a React component"
```

### Modo Orquestrador
```bash
kilocode --orchestrator "Build a full-stack app with React and Node"
```

### Modo com MCP Específico
```bash
kilocode --mcp tavily "Search for best practices in React"
```

---

## 🛠️ Comandos MCP

### Via UI (Kilo Code IDE)

1. Abrir Settings
2. Navegar para "MCP Servers"
3. Adicionar/editar configuração

### Via CLI

```bash
# Listar MCPs disponíveis
kilocode mcp list

# Testar conexão
kilocode mcp test nome-servidor

# Usar tool específica
kilocode mcp call tavily tavily-search '{"query": "Docker MCP"}'
```

---

## 📊 Propriedades de Configuração

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `type` | String | "local" para STDIO |
| `command` | String | Comando para executar |
| `args` | Array | Argumentos do comando |
| `tools` | Array | Lista de tools disponíveis |
| `env` | Object | Variáveis de ambiente |
| `startup_timeout_ms` | Number | Timeout de inicialização |

---

## 🔌 Transportes Suportados

### STDIO (Local)
- Comunicação via stdin/stdout
- Ideal para Docker containers
- Configuração: `"type": "local"`

### SSE (Remote)
- Server-Sent Events via HTTP
- Para servidores remotos
- Configuração: `"type": "sse", "url": "http://..."`

---

## ✅ Verificação

### Testar Instalação

```bash
# Verificar versão
kilocode --version

# Listar MCPs
kilocode mcp list

# Testar tool
kilocode "Use tavily to search for MCP Docker setup"
```

---

## 🔐 Variáveis de Ambiente

```bash
# Configurar API keys
export TAVILY_API_KEY="sua-tavily-key"
export GITHUB_PERSONAL_ACCESS_TOKEN="seu-github-token"
```

---

## 📚 Referências

- [Kilocode MCP Overview](https://kilo.ai/docs/features/mcp/overview)
- [Using MCP in Kilo Code](https://kilo.ai/docs/features/mcp/using-mcp-in-kilo-code)
- [STDIO & SSE Transports](https://kilo.ai/docs/features/mcp/server-transports)
