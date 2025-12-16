# 🐳 MCPs Docker — Guia Completo

> **Última Atualização:** 2025-12-09  
> **Status:** ✅ Funcionando

---

## 📋 Visão Geral

Este documento descreve todos os MCPs disponíveis via Docker containers, suas configurações e como usá-los.

---

## 🎯 MCPs Disponíveis

| MCP | Imagem Docker | Tipo | Status | Descrição |
|-----|---------------|------|--------|-----------|
| **Context7** | `mcp/context7` | HTTP/SSE | ✅ Ativo | Documentação de bibliotecas |
| **Tavily** | `mcp/tavily` | STDIO | ✅ Ativo | Busca web avançada |
| **Memory** | `mcp/memory` | STDIO | ✅ Ativo | Memória persistente (Knowledge Graph) |
| **Fetch** | `mcp/fetch` | STDIO | ✅ Ativo | HTTP requests |
| **Filesystem** | `mcp/filesystem` | STDIO | ✅ Ativo | Acesso a arquivos |
| **Playwright** | `mcp/playwright` | STDIO | ✅ Ativo | Automação de browser |
| **Sequential Thinking** | `mcp/sequentialthinking` | STDIO | ⏸️ Disponível | Raciocínio complexo |
| **Git** | `mcp/git` | STDIO | ⏸️ Disponível | Operações Git |
| **GitHub** | `ghcr.io/github/github-mcp-server` | STDIO | ⏸️ Disponível | GitHub API |

---

## 📦 Context7

### Descrição
Fornece documentação atualizada de bibliotecas e frameworks para LLMs.

### Configuração

```json
{
  "context7": {
    "url": "http://localhost:8080/sse",
    "disabled": false,
    "autoApprove": ["resolve-library-id", "get-library-docs"]
  }
}
```

### Container (HTTP/SSE)

```bash
# Iniciar container (sempre rodando)
docker run -d \
  --name mcp-context7 \
  -p 8080:8080 \
  --restart unless-stopped \
  mcp/context7:latest
```

### Tools Disponíveis

| Tool | Descrição |
|------|-----------|
| `resolve-library-id` | Resolve nome de biblioteca para ID Context7 |
| `get-library-docs` | Obtém documentação da biblioteca |

---

## 🔍 Tavily

### Descrição
Busca web avançada com AI, extração de conteúdo e crawling.

### Configuração

```json
{
  "tavily": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "-e", "TAVILY_API_KEY", "mcp/tavily"],
    "env": {
      "TAVILY_API_KEY": "sua-api-key"
    },
    "disabled": false,
    "autoApprove": ["tavily-search", "tavily-extract"]
  }
}
```

### Tools Disponíveis (4)

| Tool | Descrição |
|------|-----------|
| `tavily-search` | Busca web com AI |
| `tavily-extract` | Extração de conteúdo de URLs |
| `tavily-crawl` | Web crawler estruturado |
| `tavily-map` | Mapeamento de estrutura de sites |

### Teste Manual

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | \
  docker run -i --rm -e TAVILY_API_KEY=xxx mcp/tavily
```

---

## 🧠 Memory

### Descrição
Memória persistente usando Knowledge Graph para armazenar entidades e relações.

### Configuração

```json
{
  "memory": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "-v", "mcp-memory-data:/data", "mcp/memory"],
    "disabled": false,
    "autoApprove": ["create_entities", "read_graph", "search_nodes"]
  }
}
```

### Volume Persistente

```bash
# Criar volume (se não existir)
docker volume create mcp-memory-data

# Verificar volume
docker volume inspect mcp-memory-data
```

### Tools Disponíveis (9)

| Tool | Descrição |
|------|-----------|
| `create_entities` | Criar entidades no grafo |
| `create_relations` | Criar relações entre entidades |
| `add_observations` | Adicionar observações a entidades |
| `delete_entities` | Remover entidades |
| `delete_observations` | Remover observações |
| `delete_relations` | Remover relações |
| `read_graph` | Ler grafo completo |
| `search_nodes` | Buscar nós por query |
| `open_nodes` | Abrir nós específicos |

---

## 🌐 Fetch

### Descrição
Realiza HTTP requests para buscar conteúdo web.

### Configuração

```json
{
  "fetch": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "mcp/fetch"],
    "disabled": false,
    "autoApprove": ["fetch"]
  }
}
```

### Tools Disponíveis

| Tool | Descrição |
|------|-----------|
| `fetch` | Buscar conteúdo de URL |

---

## 📁 Filesystem

### Descrição
Acesso seguro ao sistema de arquivos com diretórios permitidos.

### Configuração

```json
{
  "filesystem": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "-v", "C:/Projetos:/workspace", "mcp/filesystem", "/workspace"],
    "disabled": false,
    "autoApprove": ["read_file", "list_directory"]
  }
}
```

### Volumes

```bash
# Montar diretório específico
-v "C:/Projetos:/workspace"

# Montar múltiplos diretórios
-v "C:/Projetos:/workspace" -v "C:/Users/Deivi:/home"
```

### Tools Disponíveis

| Tool | Descrição |
|------|-----------|
| `read_file` | Ler arquivo |
| `write_file` | Escrever arquivo |
| `list_directory` | Listar diretório |
| `create_directory` | Criar diretório |
| `search_files` | Buscar arquivos |
| `get_file_info` | Informações do arquivo |
| `move_file` | Mover/renomear arquivo |

---

## 🎭 Playwright

### Descrição
Automação de browser para navegação, screenshots e interação com páginas web.

### Configuração

```json
{
  "playwright": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "mcp/playwright"],
    "disabled": false,
    "autoApprove": ["playwright_navigate", "playwright_screenshot"]
  }
}
```

### Tools Disponíveis

| Tool | Descrição |
|------|-----------|
| `browser_navigate` | Navegar para URL |
| `browser_click` | Clicar em elemento |
| `browser_type` | Digitar texto |
| `browser_screenshot` | Capturar screenshot |
| `browser_snapshot` | Snapshot de acessibilidade |
| `browser_fill_form` | Preencher formulário |

---

## 🤔 Sequential Thinking

### Descrição
Raciocínio sequencial para problemas complexos.

### Configuração

```json
{
  "sequentialthinking": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "mcp/sequentialthinking"],
    "disabled": true,
    "autoApprove": []
  }
}
```

---

## 📂 Git

### Descrição
Operações Git em repositórios.

### Configuração

```json
{
  "git": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "-v", "C:/Projetos:/workspace", "mcp/git", "-r", "/workspace/repo-name"],
    "disabled": true,
    "autoApprove": []
  }
}
```

> **Nota:** Requer argumento `-r` com path do repositório.

---

## 🐙 GitHub

### Descrição
Acesso completo à API do GitHub.

### Configuração

```json
{
  "github": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server", "stdio"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "seu-token"
    },
    "disabled": true,
    "autoApprove": []
  }
}
```

> **Nota:** Requer subcomando `stdio` no final.

---

## 🔧 Comandos Úteis

### Listar Imagens MCP

```bash
docker images | Select-String "mcp"
```

### Verificar Containers Rodando

```bash
docker ps --filter "name=mcp"
```

### Testar MCP STDIO

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | docker run -i --rm mcp/nome-do-mcp
```

### Ver Logs de Container

```bash
docker logs mcp-context7 --tail 50
```

---

## 📊 Tamanhos das Imagens

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

---

## 📚 Referências

- [Docker MCP Catalog](https://hub.docker.com/catalogs/mcp)
- [Model Context Protocol](https://modelcontextprotocol.io)
- [MCP Specification](https://spec.modelcontextprotocol.io)
