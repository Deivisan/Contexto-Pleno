# 📦 MCPs via npm/npx (Android)

Esta pasta documenta os Model Context Protocols (MCPs) instalados via **npm/npx** para uso no ambiente **Android/Termux**.

## 🚀 Instalação

Instale os MCPs usando npm:

```bash
npm install -g @modelcontextprotocol/server-memory
npm install -g @cyanheads/git-mcp-server
npm install -g @upstash/context7-mcp
npm install -g @modelcontextprotocol/server-filesystem
npm install -g tavily-mcp
```

## 📋 MCPs Disponíveis

| MCP | Pacote NPM | Descrição |
|-----|------------|-----------|
| **Memory** | `@modelcontextprotocol/server-memory` | Armazenamento persistente de conhecimento |
| **Git** | `@cyanheads/git-mcp-server` | Integração com Git |
| **Context7** | `@upstash/context7-mcp` | Documentação de bibliotecas |
| **Filesystem** | `@modelcontextprotocol/server-filesystem` | Acesso a arquivos |
| **Tavily** | `tavily-mcp` | Busca web avançada |

## ⚙️ Configuração

Configure os MCPs no seu cliente (ex: Gemini CLI) apontando para os binários globais do npm.

Exemplo para `~/.gemini/settings.json`:

```json
{
  "mcps": {
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "git": {
      "command": "npx",
      "args": ["@cyanheads/git-mcp-server"]
    }
  }
}
```

## 🔗 Integração Universal

Este repositório está migrando para **centralizar MCPs em npm/npx** (por compatibilidade e portabilidade). O legado Docker fica documentado na área de PC como histórico.
