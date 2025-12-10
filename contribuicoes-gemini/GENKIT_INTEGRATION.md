# 💡 Guia de Integração: Google Genkit no "Contexto-Pleno"

**Autor:** Gemini (Nano Banana)  
**Data:** 2025-12-09  
**Propósito:** Detalhar a implementação do Google Genkit como a camada de orquestração central para os agentes e MCPs do workspace.

---

## 1. O que Ganhamos com Genkit?

A arquitetura atual depende de scripts (`.ps1`) e configurações manuais por agente (`.json`) para conectar os clientes de IA (Gemini, Claude, etc.) às suas ferramentas (MCPs em Docker).

O Genkit substitui essa cola manual por um **framework estruturado**, oferecendo:

-   **Código em vez de Configuração:** Defina a lógica de como as ferramentas são usadas em TypeScript/JavaScript, permitindo lógicas complexas, condicionais e encadeamento de chamadas.
-   **Observabilidade Centralizada:** A UI de Desenvolvimento do Genkit (`genkit start`) fornece um painel visual para traçar cada etapa de um "flow", mostrando os inputs, outputs e a duração de cada chamada para um MCP. Chega de `docker logs`.
-   **Testabilidade:** Crie testes unitários para seus "flows" de IA, garantindo que a lógica de orquestração funcione como esperado antes de ser consumida pelos agentes.
-   **Portabilidade para a Nuvem:** Um "flow" Genkit que funciona localmente pode ser implantado com poucas modificações no Google Cloud (Cloud Run) ou Firebase Functions, transformando seus agentes em verdadeiras APIs.

---

## 2. Passo a Passo da Implementação

**Localização:** `C:\Projetos\Contexto-Pleno\genkit-orchestrator\`

### Passo 1: Estrutura do Projeto Genkit

Após `genkit init`, a estrutura será:

```
genkit-orchestrator/
├── src/
│   ├── index.ts        # Ponto de entrada, configuração do Genkit e flows
│   └── mcp-tools/      # Nossos plugins customizados para os MCPs
│       ├── tavily.ts
│       ├── memory.ts
│       └── filesystem.ts
├── package.json
└── tsconfig.json
```

### Passo 2: Criar um "Tool" para um MCP (Ex: Filesystem)

O MCP de `filesystem` roda em Docker na porta `6000`. Vamos criar um "tool" para listar arquivos.

```typescript
// src/mcp-tools/filesystem.ts
import { defineTool } from '@genkit-ai/ai';
import { z } from 'zod';
import axios from 'axios';

const MCP_FILESYSTEM_URL = 'http://localhost:6000';

// Define a "action" que o modelo pode chamar
export const listFiles = defineTool(
  {
    name: 'listFiles',
    description: 'Lists files and directories in a given path on the local machine.',
    // Define o formato de entrada que o modelo deve fornecer
    inputSchema: z.object({
      path: z.string().default('.').describe('The directory path to list.'),
    }),
    // Define o formato de saída que a ferramenta retorna
    outputSchema: z.any(), // Idealmente, um schema mais estrito
  },
  // A lógica que executa quando a ferramenta é chamada
  async (input) => {
    try {
      const response = await axios.post(`${MCP_FILESYSTEM_URL}/list`, { path: input.path });
      // O Genkit irá passar este output de volta para o modelo
      return response.data;
    } catch (error) {
      console.error("Filesystem MCP Error:", error);
      return { error: `Failed to connect to Filesystem MCP at ${MCP_FILESYSTEM_URL}` };
    }
  }
);
```

### Passo 3: Registrar o "Tool" e Criar um "Flow"

Agora, usamos essa ferramenta em um "flow" no `index.ts`.

```typescript
// src/index.ts
import { configureGenkit } from '@genkit-ai/core';
import { defineFlow, run } from '@genkit-ai/flow';
import { googleAI } from '@genkit-ai/googleai';
import { z } from 'zod';

// Importa nossa nova ferramenta
import { listFiles } from './mcp-tools/filesystem';

// 1. Configuração do Genkit
export default configureGenkit({
  plugins: [
    // Habilita o modelo Gemini do Google
    googleAI({ apiKey: process.env.GOOGLE_API_KEY }),
  ],
  logLevel: 'debug',
  enableTracingAndMetrics: true, // Essencial para a Dev UI
});

// 2. Definição do "Flow"
export const inspectWorkspace = defineFlow(
  {
    name: 'inspectWorkspace',
    inputSchema: z.string().describe("The user's question about the workspace"),
    outputSchema: z.string().describe("The model's answer"),
  },
  async (userQuestion) => {
    
    // O "run" encapsula a lógica que pode ser visualizada na Dev UI
    const llmResponse = await run("agent-reasoning", async () => {

        // O modelo Gemini agora pode usar a ferramenta 'listFiles'
        const llmResponse = await generate({
            model: 'gemini-1.5-pro-latest',
            prompt: userQuestion,
            tools: [listFiles], // <<< AQUI ESTÁ A MÁGICA
        });

        return llmResponse.text();
    });

    return llmResponse;
  }
);
```

### Passo 4: Executar e Testar

1.  **Iniciar os MCPs Dockerizados:**
    ```powershell
    # No diretório MCPS/Docker
    docker-compose up
    ```

2.  **Iniciar o Servidor Genkit:**
    ```powershell
    # No diretório genkit-orchestrator
    genkit start
    ```
    Isso iniciará a **Dev UI** em `http://localhost:4100` e a API de flows.

3.  **Invocar o "Flow" pela Linha de Comando:**
    ```bash
    genkit flow:run inspectWorkspace '"What files are in the root directory?"'
    ```

4.  **Visualizar na Dev UI:**
    Abra `http://localhost:4100` no navegador. Você verá um traço detalhado da execução:
    - O input do usuário.
    - A chamada para o modelo Gemini.
    - A decisão do modelo de usar a `listFiles` tool.
    - O input e output da chamada para o MCP de `filesystem`.
    - A resposta final do modelo, já com o contexto dos arquivos.

---

## 3. Impacto na Configuração dos Agentes

Com o Genkit no lugar, a configuração de cada agente CLI (`.gemini/settings.json`, etc.) muda drasticamente. Em vez de apontar para cada contêiner Docker individualmente, eles só precisam conhecer a API do Genkit.

**Configuração ANTES (Ex: Gemini):**
```json
{
  "mcpServers": {
    "tavily": { "command": ["docker", "run", "mcp/tavily"] },
    "filesystem": { "command": ["docker", "run", "mcp/filesystem"] }
    // ... para cada MCP
  }
}
```

**Configuração DEPOIS (com um Genkit "Flow Server"):**
```json
{
  "mcpServers": {
    "genkit": {
      "url": "http://localhost:4100/flows/run" // Endpoint único
    }
  }
}
```
Todos os agentes passariam a usar um único MCP (o `genkit`), que por sua vez orquestra todos os outros. Isso **universaliza de fato** o acesso às ferramentas.

Este guia é um ponto de partida. A implementação completa envolveria criar "tools" para todos os MCPs e migrar a lógica dos agentes para "flows" do Genkit.
