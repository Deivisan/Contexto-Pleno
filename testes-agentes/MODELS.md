# MODELS.md - Modelos Gratuitos e Recomendações

## Modelos recomendados (gratuitos / leves)
- Grokcode Fast — preferir para tarefas Grok-native
- GPT-5 Mini — ótima relação custo/latência para prompts curtos e geração rápida
- Gemini (free models como gemini-2.5-flash) — uso para planejamento
- Qwen free models (qwen3-coder base) — uso para geração de código

## Como usar nos scripts
- Parametrizar variáveis de ambiente:
  - GEMINI_MODEL (ex: gemini-2.5-flash)
  - QWEN_MODEL (ex: qwen3-coder)
  - GROKCODE_MODEL (ex: grokcode-fast)
  - GPT5_MODEL (ex: gpt-5-mini)

## Exemplo de prompt tuning
- Para tarefas de planejamento: usar modelos "flash-thinking" com max 1-2 passos de saída
- Para coding: usar modelos "coder" com instruções de testes e lint

## Observações
- Sempre selecionar modelos mais baratos para tarefas de validação e reservando modelos maiores para produção
- Monitorar quotas e custos ao usar APIs comerciais
