# 🌟 Gemini CLI — Configuração MCP

> **Agente:** Gemini CLI (Google)  
> **Versão:** 0.19.4+  
> **Documentação:** https://github.com/google-gemini/gemini-cli

---

## 📋 Visão Geral

Gemini CLI é o agente de linha de comando do Google para interagir com modelos Gemini. Suporta MCP para estender suas capacidades com ferramentas externas.

---

## 📁 Arquivos de Configuração

| Escopo | Caminho | Descrição |
|--------|---------|-----------|
| **Projeto** | `.gemini/settings.json` | Configuração do projeto |
| **Sistema (Linux)** | `/etc/gemini-cli/settings.json` | Configuração global |
| **Sistema (Windows)** | `%PROGRAMDATA%\gemini-cli\settings.json` | Configuração global |
| **Contexto** | `GEMINI.md` | Arquivo de contexto do projeto |

---

## 🔧 Estrutura de Configuração

### settings.json

```json
{
  "mcpServers": {
    "nome-do-servidor": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "imagem"],
      "env": {
        "API_KEY": "valor"
      }
    }
  },
  "theme": "dark",
  "sandbox": false
}
```

---

## 🐳 Configuração Docker Universal

### Exemplo Completo (.gemini/settings.json)

```json
{
  "mcpServers": {
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
    "context7": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-p", "8080:8080", "mcp/context7"]
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

## 🛠️ Comandos MCP

### Listar Servidores MCP

```bash
gemini /mcp list
```

### Adicionar Servidor MCP

```bash
gemini /mcp add nome-servidor
```

### Verificar Status

```bash
gemini /mcp status
```

### Usar Tool Específica

```bash
gemini "Use the tavily tool to search for Docker MCP"
```

---

## 📊 Configurações Adicionais

| Configuração | Tipo | Descrição |
|--------------|------|-----------|
| `theme` | String | Tema visual ("dark", "light") |
| `sandbox` | Boolean | Modo sandbox para segurança |
| `model` | String | Modelo Gemini a usar |
| `temperature` | Number | Temperatura de geração |

---

## 📝 Arquivo de Contexto (GEMINI.md)

Crie um arquivo `GEMINI.md` na raiz do projeto para fornecer contexto ao Gemini:

```markdown
# Contexto do Projeto

Este projeto usa MCPs via Docker para:
- Busca web (Tavily)
- Memória persistente (Memory)
- Documentação (Context7)

## Comandos Úteis

- `/mcp list` - Listar MCPs disponíveis
- `/mcp status` - Ver status dos MCPs
```

---

## ✅ Verificação

### Testar Instalação

```bash
# Verificar versão
gemini --version

# Verificar MCPs
gemini /mcp list

# Testar tool
gemini "Search for MCP Docker setup using tavily"
```

---

## 🔐 Variáveis de Ambiente

```bash
# API Key do Gemini
export GOOGLE_API_KEY="sua-api-key"

# Ou via arquivo .gemini/.env
GOOGLE_API_KEY=sua-api-key
TAVILY_API_KEY=sua-tavily-key
```

---

## 📚 Referências

- [Gemini CLI GitHub](https://github.com/google-gemini/gemini-cli)
- [Gemini CLI Configuration](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/configuration.md)
- [Google AI Studio](https://aistudio.google.com/)
