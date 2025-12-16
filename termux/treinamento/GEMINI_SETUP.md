# 💎 GEMINI SETUP: Termux Edition

Esta é a minha configuração "ideal" para operar no máximo potencial dentro do Termux.

## 1. Configuração JSON (`~/.gemini/settings.json`)

```json
{
  "mcpServers": {
    "tavily": {
      "command": "npx",
      "args": ["-y", "tavily-mcp"],
      "env": {
        "TAVILY_API_KEY": "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"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_FILE_PATH": "/data/data/com.termux/files/home/.gemini/memory.json"
      }
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@cyanheads/git-mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "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",
        "GIT_GLOBAL_CONFIG": "true"
      }
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {
        "CONTEXT7_API_KEY": "ctx7sk-3e991779-425e-468d-8907-ffe3e5171a4e"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/data/data/com.termux/files/home/Projetos"],
      "env": {}
    },
    "android-control": {
      "command": "node",
      "args": ["/data/data/com.termux/files/home/scripts/android-mcp/index.js"],
      "env": {
        "ADB_PORT": "5555" 
      }
    }
  },
  "model": {
    "name": "gemini-2.0-flash-exp" 
  },
  "security": {
    "auth": {
      "selectedType": "oauth-personal"
    }
  }
}
```

## 2. Variáveis de Ambiente Essenciais (`~/.profile` ou `.zshrc`)

Para que eu funcione sem "tropeçar", estas variáveis precisam estar no ambiente global do Termux:

```bash
export TAVILY_API_KEY="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"
export GITHUB_PERSONAL_ACCESS_TOKEN="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"
export CONTEXT7_API_KEY="ctx7sk-3e991779-425e-468d-8907-ffe3e5171a4e"
# Google Key já costuma estar configurada, mas vale reforçar se usar scripts custom
```

## 3. Integração com "Agent Squad"

Para eu chamar os outros, preciso que os comandos estejam no PATH:

*   `qwen`: Deve chamar o script de execução do Qwen.
*   `kilocode`: Deve chamar o CLI do Kilocode.
*   `copilot`: Deve ser um alias para `gh copilot`.

## 4. Auto-Conhecimento (Memory)

Devo popular o `memory.json` com:
*   Localização dos scripts: `/data/data/com.termux/files/home/scripts`
*   IP Local: `172.17.9.9` (ou dinâmico)
*   Preferências do Deivi: "Português BR", "YOLO Mode", "Disruptivo".

---
**Status:** Pronto para iterar.
