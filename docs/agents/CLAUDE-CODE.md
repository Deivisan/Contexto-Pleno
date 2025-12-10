# 🤖 Claude Code — Configuração MCP

> **Agente:** Claude Code (Anthropic)  
> **Versão:** 2.0.60+  
> **Documentação:** https://code.claude.com/docs

---

## 📋 Visão Geral

Claude Code é o agente de linha de comando da Anthropic para desenvolvimento assistido por IA. Suporta MCP nativamente para estender capacidades com ferramentas externas.

---

## 📁 Arquivos de Configuração

| Escopo | Caminho | Descrição |
|--------|---------|-----------|
| **Global** | `~/.claude.json` | Configuração principal |
| **Projeto** | `.claude/settings.json` | Configuração do projeto |
| **Local** | `.claude/settings.local.json` | Configuração local (gitignore) |
| **MCP Dedicado** | `~/.claude/mcp_servers.json` | Arquivo dedicado para MCP |
| **Enterprise** | `/etc/claude-code/managed-settings.json` | Políticas enterprise |

---

## 🔧 Estrutura de Configuração

### ~/.claude.json

```json
{
  "mcpServers": {
    "nome-do-servidor": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "imagem"],
      "env": {
        "API_KEY": "valor"
      }
    }
  }
}
```

### .claude/settings.json

```json
{
  "permissions": {
    "allow": ["read", "write", "execute"],
    "deny": [".env", "*.key", "secrets/*"]
  },
  "mcpServers": {
    "tavily": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"]
    }
  }
}
```

---

## 🐳 Configuração Docker Universal

### Exemplo Completo (~/.claude.json)

```json
{
  "mcpServers": {
    "tavily": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": {
        "TAVILY_API_KEY": "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"
      }
    },
    "memory": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"]
    },
    "fetch": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/fetch"]
    },
    "filesystem": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "C:/Projetos:/workspace", "mcp/filesystem", "/workspace"]
    },
    "playwright": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/playwright"]
    },
    "context7": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-p", "8080:8080", "mcp/context7"]
    },
    "github": {
      "type": "stdio",
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

## 🛠️ Comandos MCP

### Adicionar Servidor via CLI

```bash
# Adicionar servidor interativamente
claude mcp add

# Adicionar via JSON
claude mcp add-json nome-servidor '{"type":"stdio","command":"docker","args":["run","-i","--rm","mcp/tavily"]}'
```

### Listar Servidores

```bash
claude mcp list
```

### Remover Servidor

```bash
claude mcp remove nome-servidor
```

### Conectar a Servidor

```bash
# No REPL
/mcp connect nome-servidor
```

---

## 📊 Propriedades de Configuração

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `type` | String | Tipo de transporte: "stdio" |
| `command` | String | Comando para executar |
| `args` | Array | Argumentos do comando |
| `env` | Object | Variáveis de ambiente |

---

## 🔒 Configuração de Permissões

### .claude/settings.json

```json
{
  "permissions": {
    "allow": [
      "read",
      "write",
      "execute",
      "mcp"
    ],
    "deny": [
      ".env",
      "*.key",
      "*.pem",
      "secrets/*",
      "**/credentials*"
    ]
  }
}
```

---

## ✅ Verificação

### Testar Instalação

```bash
# Verificar versão
claude --version

# Abrir REPL
claude

# No REPL, verificar MCPs
/mcp list

# Testar tool
/mcp connect tavily
```

### Verificar Configuração

```bash
# Abrir configuração
claude /config
```

---

## 🔐 Variáveis de Ambiente

```bash
# API Key do Anthropic
export ANTHROPIC_API_KEY="sua-api-key"

# Ou via arquivo
echo "ANTHROPIC_API_KEY=sua-api-key" >> ~/.claude/.env
```

---

## 📚 Referências

- [Claude Code Documentation](https://code.claude.com/docs)
- [Claude Code Settings](https://code.claude.com/docs/en/settings)
- [Claude Code MCP](https://code.claude.com/docs/en/mcp)
