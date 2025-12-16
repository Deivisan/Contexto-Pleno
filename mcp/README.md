# 📦 MCP (npm/npx) — configuração universal

Este diretório centraliza a estratégia **padrão** do repo: rodar MCPs via **npm/npx** tanto no **PC (Windows)** quanto no **Android (Termux)**.

> Status: **Docker em pausa** (por incompatibilidades no Windows). O legado Docker fica preservado em `PC/MCPS/` como histórico.

## ✅ Princípios

- **Sem Docker** como dependência obrigatória.
- MCPs executados com `npx -y <pacote>` (ou binários globais do npm).
- **Segredos nunca versionados**: use `.env` local ou `*.local.json`.

## 📋 MCPs recomendados (base)

- `tavily-mcp`
- `@modelcontextprotocol/server-memory`
- `@cyanheads/git-mcp-server`
- `@upstash/context7-mcp`
- `@modelcontextprotocol/server-filesystem`

## 🔧 Exemplo (Android/Termux)

Veja também `Android/android/configs/mcp-android.example.json`.

## 🖥️ Exemplo (Windows)

Crie um arquivo local (não versionado): `mcp/mcp-windows.local.json` (sugestão) e aponte seu cliente (Gemini/Claude/etc) para ele.

> Observação: no Windows, caminhos devem ser Windows-style (ex: `C:\Projetos`).

Arquivo de exemplo: `mcp/mcp-windows.example.json`.

## 🧪 Checklist rápido

- [ ] `node -v` e `npm -v`
- [ ] `npx -v`
- [ ] `gh --version` (se usar GitHub)
- [ ] Config local criado (`*.local.json`)
- [ ] Variáveis de ambiente configuradas (TAVILY, CONTEXT7, GITHUB PAT)
