# Grok Automation (Playwright) — Notas e uso

Este módulo automatiza a geração de imagens no Grok usando Playwright. Use apenas com sua conta pessoal e entenda os riscos (TOS, CAPTCHAs).

Como usar (instruções rápidas)
1. Copie `.env.example` para `.env` e preencha `GROK_EMAIL` e `GROK_PASSWORD`.
2. Instale dependências:

```bash
cd DevSan001
npm install
```

3. Gerar imagem (modo headless):

```bash
node scripts/playwright/grok-automate.js "Descreva a cena que você quer gerar" --out outputs/minha_imagem.png
```

4. Usar MS Edge com seu perfil (headful, preserva sessão):

```bash
# configure EDGE_USER_DATA_DIR no .env (ex: C:\Users\Deivi\AppData\Local\Microsoft\Edge\User Data\Default)
node scripts/playwright/grok-automate.js "prompt" --headful --out outputs/minha_imagem.png
```

5. Modo de mapeamento (salva snapshots HTML antes/depois em `outputs/map/`):

```bash
node scripts/playwright/grok-automate.js "prompt" --headful --map
```

6. Sessão persistente e interativa (usar seu perfil do Edge e comandos manuais)

```bash
# configure EDGE_USER_DATA_DIR no .env
node scripts/playwright/grok-session.js
```

Comandos disponíveis na sessão:
- `snapshot` — salva DOM atual em `treinamento/grok-session/`.
- `screenshot` — salva screenshot.
- `list-selectors` — lista elementos candidatos ao campo de prompt (truncado).
- `type <texto>` — digita lentamente o texto no elemento focado (ou no primeiro candidato).
- `send` — tenta clicar em botão de envio ou pressionar Enter.
- `exit` — fecha a sessão.

Use essa sessão para contornar verificações (resolvendo CAPTCHAs manualmente) e para mapear seletors com segurança.

Observações
- Se Grok usar proteções anti-bot, o script pode falhar (CAPTCHA).  
- O seletor para campo de prompt é genérico; caso Grok altere o DOM, será necessário ajustar `src/tools/grok-tool.js`.  
- O script salva uma imagem em `DevSan001/outputs/`.

Segurança
- Nunca commit suas credenciais; mantenha no `.env`.  
- Use com moderação para evitar violações de TOS.
