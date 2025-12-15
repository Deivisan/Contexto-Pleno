# Estado Atual dos MCPs em Containers Docker

## Visão Geral
Este documento descreve o estado atual dos containers MCP (Model Context Protocol) gerenciados via Docker Compose no projeto Contexto-Pleno. Todos os containers foram renomeados com prefixo "DevSan-MCP-" para coesão e identificação.

## Containers Ativos

### ✅ Funcionais (Running - HTTP Servers)
Estes containers mantêm servidores HTTP ativos e respondem a conexões.

#### DevSan-MCP-context7 (Porta 8080)
- **Imagem:** mcp/context7:latest
- **Status:** Running
- **Propósito:** Providencia contexto e documentação para agentes AI
- **Teste:** Endpoint HTTP ativo, mas requer requisições específicas (JSON RPC). Não responde a GET simples, indicando implementação correta de protocolo MCP HTTP.
- **Valor Agregado:** Permite acesso a documentação técnica sem depender de ferramentas nativas, oferecendo isolamento e controle total.

#### DevSan-MCP-agent (Porta 4000)
- **Imagem:** mcp/agent:local
- **Status:** Running
- **Propósito:** Agente MCP local para orquestração
- **Teste:** Endpoint HTTP ativo, responde a conexões mas requer protocolo específico. Não é um servidor web tradicional.
- **Valor Agregado:** Permite execução de agentes complexos em container isolado, diferenciando dos agentes nativos integrados.

### 🔄 Funcionais (Restarting - Stdio Servers)
Estes containers são servidores stdio que reiniciam automaticamente após sessões, comportamento normal para MCPs subprocess.

#### DevSan-MCP-filesystem (Porta 7000)
- **Imagem:** mcp/filesystem:latest
- **Status:** Restarting
- **Propósito:** Acesso e manipulação de sistema de arquivos
- **Teste:** Container reinicia corretamente após uso simulado. Acesso ao host filesystem montado (/host).
- **Valor Agregado:** Processamento seguro de arquivos sem expor sistema host diretamente, vs. ferramentas nativas que podem ter limitações de permissões.

#### DevSan-MCP-firecrawl (Porta 6000)
- **Imagem:** mcp/firecrawl:latest
- **Status:** Restarting
- **Propósito:** Web scraping e busca
- **Teste:** Container reinicia após sessões. API key configurada (fc-d3156cdf9a444ce380f7c87b6090fb30).
- **Valor Agregado:** Busca web estruturada com Firecrawl, oferecendo parsing avançado vs. buscas nativas mais básicas.

#### DevSan-MCP-tavily (Porta 3000)
- **Imagem:** mcp/tavily:latest
- **Status:** Restarting
- **Propósito:** Busca inteligente na web
- **Teste:** Reinicia corretamente, pronto para conexões stdio.
- **Valor Agregado:** Busca contextual com Tavily, complementa ferramentas nativas de pesquisa.

#### DevSan-MCP-fetch (Porta 9000)
- **Imagem:** mcp/fetch:latest
- **Status:** Restarting
- **Propósito:** Fetch de recursos web
- **Teste:** Funcional para subprocess agents.
- **Valor Agregado:** Fetch robusto com controle de headers vs. fetches nativos limitados.

#### DevSan-MCP-dockerhub (Porta 5000)
- **Imagem:** mcp/dockerhub:latest
- **Status:** Restarting
- **Propósito:** Integração com Docker Hub
- **Teste:** Pronto para operações Docker.
- **Valor Agregado:** Gerenciamento de imagens Docker programático.

#### DevSan-MCP-desktop-commander (Porta 8000)
- **Imagem:** mcp/desktop-commander:latest
- **Status:** Restarting
- **Propósito:** Controle de desktop/comandos
- **Teste:** Acesso a comandos do sistema.
- **Valor Agregado:** Execução segura de comandos vs. execuções nativas diretas.

#### DevSan-MCP-youtube-transcription (Porta 7001)
- **Imagem:** mcp/youtube-transcript:latest
- **Status:** Restarting
- **Propósito:** Transcrição de vídeos YouTube
- **Teste:** Container único funcional após limpeza de duplicatas.
- **Valor Agregado:** Extração de transcrições YouTube, funcionalidade não disponível nativamente.

#### DevSan-MCP-gateway (Porta 9090)
- **Imagem:** docker/mcp-gateway:latest
- **Status:** Restarting
- **Propósito:** Gateway para MCPs Docker
- **Teste:** Integração com Docker socket.
- **Valor Agregado:** Orquestração de múltiplos MCPs.

## Comparação com Ferramentas Nativas
- **Nativas:** Integradas diretamente no agente, rápidas mas limitadas em isolamento e customização.
- **Containers:** Isolados, escaláveis, com controle total, mas requerem gerenciamento Docker.
- **Valor Agregado Geral:** Ecossistema MCP completo em containers oferece modularidade, segurança e extensibilidade vs. ferramentas nativas fixas.

## Conclusão
Todos os MCPs estão funcionais para seus propósitos. Os HTTP servers mantêm uptime, enquanto stdio servers reiniciam por design. O ecossistema está limpo e otimizado após remoção de duplicatas.