#!/bin/bash

# Caminhos
SOURCE_CONFIG="$(pwd)/termux/configs/mcp-termux.json"
TARGET_CONFIG="$HOME/.gemini/settings.json"

echo "📂 Sincronizando configs MCP..."
echo "➡ Origem: $SOURCE_CONFIG"
echo "➡ Destino: $TARGET_CONFIG"

# Verificar se origem existe
if [ ! -f "$SOURCE_CONFIG" ]; then
    echo "❌ Erro: Arquivo de origem não encontrado!"
    exit 1
fi

# Verificar se destino existe
if [ ! -f "$TARGET_CONFIG" ]; then
    echo "⚠️ Aviso: Configuração destino não encontrada. Criando nova..."
    echo "{}" > "$TARGET_CONFIG"
fi

# Merge usando jq
# Atualiza apenas o bloco mcpServers, mantendo o resto (auth, model, etc.) intacto
tmp_file=$(mktemp)
jq -s '.[0] * {mcpServers: .[1].mcpServers}' "$TARGET_CONFIG" "$SOURCE_CONFIG" > "$tmp_file"

if [ $? -eq 0 ]; then
    mv "$tmp_file" "$TARGET_CONFIG"
    echo "✅ Sincronização concluída com sucesso!"
    echo "🔍 Configuração atualizada:"
    jq '.mcpServers | keys' "$TARGET_CONFIG"
else
    echo "❌ Erro ao processar JSON com jq"
    rm "$tmp_file"
    exit 1
fi
