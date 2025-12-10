# 📚 Índice - Contexto-Pleno

Guia de navegação rápida para toda a documentação do projeto.

---

## 🚀 INÍCIO RÁPIDO

| Documento | Descrição |
|-----------|-----------|
| **[RESUMO-EXECUTIVO.md](RESUMO-EXECUTIVO.md)** | 📊 Resumo da reconstrução dos MCPs (LEIA PRIMEIRO!) |
| **[README.md](README.md)** | 📖 Documentação geral do projeto |
| **[COMANDOS-UTEIS.md](COMANDOS-UTEIS.md)** | 🛠️ Referência rápida de comandos |

---

## 📋 RELATÓRIOS E DOCUMENTAÇÃO TÉCNICA

| Documento | Descrição |
|-----------|-----------|
| **[MCPS/Docker/RELATORIO-FINAL-2025-12-10.md](MCPS/Docker/RELATORIO-FINAL-2025-12-10.md)** | 🎯 Relatório técnico completo da reconstrução |
| **[ROADMAP-MCP-UNIVERSAL.md](ROADMAP-MCP-UNIVERSAL.md)** | 🗺️ Roadmap e progresso do projeto |
| **[PC-Context.md](PC-Context.md)** | 🖥️ Contexto do PC e especificações |

---

## ⚙️ CONFIGURAÇÃO

### Arquivos de Configuração MCP

| Arquivo | Uso |
|---------|-----|
| **[MCPS/configs/kiro-mcp-docker.json](MCPS/configs/kiro-mcp-docker.json)** | Configuração universal para Kiro |
| **[MCPS/configs/mcp-config-docker.json](MCPS/configs/mcp-config-docker.json)** | Configuração alternativa |
| **[MCPS/configs/.env](MCPS/configs/.env)** | Variáveis de ambiente e API keys |

### Docker

| Arquivo | Uso |
|---------|-----|
| **[MCPS/Docker/docker-compose.yml](MCPS/Docker/docker-compose.yml)** | Docker Compose (Context7) |
| **[MCPS/Docker/.env](MCPS/Docker/.env)** | Variáveis de ambiente Docker |

---

## 🤖 AGENTES IA

### Documentação por Agente

| Documento | Agente |
|-----------|--------|
| **[DevSan.md](DevSan.md)** | Core personality e contexto |
| **[Gemini.md](Gemini.md)** | Gemini CLI |
| **[KILOCODE.md](KILOCODE.md)** | Kilocode CLI |
| **[QWEN.md](QWEN.md)** | Qwen CLI |

### Guias de Configuração

| Documento | IDE/Agente |
|-----------|------------|
| **[docs/ides/KIRO.md](docs/ides/KIRO.md)** | Kiro (AWS) |
| **[docs/ides/VSCODE.md](docs/ides/VSCODE.md)** | VS Code / Insiders |
| **[docs/ides/WINDSURF.md](docs/ides/WINDSURF.md)** | Windsurf (Codeium) |
| **[docs/agents/GEMINI-CLI.md](docs/agents/GEMINI-CLI.md)** | Gemini CLI |
| **[docs/agents/CLAUDE-CODE.md](docs/agents/CLAUDE-CODE.md)** | Claude Code |
| **[docs/agents/KILOCODE.md](docs/agents/KILOCODE.md)** | Kilocode CLI |
| **[docs/agents/GITHUB-COPILOT-CLI.md](docs/agents/GITHUB-COPILOT-CLI.md)** | GitHub Copilot CLI |

---

## 🐳 MCPs DOCKER

### Documentação

| Documento | Descrição |
|-----------|-----------|
| **[docs/mcps/DOCKER-MCPS.md](docs/mcps/DOCKER-MCPS.md)** | Documentação completa dos MCPs Docker |
| **[MCPS/AGENTS.md](MCPS/AGENTS.md)** | Resumo dos agentes CLI |
| **[MCPS/Docker/SUMMARY.md](MCPS/Docker/SUMMARY.md)** | Sumário dos containers |
| **[MCPS/Docker/PORTS.md](MCPS/Docker/PORTS.md)** | Mapeamento de portas |

### Relatórios de Teste

| Documento | Data |
|-----------|------|
| **[MCPS/Docker/test-results-2025-12-09.md](MCPS/Docker/test-results-2025-12-09.md)** | 2025-12-09 |
| **[MCPS/Docker/RELATORIO-FINAL-2025-12-10.md](MCPS/Docker/RELATORIO-FINAL-2025-12-10.md)** | 2025-12-10 |

---

## 🛠️ SCRIPTS

### Scripts de Gerenciamento

| Script | Descrição |
|--------|-----------|
| **[scripts/start-mcps.ps1](scripts/start-mcps.ps1)** | Iniciar/parar/gerenciar MCPs |
| **[scripts/test-mcps.ps1](scripts/test-mcps.ps1)** | Testar MCPs |
| **[scripts/test-all-mcps.ps1](scripts/test-all-mcps.ps1)** | Testar todos os MCPs e gerar relatório |
| **[scripts/recreate-mcps-with-ports.ps1](scripts/recreate-mcps-with-ports.ps1)** | Recriar containers com portas |

### Scripts de Configuração

| Script | Descrição |
|--------|-----------|
| **[scripts/sync-mcp-configs.ps1](scripts/sync-mcp-configs.ps1)** | Sincronizar configurações |
| **[scripts/apply-mcp-env.ps1](scripts/apply-mcp-env.ps1)** | Aplicar variáveis de ambiente |
| **[scripts/setup-windows.ps1](scripts/setup-windows.ps1)** | Setup inicial Windows |

### Scripts de Validação

| Script | Descrição |
|--------|-----------|
| **[scripts/validate-agents.ps1](scripts/validate-agents.ps1)** | Validar agentes instalados |
| **[scripts/check-copilot-setup.ps1](scripts/check-copilot-setup.ps1)** | Verificar setup do Copilot |

### Scripts Utilitários

| Script | Descrição |
|--------|-----------|
| **[scripts/export-docker-containers.ps1](scripts/export-docker-containers.ps1)** | Exportar info dos containers |
| **[scripts/generate-mcps-readme.ps1](scripts/generate-mcps-readme.ps1)** | Gerar README dos MCPs |
| **[scripts/start-mcp-context7.ps1](scripts/start-mcp-context7.ps1)** | Auto-start Context7 |

---

## 🔑 API KEYS

| Documento | Descrição |
|-----------|-----------|
| **[Banco-Api.md](Banco-Api.md)** | Central de API keys |
| **[MCPS/configs/.env](MCPS/configs/.env)** | Variáveis de ambiente |

---

## 🌐 INTEGRAÇÕES

| Documento | Descrição |
|-----------|-----------|
| **[Interconection.md](Interconection.md)** | Interconexões entre sistemas |
| **[contribuicoes-gemini/PROPOSTA_GEMINI.md](contribuicoes-gemini/PROPOSTA_GEMINI.md)** | Proposta de integração Gemini |
| **[contribuicoes-gemini/GENKIT_INTEGRATION.md](contribuicoes-gemini/GENKIT_INTEGRATION.md)** | Integração com Genkit |
| **[contribuicoes-gemini/PROPOSTA_OFFLINE_FIRST.md](contribuicoes-gemini/PROPOSTA_OFFLINE_FIRST.md)** | Proposta offline-first |

---

## 📊 ESTRUTURA DO PROJETO

```
Contexto-Pleno/
├── 📄 INDEX.md                         # Este arquivo
├── 📄 RESUMO-EXECUTIVO.md              # Resumo da reconstrução
├── 📄 README.md                        # Documentação geral
├── 📄 COMANDOS-UTEIS.md                # Comandos úteis
├── 📄 ROADMAP-MCP-UNIVERSAL.md         # Roadmap
│
├── 📁 MCPS/                            # Configurações MCP
│   ├── 📁 configs/                     # Configs universais
│   │   ├── kiro-mcp-docker.json        # Config principal
│   │   ├── mcp-config-docker.json      # Config alternativa
│   │   └── .env                        # Variáveis de ambiente
│   │
│   └── 📁 Docker/                      # Docker files
│       ├── docker-compose.yml          # Docker Compose
│       ├── .env                        # Env Docker
│       ├── RELATORIO-FINAL-2025-12-10.md  # Relatório final
│       └── test-results-*.md           # Resultados de testes
│
├── 📁 docs/                            # Documentação
│   ├── 📁 ides/                        # Guias por IDE
│   ├── 📁 agents/                      # Guias por agente
│   └── 📁 mcps/                        # Docs MCPs
│
├── 📁 scripts/                         # Scripts de automação
│   ├── start-mcps.ps1                  # Gerenciar MCPs
│   ├── test-mcps.ps1                   # Testar MCPs
│   └── ...                             # Outros scripts
│
└── 📁 contribuicoes-gemini/            # Propostas Gemini
    ├── PROPOSTA_GEMINI.md
    ├── GENKIT_INTEGRATION.md
    └── PROPOSTA_OFFLINE_FIRST.md
```

---

## 🎯 FLUXO DE TRABALHO RECOMENDADO

### Para Novos Usuários

1. Leia **[RESUMO-EXECUTIVO.md](RESUMO-EXECUTIVO.md)**
2. Configure seu agente usando os guias em **[docs/ides/](docs/ides/)** ou **[docs/agents/](docs/agents/)**
3. Consulte **[COMANDOS-UTEIS.md](COMANDOS-UTEIS.md)** quando necessário

### Para Desenvolvedores

1. Leia **[MCPS/Docker/RELATORIO-FINAL-2025-12-10.md](MCPS/Docker/RELATORIO-FINAL-2025-12-10.md)**
2. Explore **[MCPS/configs/](MCPS/configs/)** para configurações
3. Use **[scripts/](scripts/)** para automação

### Para Manutenção

1. Consulte **[ROADMAP-MCP-UNIVERSAL.md](ROADMAP-MCP-UNIVERSAL.md)** para progresso
2. Use **[scripts/test-mcps.ps1](scripts/test-mcps.ps1)** para validação
3. Atualize **[MCPS/Docker/docker-compose.yml](MCPS/Docker/docker-compose.yml)** conforme necessário

---

## 🆘 SUPORTE

### Problemas Comuns

Consulte a seção **Troubleshooting** em:
- **[COMANDOS-UTEIS.md](COMANDOS-UTEIS.md)** - Comandos de diagnóstico
- **[MCPS/Docker/RELATORIO-FINAL-2025-12-10.md](MCPS/Docker/RELATORIO-FINAL-2025-12-10.md)** - Lições aprendidas

### Recursos Externos

- [Docker Documentation](https://docs.docker.com/)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Kiro Documentation](https://docs.kiro.ai/)

---

**Última Atualização:** 2025-12-10 19:15 BRT  
**Autor:** Kiro (DevSan AI)  
**Workspace:** C:/Projetos/Contexto-Pleno
