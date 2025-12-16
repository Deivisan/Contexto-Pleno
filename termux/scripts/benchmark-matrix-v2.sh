#!/bin/bash

# Configuração do Benchmark V2
BASE_DIR="termux/testes/benchmark_matrix_v2"
PROMPT="CONTEXTO: Você é um Full Stack Developer Expert. TAREFA: Crie um arquivo 'index.html' ÚNICO e completo para um 'Pet Shop com Tema Matrix'. REQUISITOS: 1. Fundo preto, fonte verde neon (Courier New). 2. Um Canvas no topo com o efeito 'Matrix Digital Rain' (chuva de código) funcional em JS. 3. Seção de produtos com nomes criativos. 4. Botões com efeito hover 'glitch'. 5. Responsivo. SAÍDA: Apenas o código fonte do arquivo index.html. Use a tool de escrita de arquivo."

echo "🟢 INICIANDO BENCHMARK V2: PROJECT MATRIX PET SHOP"
echo "----------------------------------------------"
mkdir -p "$BASE_DIR"

# Função para executar Gemini
run_gemini() {
    echo "💎 [Gemini] Iniciando..."
    mkdir -p "$BASE_DIR/gemini"
    # Correção: Gemini salva arquivo se usar a tool 'write_file'. O prompt já pede isso.
    gemini "Atue como dev. $PROMPT. Salve EXPLICITAMENTE em $BASE_DIR/gemini/index.html" --yolo > "$BASE_DIR/gemini/log.txt" 2>&1
    echo "💎 [Gemini] Finalizado."
}

# Função para executar Qwen
run_qwen() {
    echo "🧠 [Qwen] Iniciando..."
    mkdir -p "$BASE_DIR/qwen"
    # Correção: Remover --auto. Usar apenas --yolo.
    qwen "$PROMPT. Salve o resultado em $BASE_DIR/qwen/index.html" --yolo > "$BASE_DIR/qwen/log.txt" 2>&1
    echo "🧠 [Qwen] Finalizado."
}

# Função para executar Kilocode
run_kilocode() {
    echo "🧬 [Kilocode] Iniciando..."
    mkdir -p "$BASE_DIR/kilocode"
    # Correção: Adicionar timeout de 300s
    kilocode "$PROMPT. Save to $BASE_DIR/kilocode/index.html" --auto --timeout 300 --mode architect > "$BASE_DIR/kilocode/log.txt" 2>&1
    echo "🧬 [Kilocode] Finalizado."
}

# Disparar em Paralelo
run_gemini &
PID_GEMINI=$!

run_qwen &
PID_QWEN=$!

run_kilocode &
PID_KILOCODE=$!

echo "⏳ V2: Agentes disparados. Aguardando..."
wait $PID_GEMINI $PID_QWEN $PID_KILOCODE

echo "----------------------------------------------"
echo "🏁 BENCHMARK V2 CONCLUÍDO!"
ls -R "$BASE_DIR"
