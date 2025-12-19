# 📚 DECISÕES ARQUIVADAS - Histórico de Mudanças

**Documento:** Histórico de decisões importantes do sistema  
**Propósito:** Manter registro do que foi tentado e por quê foi abandonado  
**Data:** 2025-12-18

---

## 🗂️ Índice de Decisões

1. [Docker MCP - Arquivado](#docker-mcp---arquivado)
2. [Node.js → Bun - Migrado](#nodejs--bun---migrado)
3. [VSCode → OpenCode - Substituído](#vscode--opencode---substituído)
4. [Kiro IDE - Legado](#kiro-ide---legado)

---

## 1. Docker MCP - Arquivado

### ⏱️ Timeline
- **Início:** Dezembro 2024
- **Tentativas:** Dezembro 2024 - Dezembro 2025
- **Status Final:** ❌ ARQUIVADO em 2025-12-18

### 🎯 Objetivo Original
Universalizar MCPs usando Docker containers para:
- Isolamento de dependências
- Portabilidade entre ambientes
- Facilidade de atualização
- Compartilhamento entre agentes IA

### 🔧 O Que Foi Tentado

#### No Windows (Sistema Original)
- Docker Desktop 29.1.2 instalado
- 5+ containers MCP criados:
  - context7-mcp (documentação)
  - playwright-mcp (automação web)
  - desktop-commander (automação UI)
  - github-mcp (integração GitHub)
  - mcp-platform (geração de conteúdo)
- Docker Compose com múltiplos serviços
- Network bridge customizada
- Volumes persistentes configurados
- Healthchecks implementados

#### Configurações Testadas
```yaml
# docker-compose.yml (exemplo)
version: '3.8'
services:
  context7:
    image: mcp/context7
    ports:
      - "8080:8080"
    networks:
      - mcp-network
    restart: unless-stopped
```

#### Integração com IDEs
- Kiro IDE (Windows)
- OpenCode (Windows e Linux)
- Tentativas de configuração universal

### ❌ Problemas Encontrados

#### 1. Instabilidade
- Containers em loop de restart constante
- Healthchecks falhando sem razão clara
- Context7 sempre "unhealthy" mas funcional
- Perda de conexão frequente

#### 2. Complexidade
- Configuração diferente para cada IDE
- Mapeamento de portas complexo
- Volumes precisando configuração manual
- Network bridge com problemas intermitentes

#### 3. Performance
- Overhead significativo de containers
- Latência em comunicação STDIO
- Consumo elevado de memória (3+ GB para containers)
- Tempo de startup lento

#### 4. Manutenção
- Atualização de imagens complicada
- Logs difíceis de debugar
- Dependência do Docker Desktop
- Problemas de permissão no Windows

### 📄 Documentação Preservada

#### Localizações
- `Projetos/Prompts/.kiro/docker-mcp-analysis.md` - Análise completa
- `Projetos/contexto-pleno/PC/ROADMAP-MCP-UNIVERSAL.md` - Roadmap (histórico)
- `Projetos/contexto-pleno/PC/CONFIGURACAO-OPENCODE-FINAL.md` - Config Windows
- `Projetos/contexto-pleno/PC/MCPS/Docker/docker-compose.yml` - Compose file
- `Projetos/contexto-pleno/PC/scripts/` - Scripts PowerShell de gerenciamento

#### Valor Histórico
- Documenta o processo de aprendizado
- Mostra o que foi tentado extensivamente
- Serve de referência para futuras decisões
- Ajuda a entender por que bunx/uvx é preferível

### ✅ Solução Adotada
**bunx/uvx** - Executar MCPs diretamente via package runners
- Mais simples
- Menos overhead
- Mais estável
- Fácil manutenção

### 🎓 Lições Aprendidas
1. Simplicidade vence complexidade
2. Docker é ótimo para apps, não necessariamente para MCPs
3. STDIO direto é mais confiável que HTTP/SSE em containers
4. Overhead de containers nem sempre vale a pena
5. Manutenibilidade > Arquitetura "bonita"

---

## 2. Node.js → Bun - Migrado

### ⏱️ Timeline
- **Decisão:** Dezembro 2025
- **Migração:** Dezembro 2025
- **Status:** ✅ CONCLUÍDO

### 🎯 Motivação
- Bun é significativamente mais rápido
- Runtime moderno com TypeScript nativo
- Substituição drop-in para Node.js
- Melhor DX (developer experience)

### 🔄 Processo de Migração

#### 1. Instalação
```bash
curl -fsSL https://bun.sh/install | bash
```

#### 2. Substituição de Comandos
| Antes (Node) | Depois (Bun) |
|--------------|---------------|
| `npm install` | `bun install` |
| `npx <pkg>` | `bunx <pkg>` |
| `npm run` | `bun run` |
| `npm add` | `bun add` |

#### 3. Atualização de Configs
- Todos os MCPs bunx em `opencode.json`
- Scripts atualizados para usar bunx
- Documentação atualizada

### ✅ Resultado
- Bun 1.3.5 como runtime padrão
- Todos os MCPs Node-based usando bunx
- Performance melhorada
- Menos dependências globais

### 📝 Regra de Ouro
**NUNCA use npm/npx. SEMPRE use bun/bunx.**

---

## 3. VSCode → OpenCode - Substituído

### ⏱️ Timeline
- **VSCode em uso:** Até dezembro 2025
- **OpenCode adotado:** Dezembro 2025
- **VSCode desinstalado:** 2025-12-18
- **Status:** ✅ SUBSTITUIÇÃO COMPLETA

### 🎯 Motivação
- OpenCode CLI é suficiente para todas as tarefas
- Integração nativa com MCPs
- Mais leve e rápido
- Múltiplos modelos IA nativos
- Foco em desenvolvimento com IA

### 🔧 Funcionalidades OpenCode

#### Modelos Disponíveis
- Claude Sonnet 4.5 (raciocínio)
- Grok Code (código)
- Gemini 3 Flash (rápido)
- Gemini 3 Pro (profundo)

#### MCPs Nativos
- 9 servidores configurados
- Integração perfeita
- Configuração simples via JSON

#### Comandos
```bash
opencode                 # Interativo
opencode --continue      # Continuar
opencode "mensagem"      # Single message
```

### ✅ Resultado
- VSCode desinstalado
- OpenCode como única ferramenta
- Workflow simplificado
- Menos distrações

### 📝 Regra de Ouro
**Não mencionar VSCode. OpenCode é a única opção.**

---

## 4. Kiro IDE - Legado

### ⏱️ Timeline
- **Uso:** 2024-2025
- **Configurações:** Extensivas em `/home/deivi/.kiro/`
- **Status:** 🗄️ LEGADO (configs preservadas)

### 🎯 Contexto
- Kiro foi um IDE customizado/configurado anteriormente
- Documentação extensa em `.kiro/` directories
- Configurações MCP em `mcp.json`
- Scripts e workflows específicos

### 📄 Documentação Preservada

#### Localizações
- `/home/deivi/.kiro/mcp.json` - Config MCP antiga
- `Projetos/Prompts/.kiro/` - Docs extensivas
  - RESUMO-EXECUTIVO.md
  - POWER-UNLOCKED.md
  - docker-mcp-analysis.md
  - Etc.

#### Valor Histórico
- Mostra evolução do setup
- Documenta tentativas anteriores
- Configs podem ser referência
- Não deve ser apagado (histórico)

### ✅ Estado Atual
- Configs preservadas mas não ativas
- OpenCode é o sucessor
- Documentação mantida para referência
- Não está em uso ativo

### 📝 Regra de Ouro
**Kiro é legado. Não sugerir uso, mas preservar docs.**

---

## 🎯 Princípios de Arquivamento

### O Que Arquivar
- Tecnologias testadas mas abandonadas
- Configurações que não funcionaram
- Abordagens que se mostraram complexas demais
- Decisões que foram revertidas

### Como Arquivar
1. Documentar extensivamente
2. Explicar por que foi tentado
3. Detalhar problemas encontrados
4. Documentar solução adotada
5. Preservar configs para referência

### Por Que Arquivar
- Evitar repetir erros
- Documentar aprendizado
- Ajudar futuras decisões
- Manter histórico completo

---

## 📊 Resumo de Decisões

| Tecnologia | Status | Substituído Por | Data |
|------------|--------|-----------------|------|
| **Docker MCP** | ❌ Arquivado | bunx/uvx | 2025-12-18 |
| **Node.js/npm** | ❌ Substituído | Bun/bunx | 2025-12 |
| **VSCode** | ❌ Desinstalado | OpenCode CLI | 2025-12-18 |
| **Kiro IDE** | 🗄️ Legado | OpenCode CLI | 2025 |

---

## 🚀 Tecnologias Ativas

| Tecnologia | Versão | Status | Uso |
|------------|--------|--------|-----|
| **Bun** | 1.3.5 | ✅ Ativo | Runtime JS/TS |
| **OpenCode** | Latest | ✅ Ativo | IDE principal |
| **bunx/uvx** | - | ✅ Ativo | MCPs |
| **Python/uv** | 3.12.3/0.9.18 | ✅ Ativo | Python dev |

---

**Documento:** DECISOES-ARQUIVADAS.md  
**Versão:** 1.0  
**Última Atualização:** 2025-12-18  
**Gerado por:** OpenCode AI (Claude Sonnet 4.5)
