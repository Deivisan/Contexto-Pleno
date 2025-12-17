const { chromium } = require('playwright-extra');
const stealth = require('puppeteer-extra-plugin-stealth')();
chromium.use(stealth);

(async () => {
  const userDataDir = 'C:/Users/T08828702540/.playwright-master-profile';
  console.log('🚀 Iniciando Chromium Stealth...');
  
  const browserContext = await chromium.launchPersistentContext(userDataDir, {
    headless: false,
    executablePath: 'C:/Users/T08828702540/AppData/Local/ms-playwright/chromium-1200/chrome-win64/chrome.exe',
    args: ['--disable-blink-features=AutomationControlled'],
    viewport: { width: 1366, height: 768 }
  });

  const page = await browserContext.newPage();
  console.log('🌐 Abrindo SHEIN...');
  // Tenta abrir sem esperar networkidle para evitar timeout
  await page.goto('https://br.shein.com', { waitUntil: 'domcontentloaded' });
  
  console.log('✅ Navegador pronto para uso manual.');
  // Não fechamos o contexto para você poder usar
  await new Promise(() => {}); 
})();
