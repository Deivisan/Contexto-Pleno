#!/usr/bin/env node
// CLI minimal para DevSan001
const fs = require('fs');
const path = require('path');

function help(){
  console.log('DevSan001 CLI - comandos disponíveis:');
  console.log('  node src/cli.js help        Mostrar ajuda');
  console.log('  node src/cli.js test-run    Executar fluxo de teste (mock)');
}

async function testRun(){
  console.log('Executando test-run (fluxo mínimo)...');
  // fluxo mínimo: ler arquivo de contexto se existir
  const ctxPath = path.join(__dirname, '..', 'context.json');
  if(fs.existsSync(ctxPath)){
    const ctx = JSON.parse(fs.readFileSync(ctxPath, 'utf8'));
    console.log('Contexto carregado:', Object.keys(ctx));
  } else {
    console.log('Nenhum contexto encontrado (crie DevSan001/context.json para testar)');
  }
  console.log('Fluxo de teste finalizado. Próximo: implementar tools (MCP modules).');
}

const cmd = process.argv[2] || 'help';
if(cmd === 'help') help();
else if(cmd === 'test-run') testRun();
else help();
