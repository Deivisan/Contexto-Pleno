import { AgentRunner } from './AgentRunner.js';
import path from 'path';

// --- O PROMPT SUPREMO ---
const PROMPT = `
CONTEXTO: Você é o Arquiteto da Matrix. Sua missão é criar a interface definitiva de um Pet Shop Cyberpunk.
TAREFA: Gere um arquivo 'index.html' ÚNICO contendo:
1. CSS: Fundo preto (#000), Texto Verde Terminal (#0F0), Fonte Monospace.
2. JS: Efeito 'Digital Rain' (Matrix) caindo no fundo (Canvas).
3. HTML: Cards de produtos (Ex: 'Coelho Branco', 'Ração Blue Pill').
4. UI: Efeitos Glitch/Distortion no hover dos botões.
5. REQUISITO CRÍTICO: O código deve ser completo, funcional e salvo no arquivo alvo.
NÃO explique. APENAS gere o código e salve.
`;

const BASE_DIR = path.resolve('termux/orchestrator/output');

async function main() {
    console.log("🟢 INICIANDO ORQUESTRAÇÃO MATRIX [NODE.JS]");
    console.log("------------------------------------------");

    const agents = [
        new AgentRunner({
            name: 'Gemini',
            command: 'gemini',
            // Gemini precisa que a gente diga onde salvar explicitamente no prompt, pois ele usa tools
            args: [`"${PROMPT} Salve o arquivo em index.html"`, '--yolo'],
            outputDir: BASE_DIR,
            targetFile: 'index.html',
            timeout: 180000 // 3 min (Gemini precisa de tempo para MCPs)
        }),
        new AgentRunner({
            name: 'Qwen',
            command: 'qwen',
            // Qwen salva onde a gente manda
            args: [`"${PROMPT} Save to index.html"`, '--yolo'],
            outputDir: BASE_DIR,
            targetFile: 'index.html',
            timeout: 120000 // 2 min
        }),
        new AgentRunner({
            name: 'Kilocode',
            command: 'kilocode',
            // Kilocode architect mode
            args: [`"${PROMPT} Save output to index.html"`, '--auto', '--mode', 'architect'],
            outputDir: BASE_DIR,
            targetFile: 'index.html',
            timeout: 300000 // 5 min (Kilocode é lento/complexo)
        })
    ];

    // Dispara todos
    agents.forEach(agent => agent.start());

    // Mantém processo vivo até todos terminarem
    const checkLoop = setInterval(() => {
        const active = agents.filter(a => a.status === 'running' || a.status === 'pending');
        if (active.length === 0) {
            console.log("------------------------------------------");
            console.log("🏁 ORQUESTRAÇÃO CONCLUÍDA. Relatório:");
            agents.forEach(a => {
                const icon = a.status === 'success' ? '✅' : '❌';
                console.log(`${icon} ${a.name}: ${a.status}`);
            });
            clearInterval(checkLoop);
            process.exit(0);
        }
    }, 5000);
}

main();
