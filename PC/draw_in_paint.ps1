# Função para desenhar no Paint automaticamente
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Ativar Paint
$wshell = New-Object -ComObject wscript.shell
$wshell.AppActivate('mspaint')
Start-Sleep 2

# Escrever texto
$wshell.SendKeys('TESTE AUTOMATIVO!')
Start-Sleep 1

# Mover para baixo e começar desenho
$wshell.SendKeys('{DOWN}{DOWN}{DOWN}{DOWN}')
$wshell.SendKeys('{RIGHT}')

# Desenhar um quadrado
for($i=0; $i -lt 10; $i++) {
    $wshell.SendKeys('{DOWN}')
    Start-Sleep 0.1
}
for($i=0; $i -lt 10; $i++) {
    $wshell.SendKeys('{LEFT}')
    Start-Sleep 0.1
}
for($i=0; $i -lt 10; $i++) {
    $wshell.SendKeys('{UP}')
    Start-Sleep 0.1
}
for($i=0; $i -lt 10; $i++) {
    $wshell.SendKeys('{RIGHT}')
    Start-Sleep 0.1
}

# Desenhar círculo aproximado
$wshell.SendKeys('{RIGHT}{RIGHT}')
for($i=0; $i -lt 8; $i++) {
    $wshell.SendKeys('{DOWN}{RIGHT}')
    Start-Sleep 0.1
}
for($i=0; $i -lt 8; $i++) {
    $wshell.SendKeys('{DOWN}{LEFT}')
    Start-Sleep 0.1
}
for($i=0; $i -lt 8; $i++) {
    $wshell.SendKeys('{UP}{LEFT}')
    Start-Sleep 0.1
}
for($i=0; $i -lt 8; $i++) {
    $wshell.SendKeys('{UP}{RIGHT}')
    Start-Sleep 0.1
}

Write-Host "Desenho automático concluído!"