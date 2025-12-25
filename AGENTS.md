# AGENTS.md - Contexto Pleno

**Repositório:** contexto-pleno
**Finalidade:** Configurações PC + Android
**Data:** 2025-12-23

---

## 🎯 ESCOPO DO REPOSITÓRIO

Este repositório contém **configurações completas** do ecossistema Deivison Santana:

### 📱 Configurações Android/Termux
- **BUN_TERMUX.md** - Guia completo para Bun no Termux
- **Android/android/configs/** - Dotfiles essenciais Termux
- **Android/android/scripts/** - Scripts de automação Android
- **Android/android/orchestrator/** - Orquestração MCPs Android

### 💻 Configurações PC (Pop!_OS e Windows legado)
- **PC/Meu-PC.md** - Especificações hardware (ATENÇÃO: Legado Windows)
- **PC/PC-Context.md** - Contexto do sistema Windows
- **PC/CONFIGURACAO-OPENCODE-FINAL.md** - Config OpenCode Windows
- **PC/OPENCODE-AGENTS-FINAL.md** - Agentes OpenCode Windows
- **PC/ROADMAP-MCP-UNIVERSAL.md** - Histórico Docker MCP

### 🔌 MCPs Universal
- **mcp/README.md** - Padrão npm/bunx para MCPs
- **PC/MCPS/Docker/** - **ARQUIVADO** - Não usar Docker para MCPs

### 🤖 DevSan001
- **DevSan001/ARCHITECTURE.md** - Arquitetura do sistema DevSan
- **DevSan001/README.md** - Visão geral
- **DevSan001/treinamento/** - Material de treinamento para agentes

---

## 🚨 ATENÇÃO - CONTEXTO MISTO

### ⚠️ Documentos PC SÃO LEGADO WINDOWS
Todos os arquivos em `PC/` referem-se a **Windows 11 Pro** com:
- **VSCode** como editor principal (DESCONTINUADO)
- **Node.js** ativo (DESCONTINUADO - migramos para Bun)
- **Docker MCP** (DESCONTINUADO - migramos para bunx/uvx)

### ✅ CONTEXTO ATUAL: Pop!_OS
Verificar sempre `/home/deivi/AGENTS.md` para contexto atual do sistema Pop!_OS.

---

## 📂 ESTRUTURA DO REPOSITÓRIO

```
contexto-pleno/
├── METODOLOGIA-CONSOLIDADA.md    ⭐ Metodologia oficial
├── DECISOES-ARQUIVADAS.md        📚 Histórico de decisões
├── README.md                      📄 Visão geral
├── INDEX.md                       🗂 Navegação
├── ROADMAP-GLOBAL-PC.md          🗺️ Roadmap PC completo
│
├── PC/                            💻 Configs PC (LEGADO WINDOWS)
│   ├── Meu-PC.md                 ❌ Specs Windows
│   ├── PC-Context.md              ❌ Contexto Windows
│   ├── CONFIGURACAO-OPENCODE-FINAL.md
│   ├── OPENCODE-AGENTS-FINAL.md
│   └── MCPS/Docker/              🗄️ Docker arquivado
│
├── Android/                       📱 Configs Android (ATIVO)
│   ├── BUN_TERMUX.md
│   ├── android/
│   │   ├── configs/              ✅ Dotfiles ativos
│   │   ├── scripts/              ✅ Scripts ativos
│   │   ├── mcp/                  ✅ MCPs Android
│   │   └── orchestrator/         ✅ Orquestração
│   └── treinamento/
│
├── mcp/                           🔌 MCPs (padrão npm/bunx)
│   └── README.md                ✅ Padrão universal
│
├── DevSan001/                     🤖 Projeto DevSan
│   ├── ARCHITECTURE.md
│   ├── README.md
│   └── treinamento/
│
├── Shared/                        🌐 Universal PC+Android
│   └── STATUS-2025-12-16.md
│
└── .opencode/                     ⚙️ OpenCode configs
    └── agent/devsan.md
```

---

## 🎯 QUANDO USAR ESTE REPOSITÓRIO

### ✅ USE PARA
- **Android/Termux configurations** - Bun no Termux, scripts, MCPs
- **Metodologia consolidada** - `METODOLOGIA-CONSOLIDADA.md`
- **Histórico de decisões** - `DECISOES-ARQUIVADAS.md`
- **Roadmap PC** - `ROADMAP-GLOBAL-PC.md`

### ⚠️ USE COM CUIDADO
- **PC/** docs - São legado Windows, verificar se ainda válido
- **Docker configs** - Docker MCP foi arquivado, usar bunx/uvx
- **VSCode configs** - VSCode foi desinstalado

---

## 🔍 DOCUMENTOS ESSENCIAIS

### Para Entender o Sistema
1. **`/home/deivi/AGENTS.md`** - Contexto Pop!_OS atual
2. **`METODOLOGIA-CONSOLIDADA.md`** - Metodologia oficial
3. **`DECISOES-ARQUIVADAS.md`** - Por que tomamos decisões

### Para Configurar Android/Termux
1. **`Android/BUN_TERMUX.md`** - Guia completo Bun Termux
2. **`Android/android/configs/`** - Dotfiles prontos
3. **`Android/android/scripts/`** - Scripts de automação

### Para Configurar MCPs
1. **`mcp/README.md`** - Padrão npm/bunx universal
2. **`/home/deivi/.config/opencode/opencode.json`** - Config atual

---

## 🚨 DECISÕES IMPORTANTES ARQUIVADAS

### Docker → bunx/uvx
- **Quando:** 2025-12-18
- **Por que:** Instabilidade do Docker no Windows, melhor performance com bunx
- **Resultado:** Todos MCPs migrados para bunx/uvx

### Node → Bun
- **Quando:** 2025-12
- **Por que:** Performance superior, bun runtime nativo
- **Resultado:** Node removido, bun 1.3.5 instalado

### VSCode → OpenCode CLI
- **Quando:** 2025-12-18
- **Por que:** CLI-first philosophy, melhor orquestração
- **Resultado:** VSCode desinstalado, OpenCode CLI único editor

---

## 📝 PARA AGENTES TRABALHANDO NESTE REPO

### 1. Sempre verificar contexto PC atual
```bash
cat /home/deivi/AGENTS.md
```

### 2. Diferenciar Windows vs Pop!_OS
- **PC/** docs = Windows legado
- **Verifique se ainda válido** antes de aplicar

### 3. Seguir padrão bunx/uvx
```bash
# MCPs sempre assim:
bunx @modelcontextprotocol/server-xxx
bunx xxx-mcp

# NUNCA assim:
docker run ...
```

### 4. Documentar novas decisões
Adicionar em `DECISOES-ARQUIVADAS.md` com formato:
```markdown
### [Nome da Decisão]
- **Quando:** [Data]
- **Por que:** [Razão]
- **Resultado:** [Conclusão]
```

---

## 🔄 WORKFLOWS

### Configurar Android Termux do Zero
```
1. Ler Android/BUN_TERMUX.md
2. Copiar dotfiles de android/configs/
3. Executar scripts de android/scripts/
4. Seguir METODOLOGIA-CONSOLIDADA.md
```

### Migrar Config PC → Pop!_OS
```
1. Ler PC/ configs (verificar se ainda válido)
2. Adaptar para Pop!_OS
3. Atualizar /home/deivi/AGENTS.md
4. Documentar mudança em DECISOES-ARQUIVADAS.md
```

### Configurar Novo MCP
```
1. Ler mcp/README.md
2. Seguir padrão bunx/uvx
3. Adicionar em ~/.config/opencode/opencode.json
4. Testar com bunx antes de commitar
```

---

**Repositório:** contexto-pleno
**Status:** 🟢 Ativo (misto com legado)
**Data:** 2025-12-23

> "Contém configs PC+Android, use discernimento entre legado Windows e atual Pop!_OS"
