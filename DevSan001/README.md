# DevSan001 — AGI POC (Backend-first)

Quick Overview
--
DevSan001 is the initial skeleton of your personal agent (AGI-like) designed to evolve in the Contexto-Pleno workspace.

Immediate Objective
--
- Create living documentation, prompts, and minimal infrastructure for the backend (CLI) that can be iterated by agents and by you.
- Keep everything reproducible on Windows 11 + VS Code Insiders.

How to use this folder
--
1. Read `ARCHITECTURE.md` to understand the proposed components.
2. See `docs/PROMPTS_FOR_AGENTS.md` for the prompts that automate research and updating of this documentation.
3. Check `docs/INCLINACOES.md` for user preferences and browser configurations.
4. Use the example CLI in `src/cli.js` as a starting point for the backend.

Principles
--
- Backend first, minimal CLI, Node modules as MCPs.
- `.env` for secrets (do not commit keys).
- Living documentation: include research results and references in `docs/`.

Suggested next steps (short term)
--
1. Run `npm install` in `DevSan001` and test `node src/cli.js --help`.
2. Use the prompts in `docs/PROMPTS_FOR_AGENTS.md` with a web agent to gather updated references (Dec/2025).
3. Implement the first MCP as a Node module that calls a freemium API (e.g.: Hugging Face / OpenRouter).
4. Test Grok automation: `node scripts/playwright/grok-automate.js "prompt"`. To fully resolve Cloudflare, configure proxy in .env (PROXY_SERVER) or 2CAPTCHA_API_KEY for CAPTCHAs.

Implemented Tools
--
- **Grok Image Generator**: `src/tools/grok-tool.js` — Playwright automation to generate images via Grok.com.
  - Uses stealth plugin, rotating user agents, CAPTCHA detection.
  - Automatic acceptance of cookies and age confirmations.
  - Powerful browser with ad-blocking, cookie management, and bypass extensions.
  - To fully resolve Cloudflare: add PROXY_SERVER (e.g.: http://user:pass@proxy.com:port) or 2CAPTCHA_API_KEY in .env.
  - Command: `node scripts/playwright/grok-automate.js "your prompt" [--headful] [--map]`
  - Setup extensions: Run `scripts/setup-extensions.ps1` as Admin to install required extensions in Edge.

License and authorship
--
Author: you (Deivi). This folder is part of the `Contexto-Pleno` workspace.
