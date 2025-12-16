#!/bin/bash

# 📱 Validação de Ambiente Termux/Android
# Verifica se todas as dependências estão instaladas

echo "🔍 Validando ambiente Termux/Android..."

# Verificar Node.js
if command -v node &> /dev/null; then
    echo "✅ Node.js instalado: $(node --version)"
else
    echo "❌ Node.js não encontrado. Instale via pkg install nodejs"
    exit 1
fi

# Verificar npm
if command -v npm &> /dev/null; then
    echo "✅ npm instalado: $(npm --version)"
else
    echo "❌ npm não encontrado"
    exit 1
fi

# Verificar Python
if command -v python3 &> /dev/null; then
    echo "✅ Python3 instalado: $(python3 --version)"
else
    echo "❌ Python3 não encontrado. Instale via pkg install python"
    exit 1
fi

# Verificar Git
if command -v git &> /dev/null; then
    echo "✅ Git instalado: $(git --version)"
else
    echo "❌ Git não encontrado. Instale via pkg install git"
    exit 1
fi

# Verificar GH CLI
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI instalado: $(gh --version | head -1)"
else
    echo "❌ GitHub CLI não encontrado. Instale via pkg install gh"
    exit 1
fi

echo ""
echo "🎉 Ambiente validado com sucesso!"
echo "Próximo passo: execute ./sync-config.sh"