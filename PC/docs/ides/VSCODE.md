# 💻 VS Code / VS Code Insiders — Configuração MCP

> **IDE:** Visual Studio Code / VS Code Insiders  
> **Extensão:** GitHub Copilot Chat  
> **Documentação:** https://code.visualstudio.com/docs/copilot/chat/mcp-servers

---

## 📋 Visão Geral

VS Code suporta MCP através da extensão GitHub Copilot Chat. A configuração pode ser feita via GUI ou editando arquivos JSON diretamente.

---

## 📁 Arquivos de Configuração

| Escopo | Caminho Windows | Descrição |
|--------|-----------------|-----------|
| **User Settings** | `%APPDATA%\Code\User\settings.json` | Configurações globais |
| **User Settings (Insiders)** | `%APPDATA%\Code - Insiders\User\settings.json` | VS Code Insiders |
| **Workspace** | `.vscode/settings.json` | Específico do projeto |
| **MCP Dedicado** | `.vscode/mcp.json` | Arquivo dedicado para MCP |

---

## 🔧 Estrutura de Configuração

### Via settings.json

```json
{
  "mcp": {
    "inputs": [],
    "servers": {
      "nome-do-servidor": {
        "command": "docker",
        "args": ["run", "-i", "--rm", "mcp/tavily"],
        "env": {
          "TAVILY_API_KEY": "sua-api-key"
        }
      }
    }
  }
}
```

### Via .vscode/mcp.json (Recomendado)

```json
{
  "servers": {
    "tavily": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": {
        "TAVILY_API_KEY": "sua-api-key"
      }
    },
    "memory": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"]
    },
    "context7": {
      "type": "sse",
      "url": "http://localhost:8080/sse"
    }
  }
}
```

---

## 🐳 Configuração Docker Universal

### Exemplo Completo

```json
{
  "servers": {
    "tavily": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": {
        "TAVILY_API_KEY": "<TAVILY_API_KEY>"
      }
    },
    "memory": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"]
    },
    "fetch": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/fetch"]
    },
    "filesystem": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "C:/Projetos:/workspace", "mcp/filesystem", "/workspace"]
    },
    "playwright": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/playwright"]
    },
    "context7": {
      "type": "sse",
      "url": "http://localhost:8080/sse"
    },
    "github": {
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

## 🛠️ Métodos de Configuração

### 1. Via Extensions (GUI)

1. Abrir Command Palette (`Ctrl+Shift+P`)
2. Buscar "MCP: Add Server"
3. Seguir o wizard de configuração

### 2. Via Settings UI

1. `Ctrl+,` para abrir Settings
2. Buscar "mcp"
3. Editar em "Edit in settings.json"

### 3. Via Arquivo Direto

1. Criar `.vscode/mcp.json` no workspace
2. Adicionar configuração JSON
3. Salvar e recarregar

---

## 🔌 Docker MCP Gateway

VS Code pode usar o Docker MCP Gateway para conectar a múltiplos servidores:

```json
{
  "servers": {
    "docker-gateway": {
      "command": "docker",
      "args": ["mcp", "gateway", "run", "--transport", "stdio"]
    }
  }
}
```

---

## 📊 Propriedades de Configuração

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `command` | String | Comando para executar (ex: "docker", "npx") |
| `args` | Array | Argumentos do comando |
| `env` | Object | Variáveis de ambiente |
| `type` | String | Tipo de transporte: "stdio" ou "sse" |
| `url` | String | URL para servidores SSE |

---

## ✅ Verificação

### Verificar Servidores Configurados

1. Abrir Copilot Chat
2. Mudar para "Agent mode"
3. Clicar no ícone de ferramentas (tools icon)
4. Ver lista de MCP servers conectados

### Testar Conexão

No chat do Copilot, digite:
```
@workspace use the tavily tool to search for "MCP Docker"
```

---

## 🔐 Segurança

- Use variáveis de ambiente para credenciais sensíveis
- Adicione `.vscode/mcp.json` ao `.gitignore` se contiver secrets
- Prefira Docker containers para isolamento

---

## 📚 Referências

- [VS Code MCP Documentation](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)
- [GitHub Copilot MCP](https://docs.github.com/copilot/customizing-copilot/using-model-context-protocol)
- [Docker MCP Catalog](https://hub.docker.com/catalogs/mcp)
