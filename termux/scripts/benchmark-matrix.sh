#!/bin/bash

# Configuração do Benchmark
BASE_DIR="termux/testes/benchmark_matrix"
PROMPT="CONTEXTO: Você é um Full Stack Developer Expert. TAREFA: Crie um arquivo 'index.html' ÚNICO e completo para um 'Pet Shop com Tema Matrix'. REQUISITOS: 1. Fundo preto, fonte verde neon (Courier New). 2. Um Canvas no topo com o efeito 'Matrix Digital Rain' (chuva de código) funcional em JS. 3. Seção de produtos com nomes criativos (ex: 'Red Pill Dog Food', 'Trinity Cat Toys'). 4. Botões com efeito hover 'glitch'. 5. Responsivo. SAÍDA: Apenas o código fonte do arquivo index.html. Não explique, apenas gere o código."

echo "🟢 INICIANDO BENCHMARK: PROJECT MATRIX PET SHOP"
echo "----------------------------------------------"
mkdir -p "$BASE_DIR"

# Função para executar Gemini
run_gemini() {
    echo "💎 [Gemini] Iniciando..."
    mkdir -p "$BASE_DIR/gemini"
    # Gemini CLI pode não salvar arquivo direto, pedimos para ele gerar e usamos output redirection se possível, 
    # ou confiamos que ele use a tool write_file se estiver habilitada. 
    # Para garantir, vou pedir para ele escrever o arquivo usando suas tools internas.
    gemini "Atue como dev. $PROMPT. Salve o arquivo em $BASE_DIR/gemini/index.html" --yolo > "$BASE_DIR/gemini/log.txt" 2>&1
    echo "💎 [Gemini] Finalizado."
}

# Função para executar Qwen
run_qwen() {
    echo "🧠 [Qwen] Iniciando..."
    mkdir -p "$BASE_DIR/qwen"
    # Qwen é ótimo em coding. 
    qwen "$PROMPT. Salve o resultado EXATAMENTE em $BASE_DIR/qwen/index.html" --yolo --auto > "$BASE_DIR/qwen/log.txt" 2>&1
    echo "🧠 [Qwen] Finalizado."
}

# Função para executar Kilocode
run_kilocode() {
    echo "🧬 [Kilocode] Iniciando..."
    mkdir -p "$BASE_DIR/kilocode"
    # Kilocode architect mode
    kilocode "$PROMPT. Save the file to $BASE_DIR/kilocode/index.html" --auto --mode architect > "$BASE_DIR/kilocode/log.txt" 2>&1
    echo "🧬 [Kilocode] Finalizado."
}

# Função para executar Copilot (Desafio)
run_copilot() {
    echo "✈️ [Copilot] Iniciando (Modo Shell Suggest)..."
    mkdir -p "$BASE_DIR/copilot"
    # Copilot CLI é para shell commands. Vamos pedir um comando que gere o HTML.
    # Isso é um teste de criatividade do Copilot CLI.
    CMD_SUGGESTION=$(gh copilot suggest -t shell "create a html file named $BASE_DIR/copilot/index.html with a simple matrix themed pet shop content" 2>&1)
    
    # Salvar a sugestão
    echo "$CMD_SUGGESTION" > "$BASE_DIR/copilot/suggestion.txt"
    echo "✈️ [Copilot] Sugestão salva (não executa código complexo sozinho)."
}

# Disparar em Paralelo (Simulando 4 terminais)
run_gemini &
PID_GEMINI=$!

run_qwen &
PID_QWEN=$!

run_kilocode &
PID_KILOCODE=$!

run_copilot &
PID_COPILOT=$!

echo "⏳ Todos os agentes disparados! Aguardando processos..."
wait $PID_GEMINI $PID_QWEN $PID_KILOCODE $PID_COPILOT

echo "----------------------------------------------"
echo "🏁 BENCHMARK CONCLUÍDO!"
echo "Verifique os resultados em $BASE_DIR"
ls -R "$BASE_DIR"
