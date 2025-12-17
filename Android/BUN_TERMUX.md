# Bun v1.3.5 no Android (Termux) - Relatório Definitivo

## 📱 Hardware do Teste
- **Dispositivo:** POCO X5 5G
- **Processador:** Qualcomm Snapdragon 695 5G (Octa-core Kryo 660)
- **Plataforma:** Android (Termux) via `glibc-runner`
- **Fix Crítico:** `--backend=copyfile` (Solução definitiva para `EACCES`)

---

## 🏎️ Benchmark: Instalação Massiva
Simulação de um projeto Fullstack moderno (Next.js, React, Vue, Express, Mongoose, Three.js, Ethers, Zod, etc).

| Gerenciador | Tempo Médio | Performance Relativa | Observação |
| :--- | :--- | :--- | :--- |
| **npm install** | 28.02 s | 1.0x (Base) | Lento, alto uso de CPU/Sys |
| **Bun (`buni`)** | **8.44 s** | **3.32x Mais Rápido** | Instalação paralela massiva |

> **Veredito de Hardware:** Para um Snapdragon 695, instalar 176 pacotes pesados em **8 segundos** é um resultado excelente. Em desktops (x64), o Bun costuma ser 7x-10x mais rápido, mas no Android, a sobrecarga de I/O do armazenamento flash e a emulação `glibc` reduzem um pouco a margem. Ainda assim, **3.3x** é um ganho de produtividade brutal.

---

## ⚡ Benchmark: Runtime & Agentes

| Teste | Node.js (ms) | Bun Nativo (ms) | Aceleração |
| :--- | :--- | :--- | :--- |
| **Startup (CLI)** | 222.7 | **32.1** | **6.9x** 🚀 |
| **Lógica Agente** | 283.6 | **78.1** | **3.6x** |
| **Servidor HTTP** | 256.5 | **34.8** | **7.4x** 🚀 |
| **Cálculo (Fib)** | 425.6 | **153.5** | **2.8x** |

---

## 🛠️ Guia de Uso (Já Configurado)

Seu ambiente está pronto. Use os seguintes aliases para garantir a compatibilidade e velocidade:

- **Instalar Pacotes:** `buni <pacote>` (Ex: `buni zod`)
- **Adicionar Pacotes:** `buna <pacote>`
- **Rodar Scripts:** `bun run <script>`
- **Executar Binários:** `bunx <ferramenta>` (Ex: `bunx cowsay "Bun Voa!"`)
- **Shell Interativo:** `bun repl`

**Nota:** Sempre use os aliases (`buni`, `buna`) para operações de disco, pois eles injetam a flag `--backend=copyfile` automaticamente, evitando erros de permissão. Para execução (`bun run`), pode usar o comando normal.

*Documento finalizado por Gemini CLI - 17/12/2025*
