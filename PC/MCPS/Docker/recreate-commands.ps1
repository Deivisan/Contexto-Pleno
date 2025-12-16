# Recreate commands generated: 2025-12-09T16:50:42.5447623-03:00
# Review before running. These commands will rename existing containers to <name>_backup and run new ones.
# Example: docker stop <name>; docker rename <name> <name>_backup; docker run -d --name <name> -p hostPort:containerPort image
# Container: mcp_tavily_http (mcp/tavily) - Suggested host port: 3000 -> container port: 3000
docker stop mcp_tavily_http || true
docker rename mcp_tavily_http mcp_tavily_http_backup || true
docker run -d --name mcp_tavily_http -p 3000:3000 mcp/tavily

# Container: mcp_fetch_http (mcp/fetch) - Suggested host port: 9000 -> container port: 9000
docker stop mcp_fetch_http || true
docker rename mcp_fetch_http mcp_fetch_http_backup || true
docker run -d --name mcp_fetch_http -p 9000:9000 mcp/fetch

# Container: mcp_tavily (mcp/tavily) - Suggested host port: 3000 -> container port: 3000
docker stop mcp_tavily || true
docker rename mcp_tavily mcp_tavily_backup || true
docker run -d --name mcp_tavily -p 3000:3000 mcp/tavily

# Container: mcp_context7 (mcp/context7) - Suggested host port: 8080 -> container port: 8080
docker stop mcp_context7 || true
docker rename mcp_context7 mcp_context7_backup || true
docker run -d --name mcp_context7 -p 8080:8080 mcp/context7

# Container: mcp_fetch (mcp/fetch) - Suggested host port: 9000 -> container port: 9000
docker stop mcp_fetch || true
docker rename mcp_fetch mcp_fetch_backup || true
docker run -d --name mcp_fetch -p 9000:9000 mcp/fetch

