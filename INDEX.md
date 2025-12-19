# 📚 ÍNDICE - Contexto Pleno (Pop!_OS)

**Sistema:** Pop!_OS 24.04 LTS  
**Última Atualização:** 2025-12-18  
**Status:** ✅ Metodologia Consolidada

---

## 🎯 Início Rápido

### Para Agentes IA
1. **Ler primeiro:** `/home/deivi/AGENTS.md`
2. **Metodologia:** `METODOLOGIA-CONSOLIDADA.md` (este repo)
3. **Decisões:** `DECISOES-ARQUIVADAS.md` (este repo)

### Para Desenvolvimento
```bash
# Comandos essenciais
bun install              # Instalar dependências
bunx <package>           # Executar package
opencode                 # IDE/Editor
```

---

## 📂 Estrutura do Repositório

```
contexto-pleno/
├── METODOLOGIA-CONSOLIDADA.md    ⭐ LEIA PRIMEIRO
├── DECISOES-ARQUIVADAS.md        📚 Histórico de decisões
├── README.md                      📄 Visão geral
│
├── PC/                            💻 Configs PC
│   ├── CONFIGURACAO-OPENCODE-FINAL.md    (Legado Windows)
│   ├── OPENCODE-AGENTS-FINAL.md          (Legado Windows)
│   ├── ROADMAP-MCP-UNIVERSAL.md          (Histórico Docker)
│   ├── Meu-PC.md                         (Specs Windows)
│   ├── PC-Context.md                     (Contexto Windows)
│   └── MCPS/Docker/                      (Docker legado)
│
├── Android/                       📱 Configs Android/Termux
│   ├── android/
│   │   ├── configs/
│   │   ├── mcp/
│   │   ├── scripts/
│   │   └── orchestrator/
│   └── BUN_TERMUX.md
│
├── mcp/                           🔌 MCPs (padrão npm/bunx)
│   └── README.md
│
├── Shared/                        🌐 Universal PC+Android
│   └── STATUS-2025-12-16.md
│
├── DevSan001/                     🤖 Projeto DevSan
│   ├── ARCHITECTURE.md
│   └── README.md
│
├── playwright/                    🎭 Playwright configs
└── .opencode/                     ⚙️ OpenCode configs
```

---

## 📋 Documentos por Categoria

### 🌟 Essenciais (Leia Primeiro)
| Documento | Localização | Descrição |
|-----------|-------------|-----------|
| **AGENTS.md** | `/home/deivi/` | Contexto consolidado atual |
| **METODOLOGIA-CONSOLIDADA.md** | `.` (raiz) | Metodologia oficial |
| **DECISOES-ARQUIVADAS.md** | `.` (raiz) | Histórico de decisões |
| **README.md** | `.` (raiz) | Visão geral do repo |

### 💻 Configuração PC (Atual - Pop!_OS)
| Documento | Localização | Status |
|-----------|-------------|---------|
| **AGENTS.md** | `/home/deivi/` | ✅ Ativo |
| **opencode.json** | `~/.config/opencode/` | ✅ Ativo |
| **mcp.json** (Kiro) | `~/.kiro/` | 🗄️ Legado |

### 📚 Documentação Legado (Windows)
| Documento | Localização | Nota |
|-----------|-------------|------|
| **CONFIGURACAO-OPENCODE-FINAL.md** | `PC/` | Windows, referência |
| **OPENCODE-AGENTS-FINAL.md** | `PC/` | Windows, agentes |
| **ROADMAP-MCP-UNIVERSAL.md** | `PC/` | Docker histórico |
| **Meu-PC.md** | `PC/` | Specs Windows |
| **PC-Context.md** | `PC/` | Contexto Windows |

### 📱 Android/Termux
| Documento | Localização | Status |
|-----------|-------------|---------|
| **BUN_TERMUX.md** | `Android/` | ✅ Ativo |
| **configs/** | `Android/android/` | ✅ Ativo |
| **scripts/** | `Android/android/` | ✅ Ativo |

### 🔌 MCPs
| Documento | Localização | Tipo |
|-----------|-------------|------|
| **README.md** | `mcp/` | Padrão npm/bunx |
| **docker-compose.yml** | `PC/MCPS/Docker/` | Legado (não usar) |

---

## 🎯 Guias de Uso

### Para Configurar Ambiente
1. Ler `METODOLOGIA-CONSOLIDADA.md`
2. Instalar Bun: `curl -fsSL https://bun.sh/install | bash`
3. Instalar OpenCode: Verificar site oficial
4. Configurar MCPs: Ver `METODOLOGIA-CONSOLIDADA.md`

### Para Desenvolver
1. Ler `/home/deivi/AGENTS.md`
2. Consultar memória MCP se disponível
3. Usar bunx para MCPs
4. Atualizar docs quando necessário

### Para Entender Decisões
1. Ler `DECISOES-ARQUIVADAS.md`
2. Consultar docs legado em `PC/`
3. Ver análise Docker em `Prompts/.kiro/docker-mcp-analysis.md`

---

## 🚫 O Que NÃO Fazer

### ❌ Tecnologias Arquivadas
- **Docker para MCPs** - Usar bunx/uvx
- **npm/npx** - Usar bun/bunx
- **VSCode** - Usar OpenCode CLI
- **Kiro IDE** - Legado, usar OpenCode

### ✅ Tecnologias Ativas
- **Bun** 1.3.5 - Runtime JS/TS
- **OpenCode CLI** - IDE/Editor
- **bunx/uvx** - MCPs
- **Python/uv** - Python dev

---

## 📊 Status dos Documentos

### ✅ Atualizados (2025-12-18)
- `/home/deivi/AGENTS.md`
- `METODOLOGIA-CONSOLIDADA.md`
- `DECISOES-ARQUIVADAS.md`
- Este INDEX.md

### 🗄️ Legado (Referência)
- `PC/CONFIGURACAO-OPENCODE-FINAL.md` (Windows)
- `PC/OPENCODE-AGENTS-FINAL.md` (Windows)
- `PC/ROADMAP-MCP-UNIVERSAL.md` (Docker)
- `PC/Meu-PC.md` (Specs Windows)

### 📱 Plataforma Específica
- `Android/` - Termux/Android
- `PC/` - Windows (legado) e Pop!_OS (novo)

---

## 🧭 Navegação Rápida

### Por Objetivo

**Quero entender o sistema:**
1. AGENTS.md
2. METODOLOGIA-CONSOLIDADA.md
3. DECISOES-ARQUIVADAS.md

**Quero configurar MCPs:**
1. METODOLOGIA-CONSOLIDADA.md
2. mcp/README.md
3. Ver config em `~/.config/opencode/opencode.json`

**Quero entender por que Docker foi arquivado:**
1. DECISOES-ARQUIVADAS.md
2. `../Prompts/.kiro/docker-mcp-analysis.md`
3. `PC/ROADMAP-MCP-UNIVERSAL.md`

**Quero configurar Android/Termux:**
1. Android/BUN_TERMUX.md
2. Android/android/configs/
3. Android/android/scripts/

---

## 🔗 Links Importantes

### Configurações
- **OpenCode config:** `~/.config/opencode/opencode.json`
- **OpenCode state:** `~/.local/state/opencode/`
- **Kiro legado:** `~/.kiro/`

### Repositórios
- **Este repo:** `/home/deivi/Projetos/contexto-pleno`
- **Prompts:** `/home/deivi/Projetos/Prompts`

### Documentação Externa
- **OpenCode:** https://opencode.ai/docs
- **Bun:** https://bun.sh/docs
- **MCPs:** https://modelcontextprotocol.io

---

## 📝 Convenções

### Status Icons
- ✅ Ativo/Atual
- 🗄️ Legado/Preservado
- ❌ Arquivado/Não usar
- ⚠️ Em transição
- 🔄 Em desenvolvimento

### Nomenclatura
- **MAIÚSCULAS.md** - Documentos importantes
- **lowercase.md** - Documentos específicos
- **PC/** - Configs PC
- **Android/** - Configs Android

---

## 🆘 Troubleshooting

### Agente não encontra contexto
- Ler `/home/deivi/AGENTS.md` primeiro
- Consultar memória MCP
- Verificar se está usando paths corretos

### Docs parecem desatualizados
- Verificar data no topo do documento
- Consultar este INDEX.md
- Docs com Windows são legado

### Confuso sobre MCPs
- Ler `METODOLOGIA-CONSOLIDADA.md`
- **NÃO** usar Docker
- Usar bunx/uvx apenas

---

## ✨ Atualizações

### 2025-12-18
- ✅ Consolidada metodologia Bun-first
- ✅ Arquivado Docker MCP
- ✅ Atualizado AGENTS.md
- ✅ Criado METODOLOGIA-CONSOLIDADA.md
- ✅ Criado DECISOES-ARQUIVADAS.md
- ✅ Criado este INDEX.md

### Próximas
- [ ] Consolidar docs Android
- [ ] Atualizar README.md principal
- [ ] Criar guias específicos

---

**Documento:** INDEX.md  
**Versão:** 1.0  
**Última Atualização:** 2025-12-18  
**Gerado por:** OpenCode AI (Claude Sonnet 4.5)
