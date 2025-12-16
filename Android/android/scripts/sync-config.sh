#!/bin/bash

set -euo pipefail

# Caminhos (robustos independente do diretório atual)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Preferência: arquivos locais (ignorados no git) > templates/versionados
SOURCE_CANDIDATES=(
    "$SCRIPT_DIR/../configs/mcp-android.local.json"
    "$SCRIPT_DIR/../configs/mcp-termux.local.json"
    "$SCRIPT_DIR/../configs/mcp-android.json"
    "$SCRIPT_DIR/../configs/mcp-termux.json"
    "$SCRIPT_DIR/../configs/mcp-android.example.json"
)

SOURCE_CONFIG=""
for f in "${SOURCE_CANDIDATES[@]}"; do
    if [ -f "$f" ]; then
        SOURCE_CONFIG="$f"
        break
    fi
done

TARGET_CONFIG="$HOME/.gemini/settings.json"

echo "📂 Sincronizando configs MCP..."
echo "➡ Origem: $SOURCE_CONFIG"
echo "➡ Destino: $TARGET_CONFIG"

if [ -z "$SOURCE_CONFIG" ]; then
    echo "❌ Erro: Nenhum arquivo de configuração MCP encontrado."
    echo "➡ Crie um arquivo local em: $SCRIPT_DIR/../configs/mcp-android.local.json"
    echo "➡ Ou use o template: $SCRIPT_DIR/../configs/mcp-android.example.json"
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

