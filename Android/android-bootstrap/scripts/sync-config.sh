#!/bin/bash

# 🔄 Sincronização de Configurações MCP
# Atualiza ~/.gemini/settings.json com caminhos corretos para Termux

echo "🔄 Sincronizando configurações MCP..."

CONFIG_DIR="$HOME/.gemini"
CONFIG_FILE="$CONFIG_DIR/settings.json"

# Criar diretório se não existir
mkdir -p "$CONFIG_DIR"

# Configuração básica para Termux
cat > "$CONFIG_FILE" << 'EOF'
{
  "mcps": {
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "git": {
      "command": "npx",
      "args": ["@cyanheads/git-mcp-server"]
    },
    "context7": {
      "command": "npx",
      "args": ["@upstash/context7-mcp"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/sdcard"]
    },
    "tavily": {
      "command": "npx",
      "args": ["tavily-mcp"]
    }
  },
  "environment": {
    "platform": "android",
    "termux": true,
    "workspace": "/data/data/com.termux/files/home/Contexto-Pleno"
  }
}
EOF

echo "✅ Configuração sincronizada em $CONFIG_FILE"
echo "🎉 Pronto para usar agentes no Termux!"