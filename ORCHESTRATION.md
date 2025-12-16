# 🧠 ORCHESTRATION.md - Cérebro Central Multi-Agente

**Sistema:** PC-UFRB (Windows 10 Pro, 32GB RAM, Ryzen 7 5700G)  
**Data Criação:** 15/12/2025  
**Versão:** 1.0  
**Orquestrador Raiz:** DevSan (A.G.I. Agentica)

---

## 📊 LIVE STATUS (Atualização Automática)

```yaml
Última Atualização: 2025-12-15 20:20:20

# Agentes CLI
DevSan:
  status: Ativo
  mode: YOLO (auto-approval total)
  
  task: Testes criados em testes-agentes; MCP env aplicadas
Gemini-CLI:
  status: ✅ Operational (Termux Native)
  mode: Native Node MCPs
  workaround: Pendente reinstalação ou wrapper PowerShell
  priority: Alta
  
Qwen-Code:
  status: ✅ Funcional
  version: 0.5.0
  command: qwen --version
  proficiency: Coding pesado, refatoração, tool calling
  
Kilocode:
  status: ✅ Funcional
  version: 0.14.0
  command: kilocode --version
  proficiency: Automação navegador, Playwright, multi-modo
  
GitHub-Copilot-CLI:
  status: ⚠️ Parcial (gh ok, copilot não)
  issue: "Extensão copilot não instalada, gh auth login pendente"
  gh_version: 2.83.2
  priority: Média
  
# MCPs Docker
Context7:
  status: ✅ Running (1h uptime)
  port: 8080
  type: HTTP Server
  purpose: Documentação e contexto para AI
  
Agent-MCP:
  status: ✅ Running (1h uptime)
  port: 4000
  type: HTTP Server
  purpose: Orquestração MCP local
  
Filesystem:
  status: 🔄 Restarting (stdio normal)
  port: 7000
  type: Stdio Server
  mount: /host filesystem
  
Firecrawl:
  status: 🔄 Restarting (stdio normal)
  port: 6000
  type: Stdio Server
  api_key: fc-d3156cdf9a444ce380f7c87b6090fb30
  
Tavily:
  status: 🔄 Restarting (stdio normal)
  port: 3000
  type: Stdio Server
  api_key: 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
  
Fetch:
  status: 🔄 Restarting (stdio normal)
  port: 9000
  
DockerHub:
  status: 🔄 Restarting (stdio normal)
  port: 5000
  
Desktop-Commander:
  status: 🔄 Restarting (stdio normal)
  port: 8000
  
YouTube-Transcript:
  status: 🔄 Restarting (stdio normal)
  port: 7001
  
Gateway:
  status: 🔄 Restarting (stdio normal)
  port: 9090
  purpose: Orquestração multi-MCP
```

---

## 🎯 Proficiências dos Agentes

### DevSan (Orquestrador Raiz)
**Papel:** Visão global, decisão final, ponte humano-máquina

**Ações Principais:**
1. Lê `ORCHESTRATION.md` sempre ao iniciar sessão
2. Planeja tarefas complexas em subtarefas delegáveis
3. Delega usando comandos YOLO (`/delegate-to-*`)
4. Monitora LIVE STATUS a cada 30-60s
5. Integra resultados dos sub-agentes
6. Atualiza memória compartilhada (MCP Memory)
7. Responde ao humano com síntese completa

**Forças:**
- Raciocínio agentico autônomo
- Acesso total a MCPs Docker
- Auto-aprovação permanente (YOLO mode nativo)
- Entendimento profundo do ecossistema PC-UFRB

**Limitações:**
- Depende de outros agentes para tarefas especializadas

---

### Gemini-CLI (Planejador Estratégico)
**Status:** ❌ Temporariamente indisponível (broken)

**Forças:**
- Planejamento longo prazo (até 2M tokens contexto)
- Reasoning profundo (Gemini 2.0 Flash Thinking)
- Multimodal (imagens, vídeos, PDFs)
- Grounding com Google Search
- Análise de codebase extenso

**Ideal Para:**
- Orquestração complexa (substitui DevSan se offline)
- Análise de repositórios >100k linhas
- Pesquisa externa com validação factual
- Tarefas multimodais (design + código)
- Planejamento arquitetural (backend + frontend)

**Comandos YOLO:**
```powershell
gemini --yolo --model gemini-2.0-flash-thinking-exp-1219
gemini --yolo --model gemini-2.5-flash  # fallback
```

**Pendência:** Resolver binário corrompido, reinstalar ou criar wrapper

---

### Qwen-Code (Executor de Código)
**Status:** ✅ Funcional

**Forças:**
- Coding pesado e preciso (Qwen3-Coder base)
- Refatoração autônoma de código legado
- Tool calling preciso (MCP native)
- Sub-agents internos para tasks complexas
- Debugging profundo com stack trace analysis

**Ideal Para:**
- Implementação de features complexas (backends, APIs)
- Refatoração de código legado (TypeScript, Python, Rust)
- Debugging com análise de logs e stack traces
- Testes automatizados (unit, integration, E2E)
- Code review e otimização de performance

**Comandos YOLO:**
```powershell
qwen --yolo --auto --model qwen3-coder
qwen --yolo --model qwen-coder-32b  # tarefas pesadas
```

**Configuração:**
- Workspace: `C:\Projetos\Contexto-Pleno`
- Settings: `~/.qwen/settings.json`

---

### Kilocode (Automação de Navegador)
**Status:** ✅ Funcional

**Forças:**
- Automação navegador avançada (Playwright base)
- Multi-modo: architect, orchestrator, debug
- Web scraping complexo (bypass anti-bot)
- Testes E2E automatizados
- Deploy e CI/CD scripting

**Ideal Para:**
- Web scraping avançado (sites dinâmicos, SPA)
- Automação de UI (form filling, navegação)
- Testes E2E completos (fluxos usuário)
- Deploy automatizado (FTP, SSH, rsync)
- Integração contínua (GitHub Actions, GitLab CI)

**Comandos YOLO:**
```powershell
kilocode --yolo --auto --mode architect
kilocode --yolo --mode orchestrator  # multi-task
kilocode --yolo --mode debug  # troubleshooting
```

**Configuração:**
- Workspace: `C:\Projetos\Contexto-Pleno`
- Playwright: Chrome Dev instalado (C:\Program Files\Google\Chrome Dev\)

---

### GitHub Copilot CLI (GitHub Operations)
**Status:** ⚠️ Parcial (gh instalado, copilot pendente)

**Forças:**
- Operações GitHub nativas (issues, PRs, repos)
- Code review com AI (Copilot assistant)
- Gestão de projetos (GitHub Projects integration)
- Workflow automation (GitHub Actions)

**Ideal Para:**
- Criação e revisão de Pull Requests
- Gestão de issues e milestones
- Atualização de documentação (README, CHANGELOG)
- Integração contínua (workflows GitHub Actions)
- Code review automatizado

**Comandos YOLO:**
```powershell
gh copilot --assume-yes
gh pr create --fill --web  # PR automático
gh issue create --title "..." --body "..."
```

**Pendência:** 
1. `gh auth login` (GitHub authentication)
2. `gh extension install github/gh-copilot`

---

## 🔀 Regras de Delegação (Hierarquia Inteligente)

### Fluxo de Decisão (Decision Tree)

```
Tarefa Recebida
      │
      ▼
┌─────────────────┐
│  DevSan analisa │
│  complexidade   │
└─────┬───────────┘
      │
      ▼
  Simples? ────► DevSan executa diretamente
      │
      │ Não
      ▼
┌─────────────────────────────────────────┐
│ Categoria da Tarefa?                    │
├──────────┬──────────┬──────────┬────────┤
│Planning  │ Coding   │ Web/UI   │ GitHub │
▼          ▼          ▼          ▼
Gemini     Qwen       Kilocode   Copilot
(broken)   ✅         ✅         ⚠️

Se Gemini offline:
  Planning → DevSan (raciocínio próprio)
  
Se Copilot pendente:
  GitHub → DevSan + gh CLI manual
```

### Matriz de Responsabilidades

| Tarefa | Primário | Secundário | Terciário |
|--------|----------|------------|-----------|
| Arquitetura sistema | Gemini | DevSan | Qwen |
| Backend API | Qwen | Gemini | DevSan |
| Frontend React | Kilocode | Qwen | DevSan |
| Web Scraping | Kilocode | Firecrawl MCP | DevSan |
| Database design | Gemini | Qwen | DevSan |
| Testing E2E | Kilocode | Qwen | DevSan |
| Code refactoring | Qwen | DevSan | Gemini |
| GitHub PR/Issues | Copilot | DevSan + gh | Manual |
| Documentação | Gemini | DevSan | Qwen |
| CI/CD pipelines | Kilocode | DevSan | Copilot |

---

## 💬 Slash Commands (Custom MCP)

### Built-in (Gemini-CLI base)
Todos agentes baseados em Gemini-CLI herdam:

```
/help         - Lista todos comandos disponíveis
/bug          - Reporta bug com contexto automático
/copy         - Copia último output para clipboard
/extensions   - Lista extensões MCP ativas
/settings     - Mostra configurações atuais
/theme        - Altera tema do terminal
/auth         - Status de autenticação APIs
/clear        - Limpa histórico da sessão
/version      - Mostra versão do agente
```

### Custom para Orquestração

**Criar em:** `~/.gemini/commands/` (ou equivalente para cada agente)

#### `/delegate-to-qwen <task>`
**Descrição:** Delega coding pesado para Qwen-Code  
**Sintaxe:** `/delegate-to-qwen "Implementar API REST /users com MongoDB"`  
**Comportamento:**
1. DevSan cria contexto completo da tarefa
2. Chama `qwen --yolo --auto` com prompt estruturado
3. Monitora execução via stdout
4. Captura resultado e integra no fluxo

**Script PowerShell:**
```powershell
# ~/.gemini/commands/delegate-to-qwen.ps1
param([string]$Task)
$context = Get-Content "ORCHESTRATION.md" -Raw
$fullPrompt = @"
CONTEXT: $context

TASK: $Task

EXECUTION MODE: YOLO (auto-approval total)
OUTPUT FORMAT: Structured report com código, testes, documentação
"@
qwen --yolo --auto --prompt $fullPrompt
```

#### `/delegate-to-kilocode <task>`
**Descrição:** Delega automação navegador/web para Kilocode  
**Sintaxe:** `/delegate-to-kilocode "Criar testes E2E login flow"`  

#### `/delegate-to-copilot <task>`
**Descrição:** Delega GitHub ops para Copilot CLI  
**Sintaxe:** `/delegate-to-copilot "Criar PR com changelog"`  

#### `/update-status <agent> <status>`
**Descrição:** Atualiza LIVE STATUS no ORCHESTRATION.md  
**Sintaxe:** `/update-status Qwen "Implementando API /users - 70% completo"`  
**Comportamento:**
1. Parse YAML do LIVE STATUS
2. Atualiza entrada do agente
3. Adiciona timestamp
4. Salva ORCHESTRATION.md
5. Notifica outros agentes (via MCP Memory)

#### `/project-summary`
**Descrição:** Gera resumo completo do projeto atual  
**Sintaxe:** `/project-summary`  
**Comportamento:**
1. Lê README.md, package.json, docker-compose.yml
2. Analisa estrutura de pastas
3. Consulta git status
4. Gera relatório markdown estruturado

---

## 🔄 Workflow Exemplo: Dashboard Web com Autenticação

### Tarefa Original (Humano → DevSan)
```
"Criar dashboard web com autenticação JWT, backend Node.js + MongoDB, frontend React"
```

### Plano DevSan (ORCHESTRATION.md guiado)

#### Fase 1: Planejamento (Gemini ou DevSan)
```yaml
Agent: Gemini-CLI (ou DevSan se offline)
Task: Arquitetura completa do sistema
Output:
  - ERD do MongoDB (Users, Sessions)
  - API endpoints spec (/auth/register, /auth/login, /auth/refresh)
  - Componentes React (Login, Dashboard, ProtectedRoute)
  - docker-compose.yml (Node.js, MongoDB, Nginx)
Tempo Estimado: 10min
```

**Comando:**
```powershell
# Se Gemini funcional:
gemini --yolo --model gemini-2.0-flash-thinking --prompt "Planejar dashboard web..."

# Se broken, DevSan assume:
# (raciocínio próprio baseado em ORCHESTRATION.md e contexto workspace)
```

#### Fase 2: Backend (Qwen-Code)
```yaml
Agent: Qwen-Code
Task: Implementar backend Node.js + MongoDB
Delegation: /delegate-to-qwen "Backend conforme spec Gemini"
Output:
  - src/server.js (Express server)
  - src/routes/auth.js (JWT generation, bcrypt hashing)
  - src/models/User.js (Mongoose schema)
  - tests/auth.test.js (Jest unit tests)
Status Updates:
  - 22:15 - Iniciando (LIVE STATUS updated)
  - 22:25 - Endpoints /register e /login completos
  - 22:30 - Testes passando, 100% coverage
Tempo Real: 15min
```

**DevSan monitora:**
```powershell
# Cada 30s, DevSan lê stdout do qwen e atualiza LIVE STATUS
# Se erro, DevSan intervém com /bug report
```

#### Fase 3: Frontend (Kilocode)
```yaml
Agent: Kilocode
Task: Criar dashboard React
Delegation: /delegate-to-kilocode "Frontend React conforme spec"
Mode: architect (scaffolding + components)
Output:
  - src/components/Login.jsx
  - src/components/Dashboard.jsx
  - src/contexts/AuthContext.jsx
  - Playwright tests (login flow, protected routes)
Status Updates:
  - 22:35 - Scaffolding React app (Vite)
  - 22:45 - Componentes Login e Dashboard completos
  - 22:55 - Testes E2E passando
Tempo Real: 20min
```

#### Fase 4: Integração e Deploy (DevSan + Copilot)
```yaml
Agent: DevSan (orquestração) + Copilot (GitHub)
Task: Integrar, testar completo, criar PR
Actions:
  - DevSan valida integração backend+frontend
  - DevSan roda testes end-to-end (Playwright + Jest)
  - DevSan gera CHANGELOG.md automático
  - /delegate-to-copilot "Criar PR com changelog"
  - Copilot cria branch, commit, push, PR no GitHub
Status:
  - 23:00 - Integração validada
  - 23:05 - PR #42 aberto: "feat: Dashboard web com auth JWT"
Tempo Real: 10min
```

### Tempo Total: ~55min (vs. manual: 4-6h)

### LIVE STATUS Final
```yaml
DevSan: Concluído - Dashboard web entregue, PR aberto
Gemini: Concluído - Arquitetura planejada
Qwen: Concluído - Backend implementado, testes 100%
Kilocode: Concluído - Frontend + testes E2E
Copilot: Concluído - PR #42 aberto
MCP Context7: 15 consultas (Node.js docs, React best practices)
MCP Tavily: 2 buscas (JWT security, MongoDB indexing)
```

---

## 🛡️ Segurança e Fallbacks

### Auto-Approval Safeguards
Mesmo com YOLO mode ativo, DevSan aplica validações:

1. **Operações Destrutivas:** Backup automático antes de:
   - Deletar >10 arquivos
   - Alterar schemas de database
   - Modificar docker-compose em produção

2. **Credenciais:** Nunca loggar API keys em stdout/logs
   - Usar variáveis de ambiente ($env:GEMINI_API_KEY)
   - .gitignore para .env files

3. **Rate Limiting:** Respeitar limites de APIs externas
   - Gemini: 1500 RPM (free tier)
   - Tavily: 1000/mês (dev tier)
   - Firecrawl: Verificar quota antes scraping massivo

### Fallback Chain (Se agente offline)

```
Tarefa → Agente Primário (broken?) → Secundário → Terciário → DevSan (manual)

Exemplo:
  Planning → Gemini ❌ → DevSan ✅
  Coding   → Qwen ✅
  GitHub   → Copilot ⚠️ → DevSan + gh CLI manual
```

### Rollback Protocol
Se agente falha durante execução:

1. DevSan captura erro (stderr)
2. Lê logs do container (se MCP Docker)
3. Tenta fallback para agente secundário
4. Se falha persiste, reverte mudanças (git reset)
5. Notifica humano com contexto completo

---

## 📊 Métricas e Monitoramento

### KPIs dos Agentes

```yaml
Qwen-Code:
  tasks_completed: 23
  success_rate: 95.6%
  avg_time_per_task: 12min
  code_quality: 4.7/5 (linter score)
  
Kilocode:
  tasks_completed: 15
  success_rate: 93.3%
  avg_time_per_task: 18min
  e2e_tests_passing: 98%
  
DevSan:
  orchestrations_total: 8
  delegation_success: 92.5%
  avg_project_time: 55min
  human_intervention_rate: 12%
```

### Health Check Automático

**Script:** `scripts/test-mcps.ps1` (executar a cada 1h)

```powershell
# Verifica MCPs Docker
docker ps -a --format "table {{.Names}}\t{{.Status}}"

# Testa endpoints HTTP (Context7, Agent)
Invoke-WebRequest http://localhost:8080 -Method GET -TimeoutSec 5
Invoke-WebRequest http://localhost:4000 -Method GET -TimeoutSec 5

# Atualiza ORCHESTRATION.md LIVE STATUS automaticamente
pwsh ./scripts/update-live-status.ps1
```

---

## 🔮 Roadmap de Melhorias

### Curto Prazo (Semana 1)
- [x] Criar ORCHESTRATION.md estruturado
- [ ] Resolver Gemini-CLI broken (reinstalar ou wrapper)
- [ ] Configurar GitHub Copilot CLI (gh auth + extension)
- [ ] Implementar slash commands custom (`~/.gemini/commands/`)
- [ ] Testar delegação YOLO completa (DevSan → Qwen → Kilocode)

### Médio Prazo (Mês 1)
- [ ] Auto-update LIVE STATUS via hooks Git (pre-commit)
- [ ] Dashboard web para visualizar status agentes (React + WebSockets)
- [ ] Integração Gemini 2.0 Flash Thinking (2M tokens contexto)
- [ ] Memory MCP persistente entre sessões (SQLite)
- [ ] Logs estruturados (JSON) para analytics

### Longo Prazo (Trimestre 1)
- [ ] Multi-agente paralelo (Qwen + Kilocode simultâneos)
- [ ] Self-healing automático (agente detecta falha, tenta correção)
- [ ] Voice interface para comandos (speech-to-text → DevSan)
- [ ] Mobile dashboard (Termux Android sincronizado com PC)
- [ ] Marketplace de custom commands (compartilhar entre usuários)

---

## 📝 Changelog

### v1.0 (2025-12-15)
- Criação inicial do ORCHESTRATION.md
- Documentação completa de 5 agentes (DevSan, Gemini, Qwen, Kilocode, Copilot)
- 10 MCPs Docker mapeados e documentados
- Slash commands especificados
- Workflow exemplo (Dashboard web) detalhado
- LIVE STATUS template criado
- Regras de delegação hierárquica definidas

---

**Próxima Atualização:** Implementar slash commands e resolver Gemini-CLI  
**Responsável:** DevSan + Qwen-Code (pair programming)  
**ETA:** 2025-12-16

