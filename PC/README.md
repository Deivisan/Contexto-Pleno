# 🖥️ Contexto-Pleno — PC (Windows)

> **Contexto, scripts e histórico do ambiente Windows.**

[![Status](https://img.shields.io/badge/Status-Ativo-success)](/)
[![MCPs](https://img.shields.io/badge/MCPs-Universal-blue)](/)
[![Platform](https://img.shields.io/badge/Plataforma-Windows%20%7C%20Android-green)](/)

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Como rodar MCPs no Windows](#-como-rodar-mcps-no-windows-recomendado)
- [Android (Termux)](#-android-termux)
- [Orquestração Multi-Agente](#-orquestração-multi-agente-novo)
- [Docker (legado / em pausa)](#-docker-legado--em-pausa)
- [Estrutura](#-estrutura-recorte-relevante)

---

## 🎯 Visão Geral

Este diretório (`PC/`) consolida o que foi tentado/validado no **Windows** (PowerShell, IDEs, agentes e integrações).

📌 **Direção atual do repositório (padrão):** MCPs via **npm/npx** (portável), com Docker tratado como **legado/histórico**.

- Status e decisão registrada: `../Shared/STATUS-2025-12-16.md`
- Camada universal (templates + guia): `../mcp/README.md`

### 🤖 Agentes CLI Suportados

| Agente | Versão | Status |
|--------|--------|--------|
| **Gemini CLI** | v0.21.0 | ✅ Instalado |
| **Qwen Code** | v0.5.0 | ✅ Instalado |
| **Kilocode CLI** | v0.10.2 | ✅ Instalado |
| **GitHub Copilot CLI** | v1.2.0 | ✅ Instalado |

---

## 🧭 Como rodar MCPs no Windows (recomendado)

O caminho preferencial hoje é usar `npx`/`npm` (STDIO) e manter as chaves **fora do Git** (via variáveis de ambiente e arquivos locais ignorados).

- Template Windows: `../mcp/mcp-windows.example.json`
- Sugestão: crie um `mcp-windows.local.json` (ignored) copiando do template e ajuste conforme seu agente/IDE.

---

## 📱 Android (Termux)

O suporte Android/Termux vive em `../Android/android/`.

**Setup rápido (Termux):**

1. Instale Node.js, Git e as CLIs que você usa.
2. Dentro de `Android/android/`, rode:

- `./scripts/validate-env.sh`
- `./scripts/sync-config.sh`

📖 Guia/entrada: `../Android/android/README.md`

---

## 🧠 Orquestração Multi-Agente (Novo!)

### Sistema Completo Implementado

Este repositório agora inclui **orquestração inteligente de múltiplos agentes CLI** usando metodologia YOLO (auto-approval total) e delegação hierárquica.

**Documentação Central:** [ORCHESTRATION.md](ORCHESTRATION.md)

### Agentes Ativos

1. **Gemini-CLI** - Planejador estratégico e Orquestrador (✅ Termux Native)
2. **Qwen-Code** - Executor de código (✅ Termux Native)
3. **Kilocode** - Automação navegador (✅ Termux Native)
4. **GitHub Copilot CLI** - Consultas rápidas (✅ Termux Native)

### Workflow Exemplo

```yaml
Tarefa: "Criar dashboard web com autenticação JWT"

Gemini (Orquestrador):
  - Lê ORCHESTRATION.md
  - Planeja em fases (arquitetura → backend → frontend)
  
Qwen (Backend):
  - Implementa Node.js + MongoDB com testes
  
Kilocode (Frontend):
  - Scaffolds React app, cria componentes
  
Copilot (GitHub):
  - Sugere comandos git e CI/CD
```

---

## 🐳 Docker (legado / em pausa)

Este repo tem um histórico de MCPs via Docker (útil como referência), mas a estratégia atual é **npm/npx-first**.

- Legado Docker (configs/compose): `../PC/MCPS/`
- Documentação Docker legado: `../docs/mcps/DOCKER-MCPS.md`

---

## 📁 Estrutura (recorte relevante)

```text
Contexto-Pleno/
├── Android/android/                 # Termux/Android (scripts, configs, treinamento)
├── PC/                              # Windows/PC (docs, scripts, legado)
├── mcp/                             # Padrão universal (npm/npx) + templates
└── Shared/                          # Status e notas transversais
```

---

## 📄 Licença

MIT — Sinta-se livre para adaptar e replicar.

Desenvolvido por Deivison Santana (@deivisan).
