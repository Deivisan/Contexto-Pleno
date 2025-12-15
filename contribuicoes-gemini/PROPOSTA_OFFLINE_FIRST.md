# 💡 Proposta Disruptiva: Arquitetura "Offline-First" com Orquestração Local

**Autor:** Gemini (Nano Banana)  
**Data:** 2025-12-09  
**Assunto:** Evoluir o "Contexto-Pleno" para um ecossistema de IA 100% local, gratuito e centrado em privacidade, usando modelos open-source (Ollama) e um novo MCP Orquestrador.

---

## 1. A Crítica e a Nova Visão

A proposta anterior, embora funcional, dependia de uma premissa incorreta: a disponibilidade de chaves de API para serviços pagos como o `googleAI`. A verdadeira inovação está em alcançar a "universalização dos agentes" com **autonomia, privacidade e zero custo**.

**Nova Visão:** Transformar o "Contexto-Pleno" em uma plataforma onde qualquer agente pode acessar um cérebro de orquestração local (rodando um modelo open-source) que, por sua vez, comanda a suíte de ferramentas MCPs já existente.

---

## 2. Arquitetura "Offline-First" com Ollama

**Ollama** é a peça-chave que faltava. É um serviço que permite executar modelos de linguagem open-source (como Llama 3, Phi-3, Mistral) diretamente na sua máquina (ou em um contêiner Docker). O Genkit possui um plugin nativo para Ollama, o que torna a integração trivial.

### 2.1. Adicionando o Cérebro ao Docker Compose

Vamos adicionar o Ollama ao `docker-compose.yml`. Para permitir que ele use a aceleração de GPU do seu PC, usamos a configuração `deploy.resources`.

**Trecho para `MCPS/Docker/docker-compose.yml`:**

```yaml
services:
  # ... (serviços MCP existentes como tavily, memory, etc.)

  ollama:
    image: ollama/ollama:latest
    container_name: mcp-ollama-server
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ./ollama_data:/root/.ollama
    networks:
      - mcp_network
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    healthcheck:
      test: ["CMD", "ollama", "ps"]
      interval: 30s
      timeout: 10s
      retries: 5
```

**O que isso faz?**
-   Cria um serviço `ollama` acessível na porta `11434`.
-   Mapeia um volume `ollama_data` para persistir os modelos baixados.
-   **Tenta** alocar a GPU NVIDIA para aceleração. Se você não tiver uma GPU NVIDIA, o Docker simplesmente ignora essa seção e usa a CPU. É seguro e adaptável.

### 2.2. Genkit com Orquestração Local

Agora, a configuração do Genkit no `genkit-orchestrator` se torna 100% independente de APIs externas.

**Arquivo `genkit-orchestrator/src/index.ts` revisado:**

```typescript
import { configureGenkit } from '@genkit-ai/core';
import { defineFlow, run } from '@genkit-ai/flow';
import { z } from 'zod';

// 1. Importe o plugin do Ollama em vez do GoogleAI
import { ollama } from 'genkitx-ollama';
import { listFiles } from './mcp-tools/filesystem'; // Ferramenta que já criamos

// 2. Configure o Genkit para usar Ollama
export default configureGenkit({
  plugins: [
    ollama({
      models: [
        {
          name: 'llama3', // Modelo que você pode baixar com `docker exec mcp-ollama-server ollama pull llama3`
          type: 'generate',
        },
      ],
      serverAddress: 'http://localhost:11434', // Aponta para nosso contêiner Docker
    }),
  ],
  logLevel: 'info',
  enableTracingAndMetrics: true,
});

// 3. O "Flow" agora usa o modelo local
export const localWorkspaceAgent = defineFlow(
  {
    name: 'localWorkspaceAgent',
    inputSchema: z.string(),
    outputSchema: z.string(),
  },
  async (userQuestion) => {
    const llmResponse = await run("local-reasoning", async () => {
      return await generate({
        model: 'ollama/llama3', // Note o prefixo 'ollama/'
        prompt: `You are a helpful assistant. The user asks: ${userQuestion}. You have access to tools.`,
        tools: [listFiles], // O modelo local decidirá quando usar esta ferramenta
      });
    });

    return llmResponse.text();
  }
);
```
**Resultado:** Criamos um "flow" de IA que usa um modelo rodando **inteiramente dentro do seu Docker**, sem custos e com total privacidade.

---

## 3. Proposta Criativa: O "Agent-Executor" MCP

E se pudéssemos criar um ciclo de raciocínio? Um agente que pensa, age, observa o resultado e pensa de novo? Proponho um novo MCP que faz exatamente isso.

**Nome:** `agent-executor`
**Porta:** `10000`
**Função:** Receber um objetivo complexo (e.g., "analise o projeto e crie um novo script de teste"), e orquestrar os **outros MCPs** para cumpri-lo.

### 3.1. Como Funciona?

1.  O `agent-executor` recebe um objetivo via POST: `curl -X POST http://localhost:10000/execute -d '{"goal": "list all .md files in the docs folder"}'`.
2.  Internamente, ele usa o **Ollama** para gerar um plano de ação em formato JSON. Ex:
    ```json
    {
      "tool": "filesystem",
      "action": "list",
      "params": { "path": "./docs" }
    }
    ```
3.  Ele executa a ação chamando o MCP correspondente (ex: `http://localhost:6000/list`).
4.  Ele recebe o resultado, o envia de volta para o Ollama para análise e decide o próximo passo, até que o objetivo seja concluído.

### 3.2. Implementação do `agent-executor`

Pode ser um simples servidor em Python (com Flask/FastAPI) ou Node.js (com Express).

**Exemplo em Python com FastAPI:**

```python
# agent-executor/main.py
from fastapi import FastAPI
import httpx
import json

app = FastAPI()
OLLAMA_URL = "http://mcp-ollama-server:11434/api/generate" # Comunicação interna do Docker
FILESYSTEM_MCP_URL = "http://mcp-filesystem:6000"

@app.post("/execute")
async def execute_goal(goal: dict):
    prompt = f"Based on the goal '{goal['goal']}', what is the next single tool call to make? Respond in JSON. Available tools: filesystem.list(path)."
    
    # 1. Usar Ollama para decidir a ação
    response = httpx.post(OLLAMA_URL, json={"model": "llama3", "prompt": prompt, "format": "json"})
    action_json = json.loads(response.json()['response']) # Ex: {"tool": "filesystem", "action": "list", ...}

    # 2. Executar a ação no MCP correspondente
    if action_json['tool'] == 'filesystem' and action_json['action'] == 'list':
        fs_response = httpx.post(f"{FILESYSTEM_MCP_URL}/list", json=action_json['params'])
        # ... lógica para continuar o ciclo ...
        return fs_response.json()

    return {"error": "Could not determine action"}
```
Este novo MCP seria adicionado ao `docker-compose.yml`, criando um poderoso "agente autônomo" dentro do seu ecossistema local.

---

## 4. Próximos Passos (Funcionais e Gratuitos)

1.  **Modificar `docker-compose.yml`:** Adicionar o serviço `ollama` como descrito acima.
2.  **Iniciar e Baixar um Modelo:**
    ```powershell
    # Em MCPS/Docker
    docker-compose up -d ollama
    docker exec mcp-ollama-server ollama pull llama3
    ```
3.  **Implementar o "Flow" Local:** Criar a estrutura `genkit-orchestrator` e o `index.ts` para usar o `ollama` plugin, provando o conceito da orquestração gratuita.
4.  **(Opcional, mas poderoso) Criar o `agent-executor` MCP:** Desenvolver o servidor (Python ou Node) e adicioná-lo ao `docker-compose.yml`.

Esta abordagem atinge o objetivo original de forma mais robusta, criativa e alinhada com os princípios de software open-source, autonomia e gratuidade.