# 📱 Contexto-Pleno: Edição Android (Termux)

Esta pasta contém a adaptação do projeto **Contexto-Pleno** para o ambiente Android/Termux.

## 📂 Estrutura

- `scripts/`: Scripts de automação Bash.
- `configs/`: Configurações JSON adaptadas (sem Docker).
- `logs/`: Logs locais.

## 🚀 Como Usar

### 1. Validar Ambiente
Verifique se todas as dependências estão instaladas:
```bash
./scripts/validate-env.sh
```

### 2. Sincronizar Configurações MCP
Este script atualiza o `~/.gemini/settings.json` com os caminhos corretos para o Termux:
```bash
./scripts/sync-config.sh
```

### 3. MCPs via npm/npx
Os MCPs usados no Android ficam documentados em `./mcp/`.

## 🛠️ Ajustes Manuais Necessários

### GitHub Copilot Alias
Para usar o comando `copilot` diretamente (mapeado para `gh copilot`), adicione ao seu `~/.zshrc` ou `~/.aliases`:

```bash
# Copilot Alias
eval "$(gh copilot alias -- bash)"
```
Ou manualmente:
```bash
alias copilot='gh copilot'
```

## 📦 MCPs Suportados (Nativo)

| MCP | Comando | Status |
|-----|---------|--------|
| **Tavily** | `npx tavily-mcp` | ✅ Configurado |
| **Memory** | `npx @modelcontextprotocol/server-memory` | ✅ Configurado |
| **Git** | `npx @cyanheads/git-mcp-server` | ✅ Configurado |
| **Context7** | `npx @upstash/context7-mcp` | ✅ Configurado |
| **Filesystem**| `npx @modelcontextprotocol/server-filesystem` | ✅ Configurado |
| **Android** | `node ~/scripts/android-mcp` | ✅ Configurado |

---
**Nota:** A configuração Docker original foi substituída por execução direta `npx`/`node` para compatibilidade com Termux.
