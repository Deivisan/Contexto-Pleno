# Roadmap e Plano de Testes - Squad de Agentes

## Objetivo
Configurar, validar e integrar todos os agentes (DevSan, Gemini-CLI, Qwen-Code, Kilocode, GitHub Copilot CLI) com MCPs Docker. Garantir que cada agente consiga executar missões satisfatórias usando modelos gratuitos (Grokcode Fast, GPT-5 Mini, Gemini/Qwen free models) e documentar as iterações em `testes-agentes/`.

---

## Fases e Tarefas (Curto Prazo, 0-48h)

1. Validar e recuperar agentes
   - [ ] Gemini-CLI: confirmar binário funcional (feito: v0.20.2). Responsável: DevSan
   - [ ] Qwen-Code: validar prompt execution (v0.5.0). Responsável: Qwen
   - [ ] Kilocode: validar scaffolding e Playwright integration. Responsável: Kilocode
   - [ ] Copilot CLI: autenticar (`gh auth login`) e instalar extensão. Responsável: Humano + DevSan

2. Validar infra MCPs
   - [x] Aplicar env vars (scripts/apply-mcp-env.ps1)
   - [ ] Expor host ports faltantes (recreate with -p via recreate-commands.ps1)
   - [ ] Criar healthchecks automatizados (scripts/test-all-mcps.ps1)

3. Validar Firecrawl Capture Completa
   - [ ] Escolher 3 conversas reais (curta, média, longa)
   - [ ] Executar `test_firecrawl_capture.ps1` e comparar contagem de mensagens
   - [ ] Registrar evidências nos logs

4. Teste de Delegação (YOLO)
   - [ ] Criar tarefa piloto (ex: dashboard web auth)
   - [ ] Orquestrar DevSan → Gemini/Qwen → Kilocode → Copilot
   - [ ] Validar integridade: código, testes, PR criado

---

## Fases (Médio Prazo, 1-4 semanas)

- Automatizar execução de `testes-agentes/run-all.ps1` via CI salvo logs em `artifacts/tests/`
- Criar dashboard React para LIVE STATUS com WebSocket integrado (context7 + agent MCP)
- Implementar Memory MCP persistente (sqlite)
- Implementar auto-update de ORCHESTRATION.md via hooks Git

---

## Fases (Longo Prazo, 1-3 meses)

- Multi-agent paralelo (execuções concorrentes de Qwen + Kilocode)
- Self-healing (scripts que reiniciam MCPs com falhas e notificam via ORCHESTRATION.md)
- Voice interface (speech-to-text para DevSan)

---

## Delegação Automática (Mini-tarefas para agentes)
- Gemini: criar plano arquitetural (2 passos) para cada tarefa do roadmap
- Qwen: gerar código base e testes unitários automaticamente
- Kilocode: gerar E2E Playwright tests e scaffolding frontend
- Copilot: abrir PRs com changelogs e criar templates de PR
- DevSan: coordenar os passos acima e atualizar LIVE STATUS

---

## Instruções para RPA/Agentes de execução
- Use `pwsh ./testes-agentes/run-all.ps1` para rodar todos os testes e manter arquivos de log em `testes-agentes/logs/`
- Ao rodar testes, abra PR com resultados e proponha melhorias nos scripts
- Para não poluir workspace, tudo temporário fica em `testes-agentes/logs/` e outputs de prompt em `testes-agentes/outputs/`

---

## Entregáveis imediatos
- Testes automáticos (scripts já presentes)
- Roadmap e plano de execução (este arquivo)
- Orquestração completa com ORCHESTRATION.md e PENDENCIAS.md

---

## Observações sobre modelos gratuitos
- Priorizar uso de: Grokcode Fast (quando disponível), GPT-5 Mini, Gemini/Qwen free models (model names configuráveis nos scripts)
- Adicionar `MODELS.md` com instruções de como selecionar modelos gratuitos e exemplos de prompts


---

**Próximo passo recomendado:** executar `pwsh ./testes-agentes/run-all.ps1` pós autenticação GH para coletar baseline e corrigir falhas apontadas nos logs.
