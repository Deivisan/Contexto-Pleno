#!/usr/bin/env node
const minimist = require('minimist');
const dotenv = require('dotenv');
dotenv.config();
const path = require('path');
const { generateImage } = require('../../src/tools/grok-tool');

async function main(){
    const argv = minimist(process.argv.slice(2));
    const prompt = argv._[0] || argv.prompt || argv.p;
    const out = argv.out || argv.o || path.join(process.cwd(), 'DevSan001', 'outputs', `grok_${Date.now()}.png`);
    const headful = argv.headful || argv.h || true; // sempre headful por padrão
    const map = argv.map || false;
    const keepOpen = argv['keep-open'] || argv.keepOpen || false;
    const expectedImages = Number(argv['expected-images'] || argv.expected || argv.e || 2);
    const interactive = argv.interactive || argv.i || false; // pause for manual inspection (DevTools)
    const debug = argv.debug || false;
    const timeout = Number(argv.timeout || argv.t || 180000);
    const clickDelay = Number(argv['click-delay'] || argv.clickDelay || 500);
    const clickRetries = Number(argv['click-retries'] || argv.clickRetries || 6);
    if(!prompt){
      console.log('Usage: node grok-automate.js "your prompt" [--out out.png] [--headful] [--map] [--keep-open] [--expected-images 2] [--interactive] [--debug]');
      process.exit(1);
    }
    console.log('Gerando imagem para prompt:', prompt);
    try{
      const res = await generateImage(prompt, { outPath: out, headless: !headful, map, keepOpen, clickDelay, clickRetries, pauseAfterSubmit: interactive, expectedImages, debug, timeout });
      console.log('Resultado:', res);
    }catch(e){
      console.error('Erro durante automação Grok:', e.message);
      process.exit(2);
    }
}

main();
