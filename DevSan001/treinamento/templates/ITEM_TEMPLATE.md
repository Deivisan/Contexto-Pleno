# Template de item de treinamento

Nome: NOME_DA_FEATURE

Resumo
--
Breve descrição do que esta feature faz e por que existe.

Metadata (metadata.yaml)
--
```yaml
name: NOME_DA_FEATURE
author: SeuNome
date: 2025-12-16
tags: [grok,images,playwright]
reproducible: true
requires: [playwright, node>=25]
notes: "Observações importantes"
```

Pastas
--
- `logs/` — arquivos de log (stdout/stderr/trace).  
- `data/` — prompts, exemplos, datasets (formato txt/json/csv).  
- `artifacts/` — imagens geradas, modelos, embeddings.  

Checklist de experimento
--
1. Criar `metadata.yaml` com campos preenchidos.
2. Rodar script de treino/execução e salvar logs em `logs/`.
3. Salvar outputs relevantes em `artifacts/`.
4. Atualizar `README.md` com resultados e próximos passos.
