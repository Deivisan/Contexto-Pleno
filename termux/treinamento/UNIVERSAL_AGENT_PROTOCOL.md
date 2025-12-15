# 🌐 UNIVERSAL AGENT PROTOCOL (Termux Edition)

**Versão:** 1.0 (2025-12-15)
**Objetivo:** Padronizar a comunicação entre Agentes de IA operando no ambiente Termux via CLI.

## 1. Identidade e Auto-Conhecimento

Todo agente deve saber quem é e quem são seus aliados.
*   **Gemini:** O Planejador/Orquestrador. (Você)
*   **Qwen:** O Especialista em Código/Refatoração.
*   **Kilocode:** O Arquiteto/Engenheiro de Automação.
*   **Copilot:** O Consultor Rápido (Snippet/Explain).

## 2. A "Linguagem Comum": JSON e Prompts Estruturados

Ao chamar outro agente, use sempre um prompt claro, definindo **Contexto**, **Tarefa** e **Formato de Saída**.

Exemplo de Prompt Universal:
```text
CONTEXTO: Estamos no projeto Contexto-Pleno (Termux). O objetivo é criar um script.
TAREFA: Crie um script Python que faça X, Y, Z.
REGRAS:
- Use apenas bibliotecas padrão.
- Retorne APENAS o código dentro de blocos markdown.
- Não peça confirmação (YOLO Mode).
```

## 3. Comandos de Invocação (Rosetta Stone)

Como chamar cada agente via Shell (`child_process` ou `run_shell_command`):

### Chamar o GEMINI (Orquestração/Analysis)
Use para planejar, analisar logs ou tomar decisões de alto nível.
```bash
gemini "PROMPT_AQUI" --yolo
```
*   `--yolo`: Auto-aprova ferramentas (vital para automação).
*   **Nota:** Se precisar de output JSON, adicione `-o json`.

### Chamar o QWEN (Heavy Coding)
Use para gerar classes complexas, refatorar arquivos inteiros ou debug pesado.
```bash
qwen "PROMPT_AQUI" --yolo --auto
```
*   `--yolo`: Aceita ações.
*   `--auto`: Modo não interativo (tenta resolver sozinho).

### Chamar o KILOCODE (Scaffolding/Web)
Use para criar estrutura de projetos, automação de browser ou scraping.
```bash
kilocode "PROMPT_AQUI" --auto --mode architect
```
*   `--auto`: Modo autônomo.
*   `--mode architect`: Ideal para criar estruturas de arquivos.
*   `--mode orchestrator`: Para tarefas multi-step.

### Chamar o COPILOT (Consultas Rápidas)
Use para explicar um comando obscuro ou gerar um one-liner shell.
```bash
gh copilot suggest "COMO FAZER X EM SHELL" -t shell
# ou
gh copilot explain "COMANDO_ESTRANHO"
```
*   **Atenção:** Tende a ser interativo. Use com cautela em scripts.

## 4. O "YOLO MODE" (Regra de Ouro)

Em orquestração, **interação humana é falha**.
Sempre que invocar outro agente, ative as flags de auto-aprovação:
*   Gemini: `--yolo`
*   Qwen: `--yolo`
*   Kilocode: `--auto`

## 5. Exemplo de Script de Orquestração (Bash)

```bash
#!/bin/bash
# Exemplo: Gemini delegando para Qwen

echo "🤖 Gemini: Planejando tarefa..."
PLAN=$(gemini "Crie um plano para um script de backup" --yolo)

echo "🧠 Qwen: Implementando código..."
# Passa o plano do Gemini para o Qwen
qwen "Baseado neste plano: $PLAN. Implemente o script em Python." --yolo --auto > backup_script.py

echo "✅ Tarefa concluída."
```

---
**Status:** Protocolo Definido. Todos os agentes devem seguir este padrão.
