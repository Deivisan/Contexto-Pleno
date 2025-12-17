# Prompts para agentes de pesquisa (usar para enriquecer documentação)

Use estes prompts com agentes de busca web ou ferramentas de pesquisa automática para coletar informações atualizadas (Dez/2025) e anexar resultados em `docs/REFERENCES.md`.

1) Pesquisa sobre Genkit
"Pesquise o Genkit (Google Genkit): licença, instalação, recursos de dev UI, exemplos de uso para orquestração de agentes e integrações com Node.js. Liste links oficiais e um resumo de 6 itens." 

2) APIs freemium para LLMs e imagens
"Liste APIs gratuitas ou freemium práticas em Dez/2025 (Google AI / Gemini, OpenRouter, Hugging Face Inference, Replicate). Para cada serviço detalhe: endpoints, limites grátis, autenticação e exemplos mínimos de chamada HTTP." 

3) Modelos locais viáveis no Windows (500M–2B)
"Colete modelos ggml compatíveis (500M–2B) com instruções de execução no Windows (llama.cpp, text-generation-webui). Indique requisitos de RAM/SSD estimados e passos de quantização." 

4) Playwright + Grok
"Documente práticas para automação de Grok com Playwright: login, navigação, captura de imagem; identifique riscos de TOS, CAPTCHA e mitigação." 

5) Storage vetorial local
"Compare Chroma local, FAISS e SQLite+annoy para uso em Windows 11; inclua instruções rápidas de instalação e exemplos de uso com Node.js e Python." 

Como usar
--
1. Copie um prompt acima para o seu agente de pesquisa (ou para o Chat integrado no VS Code).  
2. Salve resultados em `docs/REFERENCES.md` com links e snippets de chamada.  
3. Atualize a documentação e abra issues para tarefas que surgirem.
