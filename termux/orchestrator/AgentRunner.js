import { spawn } from 'child_process';
import fs from 'fs';
import path from 'path';

export class AgentRunner {
    constructor(config) {
        this.name = config.name;
        this.command = config.command;
        this.args = config.args;
        this.outputDir = config.outputDir;
        this.targetFile = config.targetFile; // Arquivo esperado (ex: index.html)
        this.timeout = config.timeout || 120000; // 2 min default
        this.process = null;
        this.startTime = null;
        this.lastActivity = null;
        this.status = 'pending'; // pending, running, success, failed, timeout
        this.logs = [];
    }

    async start() {
        this.status = 'running';
        this.startTime = Date.now();
        this.lastActivity = Date.now();
        
        console.log(`🚀 [${this.name}] Iniciando PID...`);

        // Cria diretório específico do agente
        const agentDir = path.join(this.outputDir, this.name);
        if (!fs.existsSync(agentDir)) fs.mkdirSync(agentDir, { recursive: true });

        // Executa o comando
        this.process = spawn(this.command, this.args, {
            shell: true,
            cwd: agentDir,
            env: { ...process.env, CI: 'true', TERM: 'xterm-256color' } // Força modo não-interativo onde possível
        });

        // Monitora STDOUT (O "Pensamento" do modelo)
        this.process.stdout.on('data', (data) => {
            const msg = data.toString().trim();
            if (msg) {
                this.lastActivity = Date.now();
                this.logs.push(msg);
                // Log enxuto para não poluir
                if (msg.length < 200) console.log(`🗣️  [${this.name}] ${msg}`);
            }
        });

        // Monitora STDERR (Erros ou logs de sistema)
        this.process.stderr.on('data', (data) => {
            const msg = data.toString().trim();
            if (msg) {
                this.lastActivity = Date.now();
                // Ignora warnings comuns de node
                if (!msg.includes('DeprecationWarning')) {
                    console.log(`⚠️  [${this.name}] ${msg.substring(0, 100)}...`);
                }
            }
        });

        this.process.on('close', (code) => {
            this.checkSuccess(code);
        });

        // Inicia o loop de monitoramento inteligente (10s)
        this.monitorInterval = setInterval(() => this.monitor(), 10000);
    }

    monitor() {
        if (this.status !== 'running') return;

        const now = Date.now();
        const silenceDuration = (now - this.lastActivity) / 1000;
        const totalDuration = (now - this.startTime) / 1000;

        // Verifica se o arquivo alvo foi criado
        const targetPath = path.join(this.outputDir, this.name, this.targetFile);
        if (fs.existsSync(targetPath)) {
            const stats = fs.statSync(targetPath);
            if (stats.size > 0) {
                console.log(`✅ [${this.name}] SUCESSO DETECTADO! Arquivo ${this.targetFile} criado.`);
                this.stop('success');
                return;
            }
        }

        console.log(`⏱️  [${this.name}] Rodando há ${totalDuration.toFixed(0)}s. Silêncio há: ${silenceDuration.toFixed(0)}s`);

        // Regras de Intervenção
        if (totalDuration > (this.timeout / 1000)) {
            console.log(`🛑 [${this.name}] TIMEOUT! Encerrando forçadamente.`);
            this.stop('timeout');
        } else if (silenceDuration > 45) {
            console.log(`💤 [${this.name}] Agente estagnado (45s sem output). Verificando arquivos...`);
            // Se estagnou e não criou arquivo, é falha provável
            if (!fs.existsSync(targetPath)) {
                 // Deixa rodar mais um pouco se for o Kilocode (ele é lento)
                 if (this.name !== 'Kilocode') {
                     console.log(`💀 [${this.name}] Mato processo por inatividade.`);
                     this.stop('stalled');
                 }
            }
        }
    }

    checkSuccess(code) {
        if (this.status === 'running') {
            const targetPath = path.join(this.outputDir, this.name, this.targetFile);
            if (fs.existsSync(targetPath) && fs.statSync(targetPath).size > 0) {
                this.status = 'success';
            } else {
                this.status = 'failed';
                console.log(`❌ [${this.name}] Processo terminou (Code ${code}) mas arquivo não encontrado.`);
            }
        }
        clearInterval(this.monitorInterval);
    }

    stop(reason) {
        this.status = reason;
        if (this.process) {
            this.process.kill();
        }
        clearInterval(this.monitorInterval);
    }
}
