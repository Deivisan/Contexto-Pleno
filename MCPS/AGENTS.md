# Resumo dos Agents CLI (metadata rápida)

Este arquivo foi gerado automaticamente e contém um resumo rápido sobre cada agente CLI instalado/gerenciado neste repositório.

## Gemini CLI (@google/gemini-cli)
- Versão instalada: 0.19.4 (verifique com `gemini --version`)
- URL oficial / docs: https://geminicli.com/docs/ (ou https://github.com/google-gemini/gemini-cli)
- Principais recursos: pesquisa grounding (Google Search), multimodal capabilities, MCP server integration, GitHub integration.
- Autenticação: OAuth (Google) ou API Key; para produção, uso com Vertex AI é suportado.
- Integrar MCPs: configure `~/.gemini/settings.json` com MCP servers; se usar Docker, mapear as portas para `localhost` ou usar `docker network` quando os agentes rodam em containers.

## Qwen CLI (@qwen-code/qwen-code)
- Versão instalada: 0.4.0 (verifique com `qwen --version`)
- URL / docs: https://github.com/QwenLM/qwen-code
- Principais recursos: Code understanding, vision model support, sessions/compression, OAuth login e suporte a OpenAI-compatible APIs.
- Configuração: `.qwen/settings.json` ou variáveis de ambiente para credenciais; suporta-tokens, free tiers e fallback providers.

## Kilocode CLI (@kilocode/cli)
- Versão instalada: 0.14.0 (verifique com `kilocode --version`)
- URL: https://kilo.ai/cli / https://github.com/Kilo-Org/kilocode
- Principais recursos: scaffolding de projetos, autonomous mode, interactive TUI, auto-approval configuration para operações de comando.
- Nota: Melhor suporte no macOS/Linux; no Windows usar WSL para compatibilidade total.

## GitHub Copilot CLI (@githubnext/github-copilot-cli)
- Versão instalada: 0.1.36 (verifique com `github-copilot-cli --version`)
- URL: https://githubnext.com/projects/copilot-cli/
- Principais recursos: Translate natural language to shell/git/gh commands; modes: `??`, `git?`, `gh?`.
- Autenticação: GitHub Copilot account; setup: `github-copilot-cli auth`.

## MCP Servers detectados (Docker)
- Veja `MCPS/Docker/containers.json` e `MCPS/Docker/mcps-list.md` para a lista atual e portas.
- Para integrações MCP: configure os endpoints (ex.: `TAVILY_URL`, `CONTEXT7_URL`, `MEMORY_URL`) usando o `scripts/apply-mcp-env.ps1` para persistência no Windows.

### Notas gerais
- Recomendo manter Node >= 25 para compatibilidade e performance com as CLIs mais novas.
- Se você quiser que os MCPs sejam acessíveis via `localhost`, exponha as portas dos containers com `-p hostPort:containerPort` ou configure um proxy reverso.
- Rodar os agentes via WSL/containers facilita a comunicação com os MCPs na mesma rede Docker.
