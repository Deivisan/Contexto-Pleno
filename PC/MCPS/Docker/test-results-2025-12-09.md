# 🧪 MCP Docker Test Results
**Data:** 2025-12-09 21:50 BRT (Atualizado)

## Resumo dos Testes

| MCP | Tipo | Imagem | Status | Tools |
|-----|------|--------|--------|-------|
| context7 | HTTP/SSE | mcp/context7 | ✅ OK | 2 (resolve-library-id, get-library-docs) |
| tavily | STDIO | mcp/tavily | ✅ OK | 4 (search, extract, crawl, map) |
| memory | STDIO | mcp/memory | ✅ OK | 9 (create_entities, read_graph, etc) |
| fetch | STDIO | mcp/fetch | ✅ OK | 1 (fetch) |
| filesystem | STDIO | mcp/filesystem | ✅ OK | Precisa volume |
| playwright | STDIO | mcp/playwright | ✅ OK | Browser automation |
| sequentialthinking | STDIO | mcp/sequentialthinking | ✅ OK | Thinking tools |
| git | STDIO | mcp/git | ⚠️ Requer -r | Precisa repo path |
| github | STDIO | ghcr.io/github/github-mcp-server | ⚠️ Requer stdio | Precisa subcomando |

## Detalhes dos Testes

### ✅ Context7 (HTTP/SSE)
```
Container: mcp-context7
Status: Up
Porta: 8080
Endpoint: http://localhost:8080/mcp
Transport: SSE (Server-Sent Events)
```

### ✅ Tavily (STDIO)
```bash
# Comando funcional
docker run -i --rm -e TAVILY_API_KEY=xxx mcp/tavily

# Tools disponíveis (4):
- tavily-search: Busca web com AI
- tavily-extract: Extração de conteúdo de URLs
- tavily-crawl: Web crawler estruturado
- tavily-map: Mapeamento de estrutura de sites
```

### ✅ Memory (STDIO)
```bash
# Comando funcional
docker run -i --rm -v mcp-memory-data:/data mcp/memory

# Tools disponíveis (9):
- create_entities
- create_relations
- add_observations
- delete_entities
- delete_observations
- delete_relations
- read_graph
- search_nodes
- open_nodes
```

### ✅ Fetch (STDIO)
```bash
# Comando funcional
docker run -i --rm mcp/fetch

# Tools disponíveis:
- fetch: HTTP requests
```

### ✅ Filesystem (STDIO)
```bash
# Comando funcional
docker run -i --rm -v "C:/Projetos:/workspace" mcp/filesystem /workspace

# Nota: Precisa de volume montado para acessar arquivos
```

### ✅ Playwright (STDIO)
```bash
# Comando funcional
docker run -i --rm mcp/playwright

# Tools: Browser automation (navigate, click, fill, screenshot, etc)
```

### ✅ Sequential Thinking (STDIO)
```bash
# Comando funcional
docker run -i --rm mcp/sequentialthinking

# Tools: Pensamento sequencial para raciocínio complexo
```

### ⚠️ Git (STDIO)
```bash
# Requer path do repositório
docker run -i --rm -v "C:/Projetos/Contexto-Pleno:/repo" mcp/git -r /repo

# Nota: Precisa do argumento -r com path do repo
```

### ⚠️ GitHub (STDIO)
```bash
# Requer subcomando 'stdio'
docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN=xxx ghcr.io/github/github-mcp-server stdio

# Nota: Precisa do subcomando 'stdio' no final
```

## Configuração Recomendada para Kiro

### MCPs Funcionais via Docker STDIO:
1. **tavily** - Busca web (4 tools)
2. **memory** - Memória persistente (9 tools)
3. **fetch** - HTTP requests
4. **filesystem** - Acesso a arquivos
5. **playwright** - Automação de browser
6. **sequentialthinking** - Raciocínio complexo

### MCPs HTTP (Container sempre rodando):
1. **context7** - Documentação de bibliotecas (porta 8080)

### MCPs com Configuração Especial:
1. **git** - Precisa de volume e -r path
2. **github** - Precisa de subcomando stdio

## Imagens Docker Disponíveis

| Imagem | Tamanho |
|--------|---------|
| mcp/context7 | 425MB |
| mcp/tavily | 248MB |
| mcp/memory | 233MB |
| mcp/fetch | 406MB |
| mcp/filesystem | 249MB |
| mcp/playwright | 1.4GB |
| mcp/sequentialthinking | 236MB |
| mcp/git | 477MB |
| ghcr.io/github/github-mcp-server | 53.9MB |

## Volume Persistente
```
mcp-memory-data - Volume para dados do Memory MCP
```
