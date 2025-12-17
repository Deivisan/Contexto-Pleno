# Treinamento — DevSan001

Esta pasta centraliza tudo relacionado ao treinamento, logs e artefatos usados para ensinar/afinar comportamentos do agente DevSan001.

Princípios
- Cada feature/implementação tem sua própria subpasta dentro de `treinamento/`.
- Em cada subpasta deve existir pelo menos:
  - `README.md` — descrição do propósito e instruções de uso
  - `logs/` — logs de execução e erros
  - `data/` — exemplos, prompts, datasets usados
  - `artifacts/` — modelos, embeddings, vetores, snapshots
  - `metadata.yaml` — metadados (autor, data, tags, requisitos)

Estrutura inicial (exemplo)
```
DevSan001/treinamento/
  ├─ feature-example/  # pasta de uma feature/experimento
  │   ├─ README.md
  │   ├─ metadata.yaml
  │   ├─ logs/
  │   ├─ data/
  │   └─ artifacts/
  ├─ templates/
  │   └─ ITEM_TEMPLATE.md
  └─ README.md
```

Fluxo recomendado
1. Criar subpasta com nome claro (ex: `grok-image-automation-v1`).
2. Preencher `metadata.yaml` com o contexto e instruções de reprodução.
3. Registrar logs em `logs/` durante execuções; salvar artefatos em `artifacts/`.
4. Documentar lições aprendidas no `README.md` da feature.

Uso com agentes
- Coloque prompts e tarefas em `data/` para que agentes possam ler e iterar automaticamente.

Segurança e privacidade
- Não comitar credenciais ou dados sensíveis. Use referências e placeholders em `metadata.yaml`.
