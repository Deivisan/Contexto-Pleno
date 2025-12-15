# 🧠 ESTRATÉGIA SUPREMA: Termux Native Orchestration

**Filosofia:** "Bare Metal Android". Sem Docker, sem VMs pesadas. Apenas Node.js puro, Shell Scripting e IA de ponta conversando entre si.

## 1. O Problema
O setup original (PC) depende de Docker para isolar MCPs. No Termux, Docker é inviável/ineficiente.
A solução é **Native Node MCPs**: Rodar os servidores MCP diretamente como processos Node.js locais, gerenciados pelo Gemini e outros agentes.

## 2. A Arquitetura "Agent Squad" no Termux

Cada "Agente" é, na verdade, uma interface CLI especializada que pode ser invocada por outros agentes via `child_process` ou shell.

| Agente | Implementação Termux | Função | Comando de Invocação |
|---|---|---|---|
| **💎 Gemini (Eu)** | `gemini` (npm package) | Cérebro, Planner, Orquestrador | `gemini "prompt"` |
| **🧠 Qwen** | `qwen` (alias para script python/node) | Coding Pesado, Refatoração | `qwen "code task"` |
| **🧬 Kilocode** | `kilocode` (npm package) | Scaffolding, Estrutura | `kilocode "scaffold"` |
| **✈️ Copilot** | `gh copilot` (Github CLI ext) | Sugestões rápidas, Explain | `gh copilot suggest "..."` |

## 3. Consolidação de MCPs (O "Cinto de Utilidades")

Todos os agentes devem compartilhar a **mesma** configuração de MCPs onde possível, ou ter acesso aos dados uns dos outros (via Filesystem ou Memory).

### Meus MCPs Ativos (Gemini Termux Edition):
1.  **Context7 (`@upstash/context7-mcp`):** Cérebro de documentação. Essencial para não alucinar libs novas.
2.  **Tavily (`tavily-mcp`):** Olhos na web. Pesquisa realtime.
3.  **Memory (`@modelcontextprotocol/server-memory`):** Memória de longo prazo. O "Diário de Bordo" compartilhado.
4.  **Git (`@cyanheads/git-mcp-server`):** Manipulação de código.
5.  **Filesystem (`@modelcontextprotocol/server-filesystem`):** Acesso à "realidade" (arquivos).
6.  **Android (`scripts/android-mcp`):** Mãos no dispositivo. Controle via ADB.

## 4. O Protocolo de Orquestração "YOLO"

Como um agente chama o outro? Simples: **Shell Injection**.

Se eu (Gemini) preciso de um código complexo que o Qwen faz melhor:
1.  Eu gero um prompt detalhado.
2.  Eu uso a tool `run_shell_command`.
3.  Comando: `qwen "Contexto: ... Tarefa: ..."`
4.  Leio a saída.

## 5. Próximos Passos (Iteração)

1.  [ ] **Padronizar Configs:** Garantir que `~/.gemini/settings.json` e futuros configs do Qwen/Kilocode apontem para os mesmos recursos (ex: mesmo arquivo `memory.json`).
2.  [ ] **Criar Aliases de "Ponte":** Scripts em `termux/scripts/bridge/` que facilitam a chamada entre agentes (ex: `ask-qwen.sh`).
3.  [ ] **Treinar a Memória:** Popular o `memory.json` com os caminhos e peculiaridades do Termux.

---
**Assinado:** Gemini v3 (Termux Edition)
