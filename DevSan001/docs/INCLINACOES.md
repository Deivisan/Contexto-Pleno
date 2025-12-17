# Inclinações e Configurações do DevSan

## Navegador Exclusivo
- **Navegador Primário:** Microsoft Edge (único instalado no Windows 11 Pro)
- **Motivo:** Compatibilidade nativa com Windows, integração com Playwright, suporte a extensões Chromium-based.
- **Perfil:** Uso exclusivo para automação Playwright, com contexto persistente para salvar cookies/cache e evitar confirmações repetidas.

## Automação com Playwright
- **Framework:** Playwright com plugin Stealth para bypass de detecções.
- **Modo Padrão:** Headful (visual) para feedback em tempo real, headless para background.
- **User Agents:** Rotativos para simular usuários reais e evitar bloqueios.
- **Proxy:** Suporte opcional via PROXY_SERVER no .env para rotação de IP.
- **CAPTCHA:** Detecção automática e resolução via 2Captcha (API_KEY no .env).

## Funcionalidades Desbloqueadas
- **Aceitação Automática de Cookies:** Script detecta banners e aceita automaticamente.
- **Confirmação de Idade:** Detecta e aceita confirmações de +18 anos automaticamente.
- **Bloqueio de Anúncios:** Extensão uBlock Origin carregada automaticamente.
- **Scripts de Bypass:** Suporte para Tampermonkey/Violentmonkey para funcionalidades avançadas (paywalls, etc.).

## Extensões Recomendadas (Instaladas Automaticamente)
- **uBlock Origin (cjpalhdlnbpafiamejdnhcphjbkeiagm):** Bloqueia anúncios, trackers e malware.
- **Cookie AutoDelete (fhcgjolkccmbidfldomjliifgaodjagh):** Gerencia cookies automaticamente.
- **HTTPS Everywhere (gcbommkclmclpchllfjekcdonpmejbdp):** Força HTTPS para segurança.
- **Violentmonkey (jinjaccalgkegednnccohejagnlnfdag):** Executa userscripts para desbloquear funcionalidades.

## Configuração do Ambiente
- **Perfil Persistente:** EDGE_USER_DATA_DIR no .env aponta para pasta de dados do Edge.
- **Cache Mínimo:** Contexto persistente mantém apenas cookies essenciais e cache necessário.
- **Segurança:** Não armazena senhas ou dados sensíveis; usa .env para segredos.

## Iterações Futuras
- Adicionar mais detecções de confirmações (GDPR, etc.).
- Integrar IA para resolver CAPTCHAs avançados.
- Suporte a múltiplos navegadores se necessário.
- Automação completa de setup de extensões via script PowerShell.

## Comandos Úteis
- Instalar extensão no Edge: Via Microsoft Store ou sideload.
- Limpar cache: `edge://settings/clearBrowserData`
- Ver extensões: `edge://extensions/`

## Limitações e Soluções
- **Ferramentas MCP Chrome Dev Tools**: Bloqueadas pelo Cloudflare em sites como Grok devido à detecção de bot. Use Playwright com stealth plugin para bypass.
- **Bypass Cloudflare**: Use contexto persistente, user agents rotativos, resolução de CAPTCHA via 2Captcha, e emulação de comportamento humano.
- **Navegador Poderoso**: Edge com extensões instaladas manualmente (uBlock, Cookie AutoDelete, etc.) para uso exclusivo em automação.
- **Pesquisa para Consertar MCP**: Técnicas incluem puppeteer-extra-plugin-stealth, user agents rotativos, delays, e resolução automática de CAPTCHA. Para MCP, integrar stealth ou usar Playwright como proxy.

## Técnicas de Bypass Cloudflare Pesquisadas
- **Plugin Stealth**: Usar puppeteer-extra-plugin-stealth para mascarar headless (user-agent, webdriver, etc.). Exemplo: `puppeteer.use(StealthPlugin())`.
- **User Agents Rotativos**: Alternar entre UAs realistas para evitar detecção. Lista de UAs comuns em código.
- **Delays e Comportamento Humano**: Adicionar waits, scrolls, cliques para simular usuário. Ex: `await page.waitForTimeout(1000)`.
- **Resolução CAPTCHA**: Integrar 2Captcha ou similar para resolver Turnstile automaticamente. API_KEY em .env.
- **Proxy e IP Rotativo**: Usar proxies para evitar ban por IP. Config em PROXY_SERVER.
- **Contexto Persistente**: Salvar cookies/sessão entre execuções. Usar launchPersistentContext.
- **Para MCP**: Como ferramentas externas, aplicar emulação (geolocation, network) antes de usar, ou usar Playwright como base e MCP para interações específicas. Ex: Emular Fast 4G e geolocation São Paulo.