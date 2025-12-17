# DevSan001 — Arquitetura (resumo)

Visão geral
--
Backend-first: um orquestrador Node.js minimal (CLI) que carrega módulos "tools" (MCPs) implementados como pacotes/JS files. Memória persistente em disco e integração com serviços freemium quando necessário.

Componentes mínimos
--
- CLI / Orquestrador (`src/cli.js`): interface para executar fluxos e testar tools.
- Tools (mcp modules): módulos Node que encapsulam chamadas a APIs externas ou wrappers locais de modelos.
- Memória: armazenamento em arquivo + indexador de vetores (integração futura com Chroma/FAISS). Use `.env` para chaves.
- Playwright (opt-in): scripts para automação de Grok quando autorizado.

Fluxo simplificado
--
1. Usuário chama CLI -> 2. Orquestrador seleciona tool -> 3. Recupera contexto/memória -> 4. Chama tool (API/local) -> 5. Persiste resultado.

Requisitos do ambiente (Windows 11)
--
- Node.js v25+ (já presente no seu sistema).  
- PowerShell/WSL2 para rodar ferramentas que precisem de ambiente Linux (ex.: llama.cpp).  
- VS Code Insiders como IDE.

Notas de design
--
- Mantenha cada tool com contrato simples: async function run(input, ctx){ ... }  
- Documente cada tool em `docs/` e inclua prompts para agents que gerem testes automáticos.
