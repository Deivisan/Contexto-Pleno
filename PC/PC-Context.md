# 🖥️ PC-Context.md - Contexto Completo do DEIVIPC

> **Última Atualização:** 2025-12-09  
> **Dispositivo:** DEIVIPC (Desktop Windows)  
> **Owner:** Deivison Santana (@deivisan)

---

## 📊 HARDWARE

| Componente | Especificação |
|------------|---------------|
| **Nome** | DEIVIPC |
| **CPU** | AMD Ryzen 7 5700G with Radeon Graphics |
| **Cores/Threads** | 8 cores / 16 threads |
| **RAM** | 32GB DDR4 |
| **Arquitetura** | x86_64 (64-bit) |
| **GPU** | AMD Radeon Graphics (integrada) |

---

## 💻 SISTEMA OPERACIONAL

| Item | Valor |
|------|-------|
| **OS** | Windows 10 Pro |
| **Build** | 26220 |
| **Versão** | 2009 |
| **Shell Padrão** | PowerShell 7 (pwsh) / CMD |
| **WSL** | WSL2 com kernel 6.6.87.2-microsoft-standard |

---

## 🐳 DOCKER

| Item | Valor |
|------|-------|
| **Docker Desktop** | v29.1.2 |
| **Docker Compose** | v2.40.3 |
| **Runtime** | containerd + runc |
| **Backend** | WSL2 |
| **Plugins** | ai, buildx, compose, debug, desktop, extension, init, mcp, model, offload, sandbox, sbom, scout |

### Docker MCP Plugin
O Docker Desktop tem suporte nativo a MCP via `docker mcp`:
```powershell
docker mcp catalog     # Listar servidores disponíveis
docker mcp gateway     # Gerenciar gateway MCP
docker mcp server      # Gerenciar servidores
docker mcp secret      # Gerenciar secrets
```

---

## 🛠️ FERRAMENTAS INSTALADAS

### Linguagens e Runtimes
| Ferramenta | Versão | Path |
|------------|--------|------|
| **Node.js** | v25.2.1 | `C:\Program Files\nodejs` |
| **npm** | 11.6.2 | Global |
| **Python** | 3.14.2 | `C:\Python314` |
| **Git** | 2.52.0 | `C:\Program Files\Git` |

### CLIs e Ferramentas
| Ferramenta | Versão | Comando |
|------------|--------|---------|
| **GitHub CLI** | 2.83.1 | `gh` |
| **Docker CLI** | 29.1.2 | `docker` |
| **PowerShell** | 7.x | `pwsh` |

### Pacotes NPM Globais
```
@anthropic-ai/claude-code@2.0.60
@github/copilot@0.0.367
@google/gemini-cli@0.19.4
@kilocode/cli@0.12.1
@playwright/mcp@0.0.50
markdownlint-cli2@0.20.0
md-to-pdf@5.2.5
playwright@1.57.0
```

---

## 🤖 AGENTES IA DISPONÍVEIS

### 1. 🔷 Kiro (IDE)
- **Tipo:** IDE baseado em VS Code
- **MCPs:** context7, tavily, memory, git, fetch
- **Config:** `~/.kiro/settings/mcp.json`

### 2. 💎 Gemini CLI
- **Comando:** `gemini <prompt>`
- **Versão:** 0.19.4
- **Config:** `~/.gemini/settings.json`
- **MCPs:** Tavily, Memory, Git

### 3. 🧬 Kilocode CLI
- **Comando:** `kilocode <prompt>`
- **Versão:** 0.12.1
- **Config:** `~/.kilocode/`
- **Modos:** Interactive, Autonomous, Orchestrator

### 4. 🤖 Claude Code
- **Comando:** `claude`
- **Versão:** 2.0.60
- **Especialidade:** Código complexo, análise

### 5. ✈️ GitHub Copilot CLI
- **Comando:** `copilot` ou `gh copilot`
- **Versão:** 0.0.367
- **Modos:** `??` (shell), `git?`, `gh?`

---

## 📁 ESTRUTURA DE DIRETÓRIOS

```
C:\
├── Projetos\                    # Workspace principal
│   ├── Contexto-Pleno\          # Este repositório
│   │   ├── MCPS\Docker\         # Configurações Docker MCP
│   │   ├── scripts\             # Scripts de automação
│   │   └── *.md                 # Arquivos de contexto
│   └── [outros repos clonados]
├── Users\Deivi\
│   ├── .kiro\                   # Config Kiro
│   │   └── settings\mcp.json
│   ├── .gemini\                 # Config Gemini
│   │   └── settings.json
│   ├── .kilocode\               # Config Kilocode
│   └── AppData\Roaming\npm\     # Binários NPM globais
└── Program Files\
    ├── Docker\                  # Docker Desktop
    ├── Git\                     # Git
    └── nodejs\                  # Node.js
```

---

## 🔑 AUTENTICAÇÃO

### GitHub
- **Usuário:** Deivisan
- **Nome:** Deivison Santana
- **Auth:** OAuth via `gh auth`
- **Scopes:** delete_repo, gist, read:org, repo, workflow

### APIs Configuradas
- ✅ Tavily (busca web)
- ✅ Context7 (documentação)
- ✅ Google AI (Gemini)
- ✅ OpenRouter (multi-model)
- ✅ GitHub PAT

---

## 🐳 MCPs VIA DOCKER

### Portas Mapeadas
| MCP | Porta | URL |
|-----|-------|-----|
| context7 | 8080 | http://localhost:8080 |
| tavily | 3000 | http://localhost:3000 |
| memory | 4000 | http://localhost:4000 |
| git | 5000 | http://localhost:5000 |
| github | 5001 | http://localhost:5001 |
| filesystem | 6000 | http://localhost:6000 |
| playwright | 7000 | http://localhost:7000 |
| desktop-commander | 8000 | http://localhost:8000 |
| fetch | 9000 | http://localhost:9000 |

### Comandos Úteis
```powershell
# Iniciar MCPs
pwsh ./scripts/start-mcps.ps1 -Action start

# Ver status
pwsh ./scripts/start-mcps.ps1 -Action status

# Ver logs
pwsh ./scripts/start-mcps.ps1 -Action logs

# Testar conectividade
pwsh ./scripts/start-mcps.ps1 -Action test
```

---

## ⚡ COMANDOS RÁPIDOS

### PowerShell
```powershell
# Navegação
cd C:\Projetos
cd $env:USERPROFILE

# Listar processos
Get-Process | Where-Object {$_.Name -like "*docker*"}

# Verificar portas
netstat -an | Select-String "LISTENING"

# Docker
docker ps -a
docker compose up -d
docker logs -f <container>
```

### Git
```powershell
git status
git pull
git push
gh repo list
gh pr list
```

---

## 🔧 VARIÁVEIS DE AMBIENTE

### Importantes
```powershell
$env:USERPROFILE     # C:\Users\Deivi
$env:APPDATA         # C:\Users\Deivi\AppData\Roaming
$env:PATH            # Inclui npm, git, python, docker
```

### Para MCPs (setx para persistir)
```powershell
setx TAVILY_API_KEY "tvly-dev-..."
setx CONTEXT7_API_KEY "ctx7sk-..."
setx GITHUB_PERSONAL_ACCESS_TOKEN "github_pat_..."
```

---

## 📝 NOTAS PARA AGENTES

1. **Sempre use caminhos Windows** (`C:\` não `/c/`)
2. **PowerShell 7 é preferível** ao CMD
3. **Docker Desktop deve estar rodando** para MCPs
4. **WSL2 está disponível** para comandos Linux
5. **Evite `rm -rf`** - use `Remove-Item -Recurse -Force`
6. **Separador de comandos:** `;` no PowerShell, `&` no CMD

---

## 🔗 INTEGRAÇÃO COM ANDROID (Termux)

O contexto do dispositivo Android está em `Android16.md` (quando disponível).
Para sincronizar entre PC e Android:
- Use Git para sincronizar repositórios
- MCPs de memória podem ser compartilhados via API
- SSH disponível no Termux (porta 8022)

---

**PC Context atualizado e pronto para uso pelos agentes! 🖥️🚀**
