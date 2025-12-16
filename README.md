# 🏗️ Contexto-Pleno — Repositório Universal (PC + Android)

Este repositório centraliza **contexto, documentação e configurações** para agentes IA, suportando múltiplas plataformas.

> Direção atual (2025-12-16): **centralizar MCPs em npm/npx**. Docker/containers ficam como **histórico** devido a incompatibilidades/instabilidade no Windows.

## 📂 Estrutura Organizada

```
Contexto-Pleno/
├── Android/                    # Configurações específicas para Android/Termux
│   └── android/               # Adaptação Termux (ex-termux)
│       ├── configs/           # Configurações JSON sem Docker
│       ├── logs/              # Logs locais
│       ├── mcp/               # MCPs instalados via npm
│       ├── orchestrator/      # Orquestrador Node.js
│       ├── scripts/           # Scripts Bash de automação
│       ├── testes/            # Testes específicos
│       └── treinamento/       # Protocolos de treinamento
├── PC/                        # Configurações específicas para PC
│   ├── MCPS/                  # MCPs via Docker
│   ├── scripts/               # Scripts PowerShell
│   ├── docs/                  # Documentação PC
│   └── *.md                   # Markdowns PC-specific
├── mcp/                        # MCPs via npm/npx (padrão universal)
├── Shared/                    # Arquivos universais (agentes, protocolos)
└── README.md                  # Este arquivo
```

## 🎯 Objetivo

Fornecer contexto completo para agentes em qualquer plataforma, mantendo organização e evitando duplicação desnecessária.

- **PC**: Windows/PowerShell. MCPs via **npm/npx** (padrão). Docker: legado/histórico.
- **Android**: Termux/Bash. MCPs via **npm/npx**.
- **Universal**: Agentes e protocolos compartilhados.

## 🚀 Como Usar

### Para PC
- Use os exemplos em `mcp/` para rodar MCPs via **npm/npx**.
- Consulte `PC/` para histórico do que foi tentado (inclui Docker legado).

### Para Android
- Instale Termux e npm
- Execute `Android/android/scripts/validate-env.sh`
- Configure MCPs em `Android/android/configs/` e `Android/android/mcp/`

### Agentes Universais
- Arquivos em `Shared/` podem ser usados em ambas as plataformas
- Adapte caminhos conforme necessário

## 🔧 Manutenção

- Mantenha sincronização entre PC e Android via Git
- Atualize configurações em ambas as pastas
- Teste em ambos os ambientes antes de commit

**Repositório universal e organizado! 🌍🚀**