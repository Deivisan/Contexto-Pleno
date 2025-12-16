#!/bin/bash

echo "🔍 Validando Ambiente Termux..."

check_cmd() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "✅ $1: $( $1 --version 2>&1 | head -n 1 )"
    else
        echo "❌ $1: Não instalado"
    fi
}

check_cmd node
check_cmd npm
check_cmd python
check_cmd gh
check_cmd jq
check_cmd git

echo "--------------------------------"
echo "🔍 Verificando Extensões GH..."
gh extension list

echo "--------------------------------"
echo "🔍 Verificando Geminis..."
if [ -f "$HOME/.gemini/settings.json" ]; then
    echo "✅ Gemini Config Found"
else
    echo "❌ Gemini Config Missing"
fi
