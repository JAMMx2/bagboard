# BagBoard local server - serves index.html.
# Private (localhost) by default; opt in at startup to share on your Wi-Fi.
$port = 8753
$root = $PSScriptRoot
if ([string]::IsNullOrEmpty($root)) { $root = Split-Path -Parent $MyInvocation.MyCommand.Definition }
$htmlPath = Join-Path $root 'index.html'
if (-not (Test-Path $htmlPath)) { Clear-Host; Write-Host '  index.html not found next to this script.' -ForegroundColor Red; Read-Host '  Press Enter'; exit 1 }
Write-Host ''
Write-Host '  BagBoard' -ForegroundColor Green
Write-Host '  By default only THIS computer can open it (private).'
$share = Read-Host '  Share on your Wi-Fi so others on this network can open it? Type Y, or press Enter for private'
if ($share -match '^[Yy]') {
    $bind = [System.Net.IPAddress]::Any; $shared = $true; $lan = $null
    try { $lan = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop | Where-Object { $_.IPAddress -notmatch '^(127\.|169\.254\.)' } | Sort-Object InterfaceMetric | Select-Object -First 1).IPAddress } catch {}
    if (-not $lan) { try { $lan = ([System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) | Where-Object { $_.AddressFamily -eq 'InterNetwork' -and $_.ToString() -notmatch '^(127\.|169\.254\.)' } | Select-Object -First 1).ToString() } catch {} }
} else { $bind = [System.Net.IPAddress]::Loopback; $shared = $false }
$listener = New-Object System.Net.Sockets.TcpListener($bind, $port)
try { $listener.Start() } catch {
    Clear-Host; Write-Host ''; Write-Host '  BagBoard is already running on this computer - opening it.' -ForegroundColor Green
    Start-Process "http://localhost:$port/"; Start-Sleep -Seconds 1; exit 0
}
Start-Process "http://localhost:$port/"
Clear-Host; Write-Host ''
Write-Host '  BagBoard is running' -ForegroundColor Green
Write-Host ''
Write-Host "  On this computer:     http://localhost:$port/"
if ($shared) {
    if ($lan) {
        Write-Host "  On your phone (Wi-Fi): http://${lan}:$port/" -ForegroundColor Yellow
        Write-Host ''
        Write-Host '  - First time, Windows may ask to allow it through the firewall: click Allow.'
        Write-Host '  - Some guest/office Wi-Fi blocks device-to-device traffic. If another'
        Write-Host '    device cannot open the address above, you are on such a network.'
        Write-Host '  - Only the app is shared. Everyone keeps their own leads on their own device.'
    } else {
        Write-Host '  Sharing on Wi-Fi - run ipconfig to find your IPv4 address.' -ForegroundColor Yellow
    }
} else {
    Write-Host '  Private - only this computer can open it.'
}
Write-Host ''; Write-Host '  Keep this window open while you work. Close it to stop.'; Write-Host ''
$htmlText = [System.IO.File]::ReadAllText($htmlPath)
if ($shared -and $lan) { $htmlText = $htmlText.Replace('</head>', "<script>window.BB_SHARE='http://${lan}:$port/';</script></head>") }
$htmlBytes = [System.Text.Encoding]::UTF8.GetBytes($htmlText)
while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
        $stream = $client.GetStream(); $buffer = New-Object byte[] 4096
        try { [void]$stream.Read($buffer, 0, $buffer.Length) } catch {}
        $header = "HTTP/1.1 200 OK`r`nContent-Type: text/html; charset=utf-8`r`nContent-Length: $($htmlBytes.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
        $hb = [System.Text.Encoding]::ASCII.GetBytes($header)
        $stream.Write($hb,0,$hb.Length); $stream.Write($htmlBytes,0,$htmlBytes.Length); $stream.Flush()
    } catch { } finally { $client.Close() }
}
