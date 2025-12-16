# MCPS Docker Summary

Última verificação: $(Get-Date -Format o)

## Situação atual
- `containers.json` contém a lista de containers detectados e seus status (Up / Exit / Restarting).
- A maioria dos MCPs não possui `HostBindings` configuradas (não expõem portas no host).
- `mcp_context7` tem `8080/tcp` exposto como container port, mas sem host binding.

## Containers recomendados para mapeamento (sugerido)
- mcp/context7 -> host: 8080 (container port 8080)
- mcp/tavily -> host: 3000 (container port 3000)
- mcp/server-memory -> host: 4000 (container port 4000)
- mcp/git (git-mcp) -> host: 5000 (container port 5000)
- mcp/fetch -> host: 9000 (container port 9000)

## Gerar e revisar comandos para recriar containers
Use `pwsh ./scripts/generate-mcps-recreate-commands.ps1` para gerar `MCPS/Docker/recreate-commands.ps1` com comandos sugeridos.
Revise o arquivo antes de executar.

## Como tornar os MCPs globais para os agents CLI
1. Exponha portas dos MCPs nos containers com `-p hostPort:containerPort`, por exemplo:

```powershell
docker run -d --name mcp_context7 -p 8080:8080 mcp/context7
```

2. Rode:

```powershell
pwsh ./scripts/export-docker-containers.ps1      # atualiza containers.json
pwsh ./scripts/generate-mcps-recreate-commands.ps1  # gera recomendações
pwsh ./scripts/apply-mcp-env.ps1                 # persiste variáveis de ambiente (setx) para o Windows
```

3. Abra novo PowerShell para herdar as variáveis (ou use `setx` manualmente).

## Segurança e pontos de atenção
- Recriar containers pode perder volumes/variáveis de ambiente configuradas originalmente; sempre verifique `docker inspect <container>` para ver volumes e `docker-compose.yml` origem.
- Renomear containers cria `<name>_backup`; siga com cuidado e monitore logs.

## Next steps possíveis
- If you want, I can safely recreate a selected container with -Confirm mode: `pwsh ./scripts/recreate-mcps-with-ports.ps1 -dryRun:$false`.
- Or, if you prefer, we can generate a `docker-compose.yml` template to manage MCPs with port mappings and persistent volumes.

## Health checks & Agent validation
- `pwsh ./scripts/test-mcps.ps1` — executa testes (host e container-local) e salva em `MCPS/Docker/test-results.json`. Logs são gravados em `MCPS/Docker/logs/`.
- `pwsh ./scripts/validate-agents.ps1` — valida a instalação dos CLIs dos agentes e grava `MCPS/Docker/agents-validation.json` com as saídas de versão e presença em PATH.
