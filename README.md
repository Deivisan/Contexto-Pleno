<!--
README para repositório universal dos agentes: DevSan, Gemini, Qwen, Kilocode
Foco: garantir instalação e acessibilidade no Windows (PowerShell 7)
-->
# Contexto-Pleno — Repositório Universal dos Agentes


Este repositório é o hub do meu quarteto de agentes (DevSan, Gemini, Qwen e Kilocode) — agentes que rodam no Termux (Android) e também no PC. Este README foca na parte de PC (Windows) para garantir que os agentes estejam instalados e acessíveis via PowerShell 7 (pwsh).


## Agentes do quarteto

- DevSan — Agente de automação/coordenação pessoal
- Gemini CLI — Busca web, memória e integração com MCP
- Qwen CLI — Agente orientado a código
- Kilocode CLI — Geração rápida de código e scaffolding

Opcional: GitHub Copilot CLI — assistente para revisão e sugestão de código.

 
## Requisitos (Windows)

- Windows 10/11
- PowerShell 7 (pwsh) — preferível a Windows PowerShell 5.1
- Git
- Node.js 25+ (recomendado) — use nvm-windows, winget ou instalador em https://nodejs.org
- (opcional) Python 3.x

 
## Instalação (rápida, com winget)


Abra o PowerShell 7 como usuário com permissão de instalação e rode:

```powershell
# Atualizar política de execução (se necessário)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# Instalar requisitos via winget
winget install --accept-package-agreements --accept-source-agreements --exact -e OpenJS.NodeJS.LTS
winget install --accept-package-agreements --accept-source-agreements --exact -e Git.Git
winget install --accept-package-agreements --accept-source-agreements --exact -e Python.Python.3
```

Se não possuir winget, use o instalador do Node.js (LTS) e o instalador do Git manualmente.

 
## Instalar os agentes via npm (global)


```powershell
# Instala globalmente os CLIs de cada agente
npm install -g @qwen-code/qwen-code @google/gemini-cli @kilocode/cli @githubnext/github-copilot-cli

# Nota: DevSan é o agente local; configure uma forma de execução direta (veja seção abaixo)
```

 
## DevSan (local)

DevSan é um agente personalizado que pode existir localmente no repositório. Para deixá-lo acessível no PowerShell:


1) Crie um wrapper simples em `C:\Users\<seu-usuário>\AppData\Roaming\npm` ou adicione um alias no `pwsh` profile. Exemplo (PowerShell 7):

```powershell
# Script de exemplo para criar um 'devsan' entrypoint
mkdir -Force "$env:APPDATA\npm"
$scriptPath = "C:\Projetos\Contexto-Pleno\scripts\devsan.ps1"
if (!(Test-Path $scriptPath)) {
    New-Item -ItemType File -Path $scriptPath -Force -Value "Write-Host 'DevSan placeholder — customize scripts/devsan.ps1 para executar o agente'"
}

# Para acesso rápido, adicione um link simbólico (shim)
New-Item -ItemType File -Path "$env:APPDATA\npm\devsan.ps1" -Force -Value (Get-Content $scriptPath -Raw) | Out-Null
```

Depois adicione `$env:APPDATA\npm` ao `PATH` (se ainda não estiver) para o usuário.

 
## Garantir PATH do npm global no PowerShell 7

Verifique se o caminho global do npm está adicionado ao PATH de usuário. O caminho padrão é `%APPDATA%\npm`.


```powershell
# Verificar
Get-ChildItem Env:Path | Select-String "%APPDATA%\\npm" -Quiet;

# Se ausente, adicione permanentemente
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $Env:APPDATA + "\\npm", "User")

# Após adicionar, feche e reabra o PowerShell 7
```

 
## Verificando instalações e acessibilidade (PowerShell 7)


```powershell
# Verificar versões
node --version
npm --version
git --version
python --version

# Verificar comandos dos agentes
Get-Command qwen
Get-Command gemini
Get-Command kilocode
Get-Command copilot

# Se houver retorno, os comandos estão acessíveis em PATH
```

 
## Script de instalação/validação rápida

- Incluí um script automatizado para Windows em `scripts/setup-windows.ps1` que:
- Verifica Node.js, Git, Python
- Instala Node se necessário (via winget)
- Adiciona `%APPDATA%\npm` ao PATH de usuário
- Instala os agentes via npm global
- Verifica comandos e versões

Para executar localmente:

```powershell
pwsh ./scripts/setup-windows.ps1
```

 
## Observações sobre Termux

Este repositório também contém documentação para rodar os agentes em Termux (Android). As instruções para Termux são distintas e estão mantidas nos arquivos `QWEN.md`, `GEMINI.md`, `KILOCODE.md`, `DevSan.md`.

 
## Contribuição e Personalização

- Edite `scripts/setup-windows.ps1` para personalizar instalações (ex: usar Chocolatey, instaladores manuais, configuração de proxys)
- DevSan pode ser integrado como um executável Node ou PowerShell — considere criar um pequeno CLI wrapper (npm link ou um módulo npm local) para facilitar execução direta `devsan` no terminal.

 
## Comandos rápidos de troubleshooting

- `npm root -g` — mostra onde os binários globais são colocados
- `where.exe qwen` — localiza executáveis no PATH (Windows CLI)
- `Get-Command qwen` — verifica em PowerShell
 
## MCPS (Model Context Protocol Servers)
Criamos a pasta `MCPS/Docker` com scripts e exportados atuais do Docker para facilitar integrações:


Scripts úteis:
 - `scripts/validate-agents.ps1` — valida se os CLIs estão instalados e acessíveis no PATH, gerando `MCPS/Docker/agents-validation.json`

Para tornar MCPs acessíveis globalmente aos agentes CLI:
1. Exponha portas dos containers com `docker run -p hostPort:containerPort` ou atualize a configuração do serviço.
2. Rode `pwsh ./scripts/export-docker-containers.ps1` para atualizar `containers.json`.
3. Rode `pwsh ./scripts/apply-mcp-env.ps1` para gravar variáveis de ambiente no Windows (`setx`).
4. Abra um novo PowerShell para herdar as variáveis.
5. Para executar os testes de saúde dos MCPs e coletar logs, execute:

```powershell
pwsh ./scripts/test-mcps.ps1
```
Os resultados estarão em `MCPS/Docker/test-results.json` e os logs em `MCPS/Docker/logs/`.

Para validar a instalação dos CLIs dos agentes (versões e acessibilidade PATH):

```powershell
pwsh ./scripts/validate-agents.ps1
```
O arquivo `MCPS/Docker/agents-validation.json` terá os dados de validação.

 
## Licença

MIT — sinta-se livre para adaptar e replicar.

---
Arquivo gerado automaticamente por uma tarefa de script.

---

## 🧠 Orquestração Multi-Agente (Novo!)

### Sistema Completo Implementado

Este repositório agora inclui **orquestração inteligente de múltiplos agentes CLI** usando metodologia YOLO (auto-approval total) e delegação hierárquica.

**Documentação Central:** [ORCHESTRATION.md](ORCHESTRATION.md)

### Agentes Ativos

1. **DevSan** - Orquestrador raiz (A.G.I. agentica, auto-aprovação total)
2. **Gemini-CLI** - Planejador estratégico (⚠️ temporariamente broken)
3. **Qwen-Code** - Executor de código (✅ funcional)
4. **Kilocode** - Automação navegador (✅ funcional)
5. **GitHub Copilot CLI** - GitHub ops (⚠️ parcial, pendente auth)

### MCPs Docker (10 containers)

- **Context7** (8080) - Documentação AI
- **Agent MCP** (4000) - Orquestração local
- **Firecrawl** (6000) - Web scraping avançado
- **Tavily** (3000) - Busca web inteligente
- **Filesystem** (7000) - Manipulação arquivos
- **Fetch**, **DockerHub**, **Desktop-Commander**, **YouTube-Transcript**, **Gateway**

### Comandos Customizados

Implementados em `~/.gemini/commands/`:

```powershell
# Delegação automática
/delegate-to-qwen "Implementar API REST /users"
/delegate-to-kilocode "Criar testes E2E login flow"

# Status tracking
/update-status Qwen "Implementando backend - 70%"

# Relatórios
/project-summary
```

### Workflow Exemplo

```yaml
Tarefa: "Criar dashboard web com autenticação JWT"

DevSan (Raiz):
  - Lê ORCHESTRATION.md
  - Planeja em fases (arquitetura → backend → frontend → deploy)
  
Gemini (Planejamento):
  - Especifica ERD, API endpoints, componentes React
  
Qwen (Backend):
  - Implementa Node.js + MongoDB com testes
  - Atualiza LIVE STATUS: 25% → 50% → 75% → 100%
  
Kilocode (Frontend):
  - Scaffolds React app, cria componentes
  - Testes E2E com Playwright
  
Copilot (GitHub):
  - Cria branch, commit, PR automaticamente
  
Tempo Total: ~55min (vs. manual: 4-6h)
```

### Status Atual (15/12/2025)

- ✅ ORCHESTRATION.md criado (550+ linhas)
- ✅ Slash commands implementados (4 scripts PowerShell)
- ✅ MCPs Docker mapeados e documentados
- ⚠️ Gemini-CLI broken (binário não acessível)
- ⚠️ Copilot CLI pendente (gh auth + extension)
- 📋 Próximo: Resolver agentes broken, testar delegação YOLO completa

**Ver detalhes completos:** [ORCHESTRATION.md](ORCHESTRATION.md)

---
