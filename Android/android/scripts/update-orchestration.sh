#!/bin/bash

ORCHESTRATION_FILE="ORCHESTRATION.md"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "🔄 Atualizando ORCHESTRATION.md com status do Termux..."

# Usar sed para substituir o status do Gemini (método simples, pode ser melhorado com yq se disponível e estruturado)
# Como o arquivo é Markdown misturado com YAML/texto, sed é arriscado mas eficaz para one-liners.

if [ -f "$ORCHESTRATION_FILE" ]; then
    # Atualiza timestamp
    sed -i "s/Última Atualização: .*/Última Atualização: $DATE/" "$ORCHESTRATION_FILE"
    
    # Atualiza status Gemini (se encontrar a linha exata)
    sed -i 's/status: ❌ Broken (binário não acessível)/status: ✅ Operational (Termux Native)/' "$ORCHESTRATION_FILE"
    sed -i 's/issue: "Arquivos .gemini.cmd estranhos, npm install corrompeu PATH"/mode: Native Node MCPs/' "$ORCHESTRATION_FILE"
    
    echo "✅ Status atualizado!"
    grep -A 5 "Gemini-CLI:" "$ORCHESTRATION_FILE"
else
    echo "❌ Arquivo ORCHESTRATION.md não encontrado em $ORCHESTRATION_FILE"
fi
