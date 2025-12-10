# 🚀 Kiro IDE — Configuração MCP

> **IDE:** Kiro (AWS)  
> **Versão:** Latest  
> **Documentação:** https://docs.kiro.dev/mcp/configuration

---

## 📋 Visão Geral

Kiro é uma IDE da AWS com suporte nativo a Model Context Protocol (MCP). Suporta tanto servidores locais (STDIO) quanto remotos (HTTP/SSE).

---

## 📁 Arquivos de Configuração

| Escopo | Caminho | Descrição |
|--------|---------|-----------|
| **Global (User)** | `~/.kiro/settings/mcp.json` | Aplica a todos os workspaces |
| **Workspace** | `.kiro/settings/mcp.json` | Específico do projeto |

> **Precedência:** Workspace > User (configurações do workspace sobrescrevem as globais)

---

## 🔧 Estrutura de Configuração

### Servidor Local (STDIO)

```json
{
  "mcpServers": {
    "nome-do-servidor": {
      "command": "comando-para-executar",
      "args": ["arg1", "arg2"],
      "env": {
        "VAR1": "valor-fixo",
        "VAR2": "${VARIAVEL_EXPANDIDA}"
      },
      "disabled": false,
      "autoApprove": ["tool_name1", "tool_name2"],
      "disabledTools": ["tool_name3"]
    }
  }
}
```

### Servidor Remoto (HTTP/SSE)

```json
{
  "mcpServers": {
    "nome-do-servidor": {
      "url": "http://localhost:8080/sse",
      "headers": {
        "Authorization": "Bearer ${TOKEN}"
      },
      "disabled": false,
      "autoApprove": ["tool_name1"]
    }
  }
}
```

---

## 🐳 Configuração Docker Universal

### Exemplo Completo (Docker STDIO)

```json
{
  "mcpServers": {
    "tavily": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
      "env": {
        "TAVILY_API_KEY": "sua-api-key"
      },
      "disabled": false,
      "autoApprove": ["tavily-search", "tavily-extract"]
    },
    "memory": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"],
      "disabled": false,
      "autoApprove": ["create_entities", "read_graph"]
    },
    "context7": {
      "url": "http://localhost:8080/sse",
      "disabled": false,
      "autoApprove": ["resolve-library-id", "get-library-docs"]
    }
  }
}
```

---

## 📊 Propriedades de Configuração

### Servidor Local

| Propriedade | Tipo | Obrigatório | Descrição |
|-------------|------|-------------|-----------|
| `command` | String | ✅ | Comando para executar o servidor |
| `args` | Array | ✅ | Argumentos do comando |
| `env` | Object | ❌ | Variáveis de ambiente |
| `disabled` | Boolean | ❌ | Desabilitar servidor (default: false) |
| `autoApprove` | Array | ❌ | Tools para aprovar automaticamente |
| `disabledTools` | Array | ❌ | Tools para desabilitar |

### Servidor Remoto

| Propriedade | Tipo | Obrigatório | Descrição |
|-------------|------|-------------|-----------|
| `url` | String | ✅ | Endpoint HTTPS/HTTP (localhost aceita HTTP) |
| `headers` | Object | ❌ | Headers para conexão |
| `disabled` | Boolean | ❌ | Desabilitar servidor |
| `autoApprove` | Array | ❌ | Tools para aprovar automaticamente |

---

## 🛠️ Comandos Úteis

### Via Command Palette

- `Cmd/Ctrl + Shift + P` → "Kiro: Open workspace MCP config (JSON)"
- `Cmd/Ctrl + Shift + P` → "Kiro: Open user MCP config (JSON)"

### Via Kiro Panel

1. Abrir Kiro Panel
2. Clicar no ícone "Open MCP Config"

---

## ✅ Verificação

Após salvar o arquivo de configuração, os servidores reconectam automaticamente. Não é necessário reiniciar o Kiro.

---

## 🔐 Segurança

- Use referências de variáveis de ambiente (`${API_KEY}`) ao invés de valores hardcoded
- Nunca commite arquivos de configuração com credenciais
- Conecte apenas a servidores remotos confiáveis
- Revise permissões antes de adicionar ao `autoApprove`

---

## 📚 Referências

- [Kiro MCP Configuration](https://docs.kiro.dev/mcp/configuration)
- [Kiro MCP Security](https://docs.kiro.dev/mcp/security)
