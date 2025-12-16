# 🚀 Contexto-Pleno — Hub Universal de Agentes IA

> **Repositório central para configuração e orquestração de agentes IA com MCPs (Docker e Nativo).**

[![Status](https://img.shields.io/badge/Status-Ativo-success)](/)
[![MCPs](https://img.shields.io/badge/MCPs-Universal-blue)](/)
[![Platform](https://img.shields.io/badge/Plataforma-Windows%20%7C%20Android-green)](/)

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura Híbrida](#-arquitetura-híbrida)
- [📱 Suporte Termux](#-suporte-termux-android)
- [🧠 Orquestração Multi-Agente](#-orquestração-multi-agente-novo)
- [MCPs Disponíveis](#-mcps-disponíveis)
- [Estrutura do Repositório](#-estrutura-do-repositório)

---

## 🎯 Visão Geral

Este repositório centraliza a configuração de **MCPs (Model Context Protocol)** para uso universal em múltiplos agentes e IDEs, suportando tanto ambientes desktop (Docker) quanto mobile (Termux/Node.js).

### 🤖 Agentes CLI Suportados
| Agente | Versão | Status |
|--------|--------|--------|
| **Gemini CLI** | v0.21.0 | ✅ Instalado |
| **Qwen Code** | v0.5.0 | ✅ Instalado |
| **Kilocode CLI** | v0.10.2 | ✅ Instalado |
| **GitHub Copilot CLI** | v1.2.0 | ✅ Instalado |

---

## 🏗️ Arquitetura Híbrida

O sistema opera em dois modos distintos, compartilhando a mesma "memória" e configurações:

### Modo PC (Windows/Docker)
Isolamento total via containers.
```
[Agentes] --> [Docker MCPs: Context7, Tavily, Memory...] --> [Sistema]
```

### Modo Mobile (Android/Termux)
Execução nativa ("Bare Metal") via Node.js para eficiência.
```
[Agentes] --> [Native Node MCPs: Context7, Tavily, Memory...] --> [Sistema]
```

---

## 📱 Suporte Termux (Android)

Esta seção detalha a operação no ambiente mobile.

**Setup Rápido:**
1. Instale Termux, Node.js, Python, Git e GH CLI.
2. Clone este repositório: `git clone ...`
3. Execute a validação: `./termux/scripts/validate-env.sh`
4. Sincronize configs: `./termux/scripts/sync-config.sh`

**Destaques Termux:**
- **Orquestrador Node.js:** Módulo próprio em `termux/orchestrator/` para gerenciar agentes.
- **MCPs Nativos:** Sem overhead de Docker.
- **Protocolo Universal:** `termux/treinamento/UNIVERSAL_AGENT_PROTOCOL.md`.

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

## 🐳 MCPs Disponíveis (Universal)

| MCP | Tipo | Status | Função |
|-----|------|--------|--------|
| **Context7** | HTTP/SSE | ✅ Ativo | Documentação Técnica |
| **Tavily** | STDIO | ✅ Ativo | Busca Web |
| **Memory** | STDIO | ✅ Ativo | Grafo de Conhecimento |
| **Git** | STDIO | ✅ Ativo | Controle de Versão |
| **Filesystem** | STDIO | ✅ Ativo | Acesso a Arquivos |

> 📖 Documentação completa: [docs/mcps/DOCKER-MCPS.md](docs/mcps/DOCKER-MCPS.md)

---

## 📁 Estrutura do Repositório

```
Contexto-Pleno/
├── 📄 README.md                    # Este arquivo
├── 📄 ORCHESTRATION.md             # Cérebro da Operação
├── 📁 termux/                      # Adaptação Android (NOVO)
│   ├── 📁 configs/                 # Configs nativas
│   ├── 📁 scripts/                 # Scripts Bash
│   ├── 📁 orchestrator/            # Engine Node.js
│   └── 📁 treinamento/             # Protocolos e Relatórios
│
├── 📁 MCPS/                        # Configurações Docker (PC)
├── 📁 docs/                        # Documentação Geral
└── 📁 Agentes/                     # Personas dos Agentes
```

---

## 📄 Licença

MIT — Sinta-se livre para adaptar e replicar.

<p align="center">
  <strong>Desenvolvido por Deivison Santana (@deivisan)</strong>
</p>