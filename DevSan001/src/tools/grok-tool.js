const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');
dotenv.config();
const { chromium } = require('playwright-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
chromium.use(StealthPlugin());
const TwoCaptcha = require('2captcha');

const GROK_URL = process.env.GROK_URL || 'https://grok.com';
const GROK_EMAIL = process.env.GROK_EMAIL;
const GROK_PASSWORD = process.env.GROK_PASSWORD;
const EDGE_USER_DATA_DIR = process.env.EDGE_USER_DATA_DIR;
const BROWSER = (process.env.BROWSER || 'msedge').toLowerCase();
const DEFAULT_CLICK_DELAY = 500; // aumentado para simular humano
const DEFAULT_CLICK_RETRIES = 6; // aumentado
const CAPTCHA_SOLVER_API_KEY = process.env.CAPTCHA_SOLVER_API_KEY || process.env['2CAPTCHA_API_KEY'];
const PROXY_SERVER = process.env.PROXY_SERVER;

// Lista de user agents realistas para rotacionar
const USER_AGENTS = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
];

function getRandomUserAgent() {
  return USER_AGENTS[Math.floor(Math.random() * USER_AGENTS.length)];
}

async function detectCaptcha(page) {
  try {
    // Procurar por elementos do Cloudflare Turnstile
    const turnstile = await page.$('[class*="cf-turnstile"]') || await page.$('[data-sitekey]');
    if (turnstile) return true;
    // Procurar por texto comum de CAPTCHA
    const captchaText = await page.$('text=/captcha|verification|robot|human/i');
    if (captchaText) return true;
    return false;
  } catch (e) {
    return false;
  }
}

async function solveCaptcha(page) {
  if (!CAPTCHA_SOLVER_API_KEY) {
    console.log('CAPTCHA detectado, mas sem API_KEY para resolver. Aguardando manualmente...');
    return false;
  }
  try {
    const solver = new TwoCaptcha(CAPTCHA_SOLVER_API_KEY);
    const sitekey = await page.$eval('[data-sitekey]', el => el.getAttribute('data-sitekey'));
    if (!sitekey) throw new Error('Sitekey não encontrado');
    const result = await solver.turnstile({
      sitekey,
      url: page.url(),
      action: 'submit'
    });
    // Inserir token no campo oculto
    await page.evaluate((token) => {
      const input = document.querySelector('input[name="cf-turnstile-response"]');
      if (input) input.value = token;
    }, result.data);
    console.log('CAPTCHA resolvido automaticamente via 2Captcha');
    return true;
  } catch (e) {
    console.warn('Falha ao resolver CAPTCHA:', e.message);
    return false;
  }
}

async function acceptAgeConfirmation(page) {
  try {
    // Procurar por texto relacionado a idade
    const ageSelectors = [
      'button:has-text("Yes")',
      'button:has-text("I\'m over 18")',
      'button:has-text("Confirm")',
      'button:has-text("Accept")',
      'button:has-text("Continue")',
      'button:has-text("Enter")',
      'a:has-text("Yes")',
      'a:has-text("Confirm")'
    ];
    for (const selector of ageSelectors) {
      const buttons = await page.$$(selector);
      for (const btn of buttons) {
        const text = await btn.innerText();
        if (text && (text.toLowerCase().includes('18') || text.toLowerCase().includes('age') || text.toLowerCase().includes('adult') || text.toLowerCase().includes('yes') || text.toLowerCase().includes('confirm'))) {
          await btn.click();
          console.log('Confirmação de idade aceita automaticamente:', text);
          await page.waitForTimeout(1000);
          return true;
        }
      }
    }
    // Verificar se há modal ou popup com texto de idade
    const modal = await page.$('[role="dialog"], .modal, .popup, .overlay');
    if (modal) {
      const modalText = await modal.innerText();
      if (modalText && (modalText.includes('18') || modalText.toLowerCase().includes('age'))) {
        const confirmBtn = await modal.$('button:has-text("Yes"), button:has-text("Confirm"), button:has-text("Accept"), button:has-text("Continue")');
        if (confirmBtn) {
          await confirmBtn.click();
          console.log('Confirmação de idade em modal aceita.');
          await page.waitForTimeout(1000);
          return true;
        }
      }
    }
    // Procurar por qualquer elemento com texto "18" ou "age"
    const ageElements = await page.$$('text=/18|age|adult/i');
    for (const el of ageElements) {
      const parent = await el.$('xpath=ancestor-or-self::*[self::button or self::a]');
      if (parent) {
        await parent.click();
        console.log('Elemento de idade clicado automaticamente.');
        await page.waitForTimeout(1000);
        return true;
      }
    }
    return false;
  } catch (e) {
    console.warn('Erro ao aceitar confirmação de idade:', e.message);
    return false;
  }
}

async function acceptCookies(page) {
  try {
    // Detectar banners de cookies e aceitar
    const cookieButtons = await page.$$('button:has-text("Accept"), button:has-text("Agree"), button:has-text("OK"), button:has-text("Allow")');
    for (const btn of cookieButtons) {
      const text = await btn.innerText();
      if (text.toLowerCase().includes('accept') || text.toLowerCase().includes('agree') || text.toLowerCase().includes('ok')) {
        await btn.click();
        console.log('Cookies aceitos automaticamente.');
        await page.waitForTimeout(500);
        return true;
      }
    }
    return false;
  } catch (e) {
    console.warn('Erro ao aceitar cookies:', e.message);
    return false;
  }
}

// Tentativas mais agressivas para fechar overlays, se houver iframes ou shadow DOM
async function dismissOverlays(page) {
  try {
    await page.evaluate(() => {
      const patterns = /18|age|adult|over 18|i\'m over|confirm|continue|enter|yes|accept|allow|proceed/ig;
      const clickables = Array.from(document.querySelectorAll('button, a, [role="button"], input[type="button"], input[type="submit"]'));
      for (const el of clickables) {
        const text = (el.innerText || el.value || '').trim();
        if (text && patterns.test(text)) {
          try { el.click(); } catch (e) { /* ignore */ }
        }
      }
      // click elements with common attributes
      const attrs = ['data-accept','data-confirm','data-yes'];
      for (const a of attrs) {
        const sel = document.querySelector('[' + a + ']');
        if (sel) try { sel.click(); } catch (e) {}
      }
      return true;
    }).catch(()=>{});

    // If there are frames, try inside them too
    const frames = page.frames();
    for (const frame of frames) {
      try {
        await frame.evaluate(() => {
          const patterns = /18|age|adult|over 18|i\'m over|confirm|continue|enter|yes|accept|allow|proceed/ig;
          const clickables = Array.from(document.querySelectorAll('button, a, [role="button"], input[type="button"], input[type="submit"]'));
          for (const el of clickables) {
            const text = (el.innerText || el.value || '').trim();
            if (text && patterns.test(text)) {
              try { el.click(); } catch (e) { /* ignore */ }
            }
          }
          return true;
        }).catch(()=>{});
      } catch(e) { /* ignore frame errors */ }
    }

    // Try basic keyboard presses to dismiss overlays
    await page.keyboard.press('Enter').catch(()=>{});
    await page.keyboard.press('Escape').catch(()=>{});
    await page.keyboard.press('Space').catch(()=>{});
    return true;
  } catch (e) {
    return false;
  }
}

function startOverlayWatcher(page, interval = 1500) {
  let stopped = false;
  const handle = setInterval(async () => {
    if (stopped) return;
    try {
      await acceptCookies(page).catch(()=>{});
      await acceptAgeConfirmation(page).catch(()=>{});
      await dismissOverlays(page).catch(()=>{});
      await handleNewChatPrompt(page).catch(()=>{});
    } catch (e) {}
  }, interval);
  return () => { stopped = true; clearInterval(handle); };
}

// Map the page: save HTML snapshot and a JSON list of clickable elements (buttons/links) to disk
async function mapPage(page, tag = 'map') {
  try {
    const outDir = path.join(process.cwd(), 'DevSan001', 'outputs', 'map');
    fs.mkdirSync(outDir, { recursive: true });
    const ts = Date.now();
    const html = await page.content();
    const htmlPath = path.join(outDir, `${tag}_snapshot_${ts}.html`);
    fs.writeFileSync(htmlPath, html, 'utf8');

    const list = await page.evaluate(() => {
      const nodes = Array.from(document.querySelectorAll('button, a, [role="button"], input[type="button"], input[type="submit"], [aria-label], [data-testid]'));
      return nodes.slice(0,200).map(n => {
        return {
          tag: n.tagName,
          text: (n.innerText || n.value || '').trim().replace(/\s+/g,' '),
          ariaLabel: n.getAttribute && n.getAttribute('aria-label'),
          testid: n.getAttribute && n.getAttribute('data-testid'),
          id: n.id || null,
          classes: n.className || null,
          href: n.href || null
        };
      });
    });

    const jsonPath = path.join(outDir, `${tag}_elements_${ts}.json`);
    fs.writeFileSync(jsonPath, JSON.stringify(list, null, 2), 'utf8');
    console.log('Saved page map:', htmlPath, jsonPath);
    return { htmlPath, jsonPath };
  } catch (e) {
    console.warn('mapPage failed:', e.message);
    return null;
  }
}

// Try to detect and dismiss a 'start new chat' modal or similar prompts
async function handleNewChatPrompt(page) {
  try {
    // common textual patterns for 'new chat' overlays
    const patterns = [/new chat/i, /start (a )?new chat/i, /start chat/i, /begin (a )?conversation/i, /continue conversation/i, /start now/i];
    // look for elements with these texts and click the close or no/skip buttons nearby
    const candidates = await page.$$('button, a, [role="button"], div');
    for (const el of candidates) {
      try {
        const text = (await el.innerText() || '').trim();
        if (!text) continue;
        for (const p of patterns) {
          if (p.test(text)) {
            console.log('Detected new-chat element with text:', text.slice(0,80));
            // try to click it to proceed or click a nearby close
            try { await el.click(); await page.waitForTimeout(500); } catch(e){}
            // try to find a close button near it
            const closeBtn = await page.$('button[aria-label="Close"], button:has-text("Close"), button:has-text("No"), button:has-text("Not now"), button:has-text("Skip")');
            if (closeBtn) { try { await closeBtn.click(); console.log('Clicked close for new-chat overlay'); await page.waitForTimeout(300); } catch(e){} }
            return true;
          }
        }
      } catch(e) { /* ignore */ }
    }
    // fallback: try generic close icons
    const genericClose = await page.$('button[aria-label="Close"], .close, .modal-close, button:has-text("Close"), button:has-text("X")');
    if (genericClose) { try { await genericClose.click(); console.log('Clicked generic close for modal'); await page.waitForTimeout(300); return true; } catch(e){} }
    return false;
  } catch (e) {
    return false;
  }
}

async function loginIfNeeded(page){
  // Tenta detectar elementos de login de forma tolerante
  try{
    if(page.isClosed && page.isClosed()) throw new Error('Página foi fechada — mantenha o navegador aberto durante a interação.');
    // Se houver botão 'Log in' ou 'Sign in'
    const loginBtn = await page.$("text=/login|sign in|sign-in/i");
    if(loginBtn){
      await loginBtn.click();
      await page.waitForTimeout(1000);
    }

    // Preencher formulários se visíveis
    const emailSel = await page.$('input[type="email"]') || await page.$('input[name="email"]');
    const passSel = await page.$('input[type="password"]') || await page.$('input[name="password"]');
    if(emailSel && passSel && GROK_EMAIL && GROK_PASSWORD){
      await emailSel.fill(GROK_EMAIL);
      await passSel.fill(GROK_PASSWORD);
      await Promise.all([
        page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(()=>{}),
        passSel.press('Enter')
      ]);
      await page.waitForTimeout(1000);
    }
  }catch(e){
    console.warn('Login step warning:', e.message);
  }
}

async function submitPromptAndCapture(page, prompt, outPath, options = {}, browser = null){
  // options.expectedImages (default 2), options.timeout
  options.expectedImages = Number(options.expectedImages || 2);
  options.timeout = Number(options.timeout || 180000);

  // Tentativa genérica: encontrar textarea/entrada e enviar prompt
  if(page.isClosed && page.isClosed()) throw new Error('Página foi fechada — mantenha o navegador aberto durante a interação.');
  // Esperar por elementos específicos do Grok carregar
  await page.waitForSelector('textarea, input[placeholder*="Ask"], div[contenteditable="true"], [role="textbox"]', { timeout: 15000 }).catch(() => {});
  
  // seletores comuns
  let textarea = await page.$('textarea')
    || await page.$('input[role="textbox"]')
    || await page.$('input[type="text"]')
    || await page.$('[contenteditable="true"]')
    || await page.$('div[role="textbox"]')
    || await page.$('div[contenteditable="true"]');
  if(!textarea) {
    // tentar encontrar um elemento contenteditable dinamicamente
    const editables = await page.$$('[contenteditable="true"], div[role="textbox"], [role="textbox"]');
    if(editables && editables.length) textarea = editables[0];
  }
  if(!textarea) throw new Error('Não encontrou campo de prompt automaticamente — ajuste seletor.');

  // Se o usuário quer múltiplas imagens, acrescente instrução ao prompt
  let fullPrompt = prompt;
  if (options.expectedImages > 1 && !/variation|variations|várias|variantes/i.test(prompt)) {
    fullPrompt = `${prompt} Generate ${options.expectedImages} variations of the image.`;
  }

  await textarea.click({ timeout: 5000 }).catch(()=>{});
  try{
    // prefer fill when disponível
    await textarea.fill ? await textarea.fill(fullPrompt) : await page.keyboard.type(fullPrompt, { delay: 10 });
  }catch(e){
    // fallback typing
    await page.keyboard.type(fullPrompt, { delay: 10 }).catch(()=>{});
  }

  logDebug(options, 'Prompt sent:', fullPrompt);

  // Iniciar watcher para tentar remover banners/iframes/overlays enquanto enviamos o prompt
  const stopWatcher = startOverlayWatcher(page, options?.watcherInterval || 1500);

  // Capture images via network responses as well (robust for images loaded via XHR or asset URLs)
  const capturedImages = [];
  const onResponse = async (resp) => {
    try{
      const url = resp.url();
      const status = resp.status();
      if (status !== 200) return;
      const ct = (resp.headers && (resp.headers()['content-type'] || resp.headers()['Content-Type'] || '') + '').toLowerCase();
      if (ct.startsWith('image/') || /\.(png|jpe?g|webp)(\?|$)/i.test(url) || url.includes('grokusercontent') || url.includes('/backgrounds/')){
        const buf = await resp.body().catch(()=>null);
        if (buf && buf.length > 2000 && !capturedImages.some(i => i.url === url)) {
          capturedImages.push({ url, buf });
          logDebug(options, 'captured image via network:', url, 'size', buf.length);
        }
      }
    }catch(e){ logDebug(options, 'onResponse error', e.message); }
  };
  page.context().on('response', onResponse);

  try {
    // Enviar: tentar botão de enviar ou Enter
    const sendBtn = await page.$('button:has-text("Send")') || await page.$('button:has-text("Generate")') || await page.$('button[type="submit"]');
    // helper: click with retries
    async function clickWithRetries(handle, retries = DEFAULT_CLICK_RETRIES, delay = DEFAULT_CLICK_DELAY){
      for(let i=0;i<retries;i++){
        try{
          if(!handle) throw new Error('Handle null');
          await handle.scrollIntoViewIfNeeded().catch(()=>{});
          await handle.click({ timeout: 5000 }).catch(()=>{});
          return true;
        }catch(e){
          await page.waitForTimeout(delay);
        }
      }
      return false;
    }

    if(sendBtn){
      // try clicking and also wait for a network response hint
      const clicked = await clickWithRetries(sendBtn, options?.clickRetries || DEFAULT_CLICK_RETRIES, options?.clickDelay || DEFAULT_CLICK_DELAY);
      if(clicked){
        try{ await page.waitForResponse(r => r.status() === 200, { timeout: 20000 }).catch(()=>{}); }catch(e){}
      }
    } else {
      // press enter with retries
      const retries = options?.clickRetries || DEFAULT_CLICK_RETRIES;
      for(let i=0;i<retries;i++){
        await textarea.press('Enter').catch(()=>{});
        await page.waitForTimeout(options?.clickDelay || DEFAULT_CLICK_DELAY);
      }
    }

    // If interactive pause requested by user, pause for DevTools; otherwise proceed automatically
    if (options.pauseAfterSubmit) {
      console.log('\n>>> Prompt enviado. Pausado para interação manual ou DevTools.');
      console.log('>>> Navegador mantido aberto. Use DevTools para continuar.');
      if (browser && browser.process) {
        console.log('PID do navegador:', browser.process.pid);
        try {
          const wsEndpoint = await getWsEndpoint(9222);
          console.log('WebSocket Endpoint para MCP Chrome DevTools:', wsEndpoint);
          console.log('Configure seu cliente MCP com: --wsEndpoint=' + wsEndpoint);
        } catch (e) {
          console.warn('Erro ao obter wsEndpoint:', e.message);
        }
      }
      // save a map snapshot while paused for inspection
      try { await mapPage(page, 'pause'); } catch(e){}
      console.log('>>> Pausando para interação manual.');
    }

    // Esperar resultado: buscar N imagens dentro do timeout, procurando por imagens válidas (img/canvas/background)
    console.log('Aguardando geração da(s) imagem(ns) pelo Grok... (esperando', options.expectedImages, 'imagens)');
    const foundImages = [];
    try{
      const start = Date.now();
      while ((Date.now() - start) < options.timeout) {
        // run overlay dismisses while waiting
        await acceptCookies(page).catch(()=>{});
        await acceptAgeConfirmation(page).catch(()=>{});
        await dismissOverlays(page).catch(()=>{});

        // scan all pages in the context (robust to popups/navigation)
        const pages = page.context().pages();
        for (const p of pages) {
          try {
            const imgs = await p.evaluate(() => {
              const out = [];
              // img elements (include data URIs and require reasonable size to avoid icons)
              Array.from(document.querySelectorAll('img')).forEach(img => {
                try{ if (img.src && img.offsetWidth>=32 && img.offsetHeight>=32) out.push(img.src); }catch(e){}
              });
              // canvas -> dataURL
              Array.from(document.querySelectorAll('canvas')).forEach(c => {
                try{ if (c.width>0 && c.height>0 && c.toDataURL) out.push(c.toDataURL('image/png')); }catch(e){}
              });
              // background images
              Array.from(document.querySelectorAll('*')).forEach(el => {
                try{
                  const bg = window.getComputedStyle(el).backgroundImage || '';
                  const m = bg.match(/url\((['"]?)(.*?)\1\)/);
                  if (m && m[2]) out.push(m[2]);
                }catch(e){}
              });
              return Array.from(new Set(out));
            }).catch(()=>[]);

            for (const i of imgs) {
              if (!foundImages.includes(i)) foundImages.push(i);
            }

            // try frames inside this page too
            for (const f of p.frames()){
              try{
                const frameImgs = await f.evaluate(() => {
                  const out = [];
                  Array.from(document.querySelectorAll('img')).forEach(img => { try{ if (img.src && img.offsetWidth>=32 && img.offsetHeight>=32) out.push(img.src);}catch(e){} });
                  Array.from(document.querySelectorAll('canvas')).forEach(c =>{ try{ if (c.width>0 && c.height>0 && c.toDataURL) out.push(c.toDataURL('image/png')); }catch(e){} });
                  return Array.from(new Set(out));
                }).catch(()=>[]);
                for (const i of frameImgs) if (!foundImages.includes(i)) foundImages.push(i);
              }catch(e){}
            }

            if (foundImages.length >= options.expectedImages) break;
          } catch(e){
            // if a page is closed, ignore and continue with others
            logDebug(options, 'page scan error (ignored):', e.message);
            continue;
          }
        }

        logDebug(options, 'foundImages count', foundImages.length);
        if (foundImages.length >= options.expectedImages) break;
        await page.waitForTimeout(1000);
      }
    }catch(e){
      console.warn('Erro while waiting for images:', e.message);
    }

    if (foundImages.length === 0) {
      console.warn('Nenhuma imagem válida encontrada automaticamente — farei screenshot da página.');
      fs.mkdirSync(path.dirname(outPath), { recursive: true });
      await page.screenshot({ path: outPath, fullPage: false });
      return { saved: outPath, method: 'screenshot' };
    }

    // salvar todas as imagens encontradas até expectedImages
    const results = [];
    let idx = 1;
    for (const src of foundImages.slice(0, options.expectedImages)){
      if (src && src.startsWith('data:')){
        const comma = src.indexOf(',');
        const meta = src.substring(5, comma);
        const isBase64 = meta.endsWith(';base64');
        const data = src.substring(comma + 1);
        const buf = isBase64 ? Buffer.from(data, 'base64') : Buffer.from(decodeURIComponent(data), 'utf8');
        const savePath = outPath.replace(/(\.png|\.jpg|\.jpeg|\.webp)?$/i, `_${idx}.png`);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        fs.writeFileSync(savePath, buf);
        results.push({ saved: savePath, method: 'datauri' });
      } else if (src) {
        // download via fetch
        const view = await page.context().newPage();
        let imgUrl = src;
        try{ imgUrl = new URL(src, GROK_URL).href; }catch(e){}
        try{
          logDebug(options, 'attempting fetch for', imgUrl);
          const imgData = await page.evaluate(async (url) => {
            try {
              const response = await fetch(url, {
                headers: {
                  'User-Agent': navigator.userAgent,
                  'Referer': window.location.href,
                  'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8'
                }
              });
              if (!response.ok) throw new Error('Fetch failed ' + response.status);
              const blob = await response.blob();
              return new Promise((resolve) => {
                const reader = new FileReader();
                reader.onload = () => resolve(reader.result);
                reader.readAsDataURL(blob);
              });
            } catch (e) {
              return null;
            }
          }, imgUrl);
          if (imgData && imgData.startsWith('data:image/')){
            const comma = imgData.indexOf(',');
            const data = imgData.substring(comma + 1);
            const buf = Buffer.from(data, 'base64');
            const savePath = outPath.replace(/(\.png|\.jpg|\.jpeg|\.webp)?$/i, `_${idx}.png`);
            fs.mkdirSync(path.dirname(savePath), { recursive: true });
            fs.writeFileSync(savePath, buf);
            results.push({ saved: savePath, method: 'fetch' });
          } else {
            // fallback: try to use view.goto and buffer
            await view.goto(imgUrl, { waitUntil: 'networkidle', timeout: 15000 }).catch(()=>{});
            const buffer = await view.screenshot({ type: 'png' }).catch(()=>null);
            if (buffer) {
              const savePath = outPath.replace(/(\.png|\.jpg|\.jpeg|\.webp)?$/i, `_${idx}.png`);
              fs.mkdirSync(path.dirname(savePath), { recursive: true });
              fs.writeFileSync(savePath, buffer);
              results.push({ saved: savePath, method: 'screenshot-fallback' });
            }
          }
        }catch(e){
          console.warn('Erro ao baixar imagem:', e.message);
        }finally{
          try{ await view.close(); }catch(e){}
        }
      }
      idx++;
    }

    // If we didn't get enough via DOM, use captured network images as fallback
    if (results.length < options.expectedImages && capturedImages.length > 0){
      logDebug(options, 'using network-captured images as fallback', capturedImages.length);
      for (const cap of capturedImages.slice(0, options.expectedImages - results.length)){
        const savePath = outPath.replace(/(\.png|\.jpg|\.jpeg|\.webp)?$/i, `_${idx}.png`);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        fs.writeFileSync(savePath, cap.buf);
        results.push({ saved: savePath, method: 'network' });
        idx++;
      }
    }

    return results.length === 1 ? results[0] : results;
  } finally {
    try { if (stopWatcher) stopWatcher(); } catch (e) {}
    try { page.context().off && page.context().off('response', onResponse); } catch(e){}
  }
}

const https = require('https');

function logDebug(options, ...args){
  const enabled = options && (options.debug || process.env.DEBUG === '1' || process.env.DEBUG === 'true');
  if(enabled) console.log('[DEBUG]', ...args);
}


async function getWsEndpoint(port = 9222) {
  return new Promise((resolve, reject) => {
    const req = https.get(`https://localhost:${port}/json/version`, { rejectUnauthorized: false }, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          resolve(json.webSocketDebuggerUrl);
        } catch (e) {
          reject(e);
        }
      });
    });
    req.on('error', reject);
    req.setTimeout(5000, () => reject(new Error('Timeout')));
  });
}

async function generateImage(prompt, options = {}){
  const outPath = options.outPath || path.join(process.cwd(), 'DevSan001', 'outputs', `grok_${Date.now()}.png`);
  const headless = options.headless !== undefined ? options.headless : false; // headful por padrão
  const interactiveMap = options.map || false;
  const keepOpen = options.keepOpen || false; // nova opção para manter navegador aberto
  let browser = null;
  let context = null;

  // Args para extensões e configurações poderosas
  const browserArgs = [
    '--no-sandbox',
    '--disable-web-security',
    '--disable-features=VizDisplayCompositor',
    // '--load-extension=' + EXTENSIONS.join(','),
    '--allow-running-insecure-content',
    // '--disable-extensions-except=' + EXTENSIONS.join(','),
    '--disable-background-timer-throttling',
    '--disable-renderer-backgrounding',
    '--disable-backgrounding-occluded-windows',
    '--remote-debugging-port=9222'  // Para conectar MCP Chrome DevTools
  ];

  // If EDGE_USER_DATA_DIR is provided and using msedge, launch persistent context
  if((BROWSER === 'msedge' || BROWSER === 'edge') && EDGE_USER_DATA_DIR){
    console.log('Launching persistent MS Edge context with user data dir:', EDGE_USER_DATA_DIR);
    const contextOptions = { 
      channel: 'msedge', 
      headless, 
      args: browserArgs,
      userAgent: getRandomUserAgent()
    };
    if (PROXY_SERVER) {
      contextOptions.proxy = { server: PROXY_SERVER };
    }
    context = await chromium.launchPersistentContext(EDGE_USER_DATA_DIR, contextOptions);
    browser = context.browser(); // Obter browser do context
    const pages = context.pages();
    const page = pages.length ? pages[0] : await context.newPage();
    logDebug(options, 'launched persistent edge, PID', browser.process && browser.process.pid);
    const res = await runFlowOnPage(page, prompt, outPath, interactiveMap, context, options, browser);
    logDebug(options, 'runFlowOnPage finished for persistent edge');
    return res;
  }

  try{
    const contextOptions = { userAgent: getRandomUserAgent(), args: browserArgs };
    if (PROXY_SERVER) {
      contextOptions.proxy = { server: PROXY_SERVER };
    }
    console.log('Launching browser...');
    browser = await chromium.launch({ headless, args: browserArgs });
    logDebug(options, 'browser launched, PID', browser.process && browser.process.pid);
    context = await browser.newContext(contextOptions);
    const page = await context.newPage();
    const res = await runFlowOnPage(page, prompt, outPath, interactiveMap, context, options, browser);
    if (!keepOpen) {
      logDebug(options, 'closing browser (normal flow)');
      await browser.close();
      logDebug(options, 'browser closed');
    } else {
      console.log('Navegador mantido aberto. Feche manualmente quando terminar.');
      if (browser && browser.process) {
        console.log('PID do navegador:', browser.process.pid);
        try {
          const wsEndpoint = await getWsEndpoint(9222);
          console.log('WebSocket Endpoint para MCP Chrome DevTools:', wsEndpoint);
          console.log('Configure seu cliente MCP com: --wsEndpoint=' + wsEndpoint);
        } catch (e) {
          console.warn('Erro ao obter wsEndpoint:', e.message);
        }
      }
    }
    return res;
  }catch(err){
    try{ if(browser) { logDebug(options, 'error, closing browser'); await browser.close(); } }catch(e){}
    throw err;
  }
}

async function runFlowOnPage(page, prompt, outPath, interactiveMap, context, options = {}, browser = null){
  try{
    await page.goto(GROK_URL, { waitUntil: 'domcontentloaded', timeout: 30000 });
    
    // Aceitar confirmações automaticamente
    await acceptCookies(page);
    await acceptAgeConfirmation(page);
    
    // Detectar e tentar resolver CAPTCHA
    let captchaRetries = 0;
    const maxCaptchaRetries = 3;
    while (await detectCaptcha(page) && captchaRetries < maxCaptchaRetries) {
      console.log(`CAPTCHA detectado (tentativa ${captchaRetries + 1}/${maxCaptchaRetries}). Tentando resolver...`);
      const solved = await solveCaptcha(page);
      if (!solved) {
        console.log('Aguardando 10s para possível resolução manual ou retry...');
        await page.waitForTimeout(10000);
      }
      captchaRetries++;
      // Recarregar página se necessário
      await page.reload({ waitUntil: 'domcontentloaded' });
    }
    if (await detectCaptcha(page)) {
      throw new Error('CAPTCHA não resolvido após tentativas. Abortando.');
    }
    
    // save initial snapshot for mapping
    if(interactiveMap){
      const mapDir = path.join(process.cwd(), 'DevSan001', 'outputs', 'map');
      fs.mkdirSync(mapDir, { recursive: true });
      const snapPath = path.join(mapDir, `snapshot_start_${Date.now()}.html`);
      const html = await page.content();
      fs.writeFileSync(snapPath, html, 'utf8');
      console.log('Saved initial DOM snapshot to', snapPath);
    }

    // If caller requested to wait for manual user interaction (e.g., solve Cloudflare/Turnstile), pause here
    if(options.waitForUser){
      console.log('\n>>> Pausado para interação manual: resolva qualquer verificação (CAPTCHA/Turnstile) no navegador agora.');
      console.log('>>> Quando terminar, volte ao terminal e pressione Enter para continuar...');
      await new Promise((resolve) => {
        process.stdin.resume();
        process.stdin.once('data', function() {
          process.stdin.pause();
          resolve();
        });
      });
      console.log('Continuando após confirmação do usuário...');
    }

    await loginIfNeeded(page);
    // Aceitar confirmações novamente após login
    await acceptCookies(page);
    await acceptAgeConfirmation(page);
    // Map page after load so we can inspect unexpected UI (saved to outputs/map)
    try { await mapPage(page, 'initial'); } catch(e){}
    const res = await submitPromptAndCapture(page, prompt, outPath, options, browser);

    if(interactiveMap){
      const mapDir = path.join(process.cwd(), 'DevSan001', 'outputs', 'map');
      const snapPath = path.join(mapDir, `snapshot_end_${Date.now()}.html`);
      const html = await page.content();
      fs.writeFileSync(snapPath, html, 'utf8');
      console.log('Saved final DOM snapshot to', snapPath);
    }

    return res;
  }catch(err){
    throw err;
  }finally{
    // Do not close persistent context if using EDGE_USER_DATA_DIR
    if(!(BROWSER === 'msedge' || BROWSER === 'edge') || !EDGE_USER_DATA_DIR){
      try{ await context.close(); }catch(e){}
    }
  }
}

module.exports = { generateImage };
