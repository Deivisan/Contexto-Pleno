#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer');

// Usage: node generate_site.js --name "DevSan" --title "DevSan - Agente" --out ../sites/DevSan.html
const argv = require('minimist')(process.argv.slice(2));
const name = argv.name || argv.n || 'Agent';
const title = argv.title || `${name} - Agente`;
const out = argv.out || path.join(__dirname, '..', 'sites', `${name.replace(/\s+/g,'-')}.html`);
const desc = argv.desc || '';
const profs = (argv.profs && argv.profs.split(',')) || [];

(async () => {
  const tpl = makeTemplate({ name, title, desc, profs });

  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  // Emulate viewport for responsive rendering
  await page.setViewport({ width: 1280, height: 800 });

  // Set content (simulates RPA using the web renderer to generate final markup)
  await page.setContent(tpl, { waitUntil: 'networkidle0' });

  // Optional: take a screenshot for quick preview
  const screenshotPath = out.replace(/\.html?$/, '.png');
  await page.screenshot({ path: screenshotPath, fullPage: true });

  // Get the final HTML from the page and write to disk
  const finalHTML = await page.content();
  fs.writeFileSync(out, finalHTML, 'utf8');

  await browser.close();
  console.log(`Site gerado: ${out}`);
  console.log(`Screenshot: ${screenshotPath}`);
})();

function escapeHtml(s){
  return String(s).replace(/[&<>\"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
}

function makeTemplate({ name, title, desc, profs }){
  const profList = profs.length ? profs.map(p => `<li>${escapeHtml(p.trim())}</li>`).join('\n') : '<li>Automação</li><li>Orquestração</li><li>Integração MCPs</li>';
  return `<!doctype html>
<html lang="pt-br">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${escapeHtml(title)}</title>
  <meta name="description" content="Página pessoal automatizada de ${escapeHtml(name)}">
  <style>
    :root{--bg:#0f1720;--card:#0b1220;--accent:#00e676;--muted:#9aa4b2}
    *{box-sizing:border-box}
    body{margin:0;font-family:Inter,system-ui,Segoe UI,Arial;background:linear-gradient(180deg,var(--bg),#07101a);color:#e6eef8;line-height:1.5}
    .container{max-width:900px;margin:3rem auto;padding:1.5rem}
    header{display:flex;align-items:center;gap:1rem}
    .avatar{width:84px;height:84px;border-radius:12px;background:linear-gradient(135deg,var(--accent),#00bcd4);display:flex;align-items:center;justify-content:center;font-weight:700}
    h1{margin:0;font-size:1.9rem}
    .card{background:rgba(255,255,255,0.03);padding:1rem;border-radius:12px;margin-top:1rem}
    ul{margin:0;padding-left:1.1rem}
    footer{margin-top:2rem;color:var(--muted);font-size:.9rem}
    .hero{display:flex;gap:1rem;align-items:center}
    @media (max-width:600px){.hero{flex-direction:column;align-items:flex-start}}
    .cta{display:inline-block;margin-top:.75rem;padding:.5rem .9rem;border-radius:8px;background:var(--accent);color:#001; font-weight:600;text-decoration:none}
    .spark{filter:drop-shadow(0 6px 24px rgba(0,230,118,0.12))}
    .meta{color:var(--muted);margin-top:.5rem}
  </style>
</head>
<body>
  <div class="container">
    <header>
      <div class="avatar spark">${escapeHtml(name[0] || 'A')}</div>
      <div>
        <h1>${escapeHtml(name)}</h1>
        <div class="meta">Agente autônomo — Página gerada via RPA</div>
      </div>
    </header>

    <main>
      <section class="card hero">
        <div style="flex:1">
          <h2>Sobre</h2>
          <p>${escapeHtml(desc || `Sou ${name}, um agente focado em automação, orquestração e construção de soluções robustas.`)}</p>
          <a class="cta" href="#contato">Entrar em contato</a>
        </div>
        <div style="width:260px">
          <h3>Proficências</h3>
          <ul>
            ${profList}
          </ul>
        </div>
      </section>

      <section class="card" style="margin-top:1rem">
        <h3>Projetos & Experimentos</h3>
        <p class="meta">Demonstrações, automações e integrações com MCPs. Esta página foi gerada por um script que usa o navegador (RPA) para renderizar e capturar o resultado final.</p>
      </section>

      <section id="contato" class="card" style="margin-top:1rem">
        <h3>Contato</h3>
        <p class="meta">Este é um exemplo - adicione um e-mail ou link do GitHub conforme desejar.</p>
      </section>
    </main>

    <footer>
      Gerado automaticamente • ${new Date().toLocaleString('pt-BR')}
    </footer>
  </div>
</body>
</html>`;
}
