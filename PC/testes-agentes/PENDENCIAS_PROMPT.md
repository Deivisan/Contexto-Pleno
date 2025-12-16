# Prompt de Pendências (Resumo)

**Objetivo curto:** Executar as tarefas faltantes para validar e automatizar a geração e publicação dos sites dos agentes, com checks de qualidade e integração CI.

## Prompt (pt-BR)

> Resumo das pendências: 1) Validar HTML5 e acessibilidade (axe/pa11y) para todos os sites em `testes-agentes/sites` e corrigir problemas críticos; 2) Automatizar geração via CI (workflow que roda os scripts em `testes-agentes/rpa/*` e salva screenshots/logs como artifacts); 3) Garantir que cada agente CLI gere seu próprio site autonomamente (testar wrappers `/delegate-to-*`, resolver flags incompatíveis e autenticações necessárias); 4) Autenticar e instalar GitHub Copilot CLI (`gh auth login` + `gh extension install github/gh-copilot`) e validar commit/PR automático pelo Copilot; 5) Resolver Gemini-CLI (reinstalar/configurar) ou documentar fallback; 6) Expor MCPs faltantes com host bindings e atualizar `scripts/apply-mcp-env.ps1`; 7) Publicar sites (GitHub Pages/Netlify) e gerar README com links públicos; 8) Adicionar checks (lint, HTML validator, accessibility) e obrigação de passar no CI antes de merge. Use modo **YOLO** quando apropriado para execuções automáticas e reporte status em checkpoints: 25% / 50% / 75% / 100% com logs e artifacts.

## Ações sugeridas (comandos exemplos)

- Delegar para Qwen: `pwsh "$env:USERPROFILE\.gemini\commands\delegate-to-qwen.ps1" -Task "Gerar site Qwen-Code via rpa/generate_qwen.ps1 e commitar"`
- Delegar para Kilocode: `pwsh "$env:USERPROFILE\.gemini\commands\delegate-to-kilocode.ps1" -Task "Gerar site Kilocode via rpa/generate_kilocode.ps1" -Mode orchestrator`
- Validação de acessibilidade (local): `npx pa11y http://localhost:8000/testes-agentes/sites/DevSan.html` (ou usar container/CI)
- CI (exemplo de checklist): executar `pwsh ./testes-agentes/rpa/*.ps1`, rodar validators, salvar screenshots e enviar artifacts.

> Nota: Prioridade inicial — validar acessibilidade e garantir geração automatizada. Execute `gh auth login` antes de instalar/usar Copilot CLI para operações GitHub automatizadas.

---

Salvei este prompt em `testes-agentes/PENDENCIAS_PROMPT.md`. Deseja que eu já execute (1) validação de acessibilidade agora ou (2) configure o workflow CI? 