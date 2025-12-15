# 🐙 GitHub Copilot CLI — Configuração MCP

> **Agente:** GitHub Copilot CLI  
> **Versão:** 0.0.367+  
> **Documentação:** https://docs.github.com/copilot/how-tos/set-up/install-copilot-cli

---

## 📋 Visão Geral

GitHub Copilot CLI é o agente de linha de comando do GitHub para desenvolvimento assistido por IA. Oferece suporte nativo a MCP para conectar a ferramentas e serviços externos diretamente do terminal.

---

## 📦 Instalação

```bash
# Instalar via npm
npm install -g @github/copilot

# Verificar instalação
copilot --version
```

### Requisitos
- Node.js 22+
- npm 10+
- Assinatura GitHub Copilot ativa

---

## 📁 Arquivos de Configuração

| Escopo | Caminho | Descrição |
|--------|---------|-----------|
| **Global** | `~/.copilot/config.json` | Configuração global |
| **Projeto** | `.github/copilot/mcp.json` | Configuração do projeto |
| **Workspace** | `.copilot-setup-steps.yml` | Setup para Copilot Agent |

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
      "env": {
        "API_KEY": "valor"
      }
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
      "env": {
        "TAVILY_API_KEY": "<TAVILY_API_KEY>"
      }
    },
    "memory": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"]
    },
    "fetch": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/fetch"]
    },
    "filesystem": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "C:/Projetos:/workspace", "mcp/filesystem", "/workspace"]
    },
    "github": {
      "type": "local",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server", "stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "seu-token-github"
      },
      "tools": ["*"]
    }
  }
}
```

---

## 🛠️ Comandos Principais

### Iniciar Sessão Interativa

```bash
copilot
```

### Comandos MCP no REPL

```bash
# Listar servidores MCP
/mcp list

# Conectar a servidor
/mcp connect nome-servidor

# Ver tools disponíveis
/mcp tools

# Usar tool específica
/mcp call tavily tavily-search '{"query": "Docker MCP"}'
```

### Modo Direto

```bash
# Executar comando único
copilot "Search for Docker MCP best practices"

# Com contexto de repositório
copilot --repo owner/repo "Explain this codebase"
```

---

## 🔌 Integração com GitHub MCP Server

O GitHub MCP Server oficial oferece acesso completo à API do GitHub:

```json
{
  "mcpServers": {
    "github": {
      "type": "local",
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server",
        "stdio",
        "--toolsets", "default,actions,gists"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "seu-token"
      }
    }
  }
}
```

### Toolsets Disponíveis

| Toolset | Descrição |
|---------|-----------|
| `context` | Contexto do repositório |
| `repos` | Operações em repositórios |
| `issues` | Gerenciamento de issues |
| `pull_requests` | Pull requests |
| `users` | Informações de usuários |
| `orgs` | Organizações |
| `actions` | GitHub Actions |
| `gists` | Gists |
| `notifications` | Notificações |
| `default` | context, repos, issues, pull_requests, users |
| `all` | Todos os toolsets |

---

## 📊 Propriedades de Configuração

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `type` | String | "local" para STDIO |
| `command` | String | Comando para executar |
| `args` | Array | Argumentos do comando |
| `env` | Object | Variáveis de ambiente |
| `tools` | Array | Tools específicas ou ["*"] para todas |

---

## ✅ Verificação

### Testar Instalação

```bash
# Verificar versão
copilot --version

# Autenticar
copilot auth login

# Testar no REPL
copilot
> /mcp list
```

### Testar MCP

```bash
# No REPL do Copilot
/mcp connect github
/mcp tools
```

---

## 🔐 Autenticação

### Login no GitHub

```bash
copilot auth login
```

### Token de Acesso

```bash
# Configurar token
export GITHUB_PERSONAL_ACCESS_TOKEN="seu-token"

# Ou via arquivo
echo "GITHUB_PERSONAL_ACCESS_TOKEN=seu-token" >> ~/.copilot/.env
```

---

## 🎯 Casos de Uso

### Explorar Codebase

```bash
copilot "Explain the architecture of this project"
```

### Debugging

```bash
copilot "Why is this test failing?" --file tests/unit.test.js
```

### GitHub Integration

```bash
copilot "List my open pull requests"
copilot "Create an issue for this bug"
```

---

## 📚 Referências

- [GitHub Copilot CLI Installation](https://docs.github.com/copilot/how-tos/set-up/install-copilot-cli)
- [Using GitHub Copilot CLI](https://docs.github.com/copilot/how-tos/use-copilot-cli)
- [GitHub MCP Server](https://github.com/github/github-mcp-server)
- [Extending Copilot with MCP](https://docs.github.com/copilot/customizing-copilot/using-model-context-protocol)
