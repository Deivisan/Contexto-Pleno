# testes-agentes

Propósito: Scripts e logs para automatizar a validação/configuração dos agentes do squad (DevSan, Gemini, Qwen, Kilocode, Copilot) e MCPs.

Instruções:
- Rode `pwsh ./run-all.ps1` para executar todos os testes (gera logs em `logs/`).
- Scripts isolados:
  - `test_gemini.ps1` - verifica versão e executa prompt de planejamento curto
  - `test_qwen.ps1` - verifica versão e gera um endpoint de exemplo
  - `test_kilocode.ps1` - verifica versão e scaffolds um projeto Vite + Playwright
  - `test_copilot.ps1` - verifica `gh` auth e instala extensão Copilot se necessário
  - `test_firecrawl_capture.ps1` - valida captura de conversas com Firecrawl (3 URLs de teste)
- Logs: `testes-agentes/logs/` contém saídas com timestamps

Observação para RPA e agentes automatizados:
- Por favor, execute testes aqui para evitar espalhar arquivos temporários pelo workspace.
- Mantenha resultados em `logs/` e abra PRs para melhorias nos scripts.
