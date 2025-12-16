# 🏄 Windsurf IDE — Configuração MCP

> **IDE:** Windsurf (Codeium)  
> **Versão:** Latest  
> **Documentação:** https://docs.codeium.com/windsurf/mcp

---

## 📋 Visão Geral

Windsurf é uma IDE AI-native da Codeium com suporte integrado a Model Context Protocol (MCP). Suporta servidores locais (STDIO) e remotos (SSE).

---

## 📁 Arquivos de Configuração

| Escopo | Caminho Windows | Descrição |
|--------|-----------------|-----------|
| **Global** | `~/.codeium/windsurf/mcp_config.json` | Configuração global |
| **Alternativo** | `~/.config/windsurf/settings/mcp.json` | Formato alternativo |
| **Workspace** | `.windsurf/mcp.json` | Específico do projeto |

> **Nota:** O caminho exato pode variar conforme a versão do Windsurf.

---

## 🔧 Estrutura de Configuração

### Formato Principal

```json
{
  "mcpServers": {
    "nome-do-servidor": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "imagem"],
      "env": {
        "API_KEY": "valor"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

### Servidor SSE/HTTP

```json
{
  "mcpServers": {
    "context7": {
      "serverUrl": "http://localhost:8080/sse",
      "disabled": false
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
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": {
        "TAVILY_API_KEY": "<TAVILY_API_KEY>"
      },
      "disabled": false,
      "autoApprove": ["tavily-search", "tavily-extract"]
    },
    "memory": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"],
      "disabled": false,
      "autoApprove": ["create_entities", "read_graph", "search_nodes"]
    },
    "fetch": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/fetch"],
      "disabled": false,
      "autoApprove": ["fetch"]
    },
    "filesystem": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "C:/Projetos:/workspace", "mcp/filesystem", "/workspace"],
      "disabled": false,
      "autoApprove": ["read_file", "list_directory"]
    },
    "playwright": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/playwright"],
      "disabled": false,
      "autoApprove": ["playwright_navigate", "playwright_screenshot"]
    },
    "context7": {
      "serverUrl": "http://localhost:8080/sse",
      "disabled": false,
      "autoApprove": ["resolve-library-id", "get-library-docs"]
    },
    "github": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server", "stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "seu-token-github"
      },
      "disabled": true,
      "autoApprove": []
    }
  }
}
```

---

## 🛠️ Métodos de Configuração

### 1. Via Settings UI

1. Abrir Windsurf Settings (`Ctrl+,`)
2. Navegar para "Advanced Settings"
3. Encontrar seção "Cascade" → "MCP"
4. Habilitar MCP e configurar servidores

### 2. Via Command Palette

1. `Ctrl+Shift+P`
2. Buscar "Windsurf: Configure MCP"
3. Editar configuração JSON

### 3. Via Arquivo Direto

1. Criar/editar `~/.codeium/windsurf/mcp_config.json`
2. Adicionar configuração
3. Reiniciar Windsurf

---

## 📊 Propriedades de Configuração

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `command` | String | Comando para executar servidor STDIO |
| `args` | Array | Argumentos do comando |
| `env` | Object | Variáveis de ambiente |
| `serverUrl` | String | URL para servidores SSE/HTTP |
| `disabled` | Boolean | Desabilitar servidor |
| `autoApprove` | Array | Tools para aprovar automaticamente |

---

## 🔌 Tipos de Servidor Suportados

### STDIO (Local)
- Executa via comando local
- Comunicação via stdin/stdout
- Ideal para Docker containers

### SSE (Server-Sent Events)
- Conecta via HTTP/HTTPS
- Servidor deve estar rodando
- Ideal para serviços compartilhados

---

## ✅ Verificação

### Verificar Conexão

1. Abrir Windsurf
2. Abrir Cascade (AI Assistant)
3. Verificar se tools MCP aparecem disponíveis
4. Testar com um comando simples

### Logs de Debug

```powershell
# Ver logs do Windsurf
Get-Content "$env:USERPROFILE\.codeium\windsurf\logs\*.log" -Tail 50
```

---

## 🔐 Segurança

- Armazene credenciais em variáveis de ambiente
- Use `autoApprove` com cautela
- Prefira containers Docker para isolamento
- Não commite arquivos com secrets

---

## 📚 Referências

- [Windsurf Documentation](https://docs.codeium.com/windsurf)
- [Windsurf MCP Setup](https://docs.codeium.com/windsurf/mcp)
- [Docker MCP Catalog](https://hub.docker.com/catalogs/mcp)
