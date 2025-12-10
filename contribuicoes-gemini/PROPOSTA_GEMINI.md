# 💎 Proposta de Evolução do Workspace "Contexto-Pleno"

**Autor:** Gemini (Nano Banana)  
**Data:** 2025-12-09  
**Assunto:** Sugestões para aprimorar a arquitetura de MCPs universais, com foco em robustez, escalabilidade e integração com Google Genkit.

---

## 1. Visão Geral da Proposta

A iniciativa de criar um hub universal de MCPs com Docker é visionária e resolve um problema central na utilização de múltiplos agentes de IA: a consistência do ambiente e das ferramentas.

Esta proposta visa construir sobre essa base sólida, introduzindo conceitos e ferramentas que podem levar o "Contexto-Pleno" a um novo patamar de profissionalismo e eficiência. As sugestões focam em três pilares:

1.  **Orquestração com Google Genkit:** Centralizar a lógica de "flows" de IA.
2.  **Robustez da Arquitetura Docker:** Aprimorar o `docker-compose.yml` para produção.
3.  **Gestão e Segurança:** Melhorar o gerenciamento de configurações e segredos.

---

## 2. Proposta Técnica: Integrando Google Genkit

O **Google Genkit** é um framework open-source projetado exatamente para o problema que este workspace se propõe a resolver: orquestrar modelos, ferramentas (como os MCPs) e fluxos de IA de forma estruturada.

**Por que usar Genkit aqui?**

-   **Orquestração Nativa:** Em vez de scripts PowerShell para gerenciar contêineres, o Genkit pode definir "flows" que invocam os MCPs de forma programática.
-   **Dev UI:** O Genkit inclui uma UI de desenvolvimento local para testar, visualizar e depurar as interações entre os agentes e os MCPs.
-   **Escalabilidade:** Facilita a implantação futura dos seus agentes como endpoints de API seguros no Google Cloud (Cloud Run) ou Firebase.
-   **Ecossistema de Plugins:** Já possui integrações com diversos modelos (Gemini, OpenAI, Anthropic) e bancos de dados vetoriais, alinhando-se com o roadmap de RAG (Retrieval-Augmented Generation).

### Arquitetura Proposta com Genkit

```mermaid
graph TD
    subgraph "Ambiente Local (Gerenciado pelo Genkit CLI)"
        A[Agente IA <br/>(Gemini, Claude, etc.)]
        B[Genkit Core <br/>(define 'flows')]
        C[Genkit Dev UI <br/>(localhost:4000)]
    end

    subgraph "Ferramentas Universais (Docker Compose)"
        D1[MCP: Tavily <br/>(localhost:3000)]
        D2[MCP: Memory <br/>(localhost:4000)]
        D3[MCP: Filesystem <br/>(localhost:6000)]
        D4[...]
    end

    A -->|1. Inicia 'flow'| B
    B -->|2. Executa 'flow'| B
    B -->|3. Invoca MCPs via HTTP| D1
    B -->|4. Retorna resultado| A
    C --|Monitora e Depura| B
    D1 --|> Docker| D1
```

### Plano de Ação para Integrar o Genkit

1.  **Instalar o Genkit:**
    ```bash
    npm install -g genkit
    ```

2.  **Inicializar um Projeto Genkit:** Na raiz de `Contexto-Pleno`, criar um subdiretório `genkit-orchestrator` e iniciar um projeto.
    ```bash
    mkdir genkit-orchestrator
    cd genkit-orchestrator
    genkit init
    ```

3.  **Definir os MCPs como "Tools" no Genkit:** Criar plugins customizados que fazem chamadas HTTP para os contêineres Docker dos MCPs.

    *Exemplo de um "tool" para o MCP Tavily:*
    ```typescript
    // genkit-orchestrator/src/tavily-tool.ts
    import { defineTool } from '@genkit-ai/ai';
    import { z } from 'zod';
    import axios from 'axios';

    export const tavilySearch = defineTool(
      {
        name: 'tavilyWebSearch',
        description: 'Searches the web using the Tavily MCP.',
        inputSchema: z.object({ query: z.string() }),
        outputSchema: z.object({ content: z.string() }),
      },
      async (input) => {
        const response = await axios.post('http://localhost:3000/search', input);
        return response.data;
      }
    );
    ```

4.  **Criar "Flows":** Definir fluxos de trabalho que utilizam essas ferramentas.

    *Exemplo de um "flow" que pesquisa e resume:*
    ```typescript
    // genkit-orchestrator/src/index.ts
    import { configureGenkit } from '@genkit-ai/core';
    import { googleAI } from '@genkit-ai/googleai';
    import { tavilySearch } from './tavily-tool';
    import { generate } from '@genkit-ai/ai';
    import { z } from 'zod';

    export default configureGenkit({
      plugins: [googleAI({ apiKey: process.env.GOOGLE_API_KEY })],
      logLevel: 'debug',
      enableTracingAndMetrics: true,
    });

    export const researchAndSummarize = defineFlow(
      {
        name: 'researchAndSummarize',
        inputSchema: z.string(),
        outputSchema: z.string(),
      },
      async (topic) => {
        const searchResult = await tavilySearch.run({ query: topic });

        const summaryPrompt = `Based on this text, provide a summary: ${searchResult.content}`;
        const llmResponse = await generate({
            model: 'gemini-1.5-flash',
            prompt: summaryPrompt,
        });

        return llmResponse.text();
      }
    );
    ```

---

## 3. Aprimoramentos para Docker

O `docker-compose.yml` é a peça central. Proponho as seguintes melhorias para torná-lo mais robusto:

-   **Healthchecks:** Garantir que os contêineres não apenas "rodem", but que estejam respondendo corretamente antes de aceitar tráfego.
-   **Recursos Limitados:** Definir limites de CPU e memória para cada contêiner para evitar que um MCP problemático derrube o sistema.
-   **Rede Dedicada:** Criar uma rede Docker (`bridge`) para os MCPs se comunicarem, isolando-os de outras aplicações.
-   **Nomes de Contêiner Padrão:** Manter um padrão como `mcp-<nome>` para facilitar a automação.

### Exemplo de `docker-compose.yml` Aprimorado:

```yaml
version: '3.8'

networks:
  mcp_network:
    driver: bridge

services:
  tavily:
    image: mcp/tavily:latest
    container_name: mcp-tavily
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - TAVILY_API_KEY=${TAVILY_API_KEY}
    networks:
      - mcp_network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: '512M'

  # ... outros MCPs ...

```

---

## 4. Gestão e Segurança

-   **Central de Documentação:** Criar um `docs/README.md` que sirva como um portal para toda a documentação, linkando para os guias de agentes, IDEs e MCPs. Isso facilitaria a navegação.
-   **Template de Novo Agente:** Criar um `TEMPLATE_AGENTE.md` para padronizar a adição de novos agentes ao ecossistema.
-   **Validação de Ambiente:** Aprimorar o script `validate-agents.ps1` para não apenas checar a existência, mas também a conectividade de cada agente com os MCPs Dockerizados, reportando uma tabela de status (e.g., `[ ✅ ] Gemini -> Tavily MCP`).

---

## 5. Próximos Passos Sugeridos

1.  **Criar o diretório `genkit-orchestrator`** e implementar um "flow" de prova de conceito.
2.  **Refatorar o `docker-compose.yml`** para incluir `healthchecks` e `resource limits`.
3.  **Criar um `docs/README.md`** para unificar a documentação.

Estou à disposição para detalhar e implementar qualquer um desses pontos. Acredito que essas melhorias trarão mais organização, resiliência e poder ao seu ecossÃ­stema de IA.
