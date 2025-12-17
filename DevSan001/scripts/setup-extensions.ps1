# Script para Instalar Extensões no Microsoft Edge
# Execute como Administrador no PowerShell

# Extensões IDs (Chrome Web Store)
$extensions = @(
    "cjpalhdlnbpafiamejdnhcphjbkeiagm", # uBlock Origin
    "fhcgjolkccmbidfldomjliifgaodjagh", # Cookie AutoDelete
    "gcbommkclmclpchllfjekcdonpmejbdp", # HTTPS Everywhere
    "jinjaccalgkegednnccohejagnlnfdag"  # Violentmonkey
)

# Caminho do Edge
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

foreach ($ext in $extensions) {
    $url = "https://chrome.google.com/webstore/detail/$ext"
    Start-Process $edgePath $url
    Write-Host "Instalando extensão: $ext"
    Start-Sleep -Seconds 5  # Aguardar abertura
}

Write-Host "Extensões instaladas. Reinicie o Edge e execute o script Grok."