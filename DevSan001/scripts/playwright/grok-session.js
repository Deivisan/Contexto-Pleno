#!/usr/bin/env node
// Sessão persistente para mapear e interagir com grok usando seu perfil do Edge
const dotenv = require('dotenv');
dotenv.config();
const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { chromium } = require('playwright');

const EDGE_USER_DATA_DIR = process.env.EDGE_USER_DATA_DIR;
const GROK_URL = process.env.GROK_URL || 'https://grok.com';

if(!EDGE_USER_DATA_DIR){
  console.error('ERRO: defina EDGE_USER_DATA_DIR no .env apontando para seu perfil do Edge.');
  process.exit(1);
}

async function main(){
  console.log('Iniciando sessão persistente do Edge com user data dir:', EDGE_USER_DATA_DIR);
  const context = await chromium.launchPersistentContext(EDGE_USER_DATA_DIR, { channel: 'msedge', headless: false });
  const page = (context.pages().length && context.pages()[0]) || await context.newPage();

  const sessionDir = path.join(process.cwd(), 'treinamento', 'grok-session');
  fs.mkdirSync(sessionDir, { recursive: true });
  const logs = { requests: [], console: [] };

  page.on('console', msg => {
    logs.console.push({ ts: Date.now(), text: msg.text(), type: msg.type() });
    const ln = `[console ${msg.type()}] ${msg.text()}`;
    console.log(ln);
    fs.appendFileSync(path.join(sessionDir, 'console.log'), ln + '\n');
  });

  page.on('requestfinished', async (req) => {
    try{
      const r = { url: req.url(), method: req.method(), status: req.response() ? req.response().status() : null, ts: Date.now() };
      logs.requests.push(r);
      fs.appendFileSync(path.join(sessionDir, 'requests.log'), JSON.stringify(r) + '\n');
    }catch(e){}
  });

  await page.goto(GROK_URL, { waitUntil: 'domcontentloaded', timeout: 60000 }).catch(()=>{});
  console.log('Página carregada (se houver proteção Cloudflare, resolva manualmente na janela do Edge).');

  // CLI loop
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  console.log('\nComandos: snapshot | screenshot | list-selectors | type <text> | send | exit');

  rl.on('line', async (line) => {
    const [cmd, ...rest] = line.trim().split(' ');
    const arg = rest.join(' ');
    try{
      if(cmd === 'snapshot'){
        const html = await page.content();
        const file = path.join(sessionDir, `snapshot_${Date.now()}.html`);
        fs.writeFileSync(file, html, 'utf8');
        console.log('Saved DOM snapshot to', file);
      } else if(cmd === 'screenshot'){
        const file = path.join(sessionDir, `screenshot_${Date.now()}.png`);
        await page.screenshot({ path: file, fullPage: false });
        console.log('Saved screenshot to', file);
      } else if(cmd === 'list-selectors'){
        // coletar elementos input-like
        const sel = await page.evaluate(()=>{
          const nodes = Array.from(document.querySelectorAll('textarea, input, [contenteditable], div[role="textbox"], [role="textbox"]'));
          return nodes.slice(0,50).map((n,i)=>({i, tag: n.tagName, outer: n.outerHTML.slice(0,200)}));
        });
        console.log('Candidate elements (truncated):', sel);
      } else if(cmd === 'type'){
        if(!arg) { console.log('type <text>'); return; }
        // type slowly into focused element or first candidate
        const hasFocus = await page.evaluate(()=>document.activeElement && (document.activeElement.tagName==='TEXTAREA' || document.activeElement.isContentEditable));
        if(!hasFocus){
          // focus first contenteditable or textarea
          await page.evaluate(()=>{ const el = document.querySelector('textarea,[contenteditable],div[role="textbox"]'); if(el) el.focus(); });
          await page.waitForTimeout(200);
        }
        for(const ch of arg){
          await page.keyboard.type(ch);
          await page.waitForTimeout(50);
        }
        console.log('Typed (slow) into focused element.');
      } else if(cmd === 'send'){
        // try click send buttons or press Enter
        const ok = await page.evaluate(()=>{
          const btn = document.querySelector('button:has-text("Send"), button:has-text("Generate"), button[type="submit"]');
          if(btn){ btn.click(); return true; }
          const ae = document.activeElement;
          if(ae) { const ev = new KeyboardEvent('keydown',{key:'Enter',bubbles:true}); ae.dispatchEvent(ev); return true; }
          return false;
        });
        console.log('Send attempted:', ok);
      } else if(cmd === 'exit'){
        console.log('Closing session.');
        await context.close();
        rl.close();
        process.exit(0);
      } else {
        console.log('Comando desconhecido:', cmd);
      }
    }catch(e){
      console.error('Erro durante comando:', e.message);
    }
    rl.prompt();
  });
  rl.prompt();
}

main().catch(e=>{ console.error('Sessão falhou:', e.message); process.exit(2); });
