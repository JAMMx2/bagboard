# BagBoard local server - serves index.html + a shared leads database (/api/state).
# Private (localhost) by default; opt in at startup to share on your Wi-Fi so your phone syncs.
$port = 8753
$root = $PSScriptRoot
if ([string]::IsNullOrEmpty($root)) { $root = Split-Path -Parent $MyInvocation.MyCommand.Definition }
$htmlPath = Join-Path $root 'index.html'
if (-not (Test-Path $htmlPath)) { Clear-Host; Write-Host '  index.html not found next to this script.' -ForegroundColor Red; Read-Host '  Press Enter'; exit 1 }
Write-Host ''
Write-Host '  BagBoard' -ForegroundColor Green
Write-Host '  By default only THIS computer can open it (private).'
$share = Read-Host '  Share on your Wi-Fi so your phone can open it and dial? Type Y, or press Enter for private'
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
Clear-Host
Write-Host ''
Write-Host '  BagBoard is running' -ForegroundColor Green
Write-Host ''
Write-Host "  On this computer:     http://localhost:$port/"
if ($shared) {
    if ($lan) {
        Write-Host "  On your phone (Wi-Fi): http://${lan}:$port/" -ForegroundColor Yellow
        Write-Host ''
        Write-Host '  Open that address on your phone to dial - your leads sync both ways.'
        Write-Host '  - First time, Windows may ask to allow it through the firewall: click Allow.'
        Write-Host '  - Shared over Wi-Fi: use a network you trust (home/office), not public Wi-Fi.'
        Write-Host '  - Some guest/office Wi-Fi blocks device-to-device traffic; if the phone'
        Write-Host '    cannot open it you are on such a network.'
    } else {
        Write-Host '  Sharing on Wi-Fi - run ipconfig to find your IPv4 address.' -ForegroundColor Yellow
    }
} else {
    Write-Host '  Private - only this computer can open it (data saved on this PC).'
}
Write-Host ''; Write-Host '  Keep this window open while you work. Close it to stop.'; Write-Host ''
$token = ([guid]::NewGuid().ToString('N')).Substring(0,10)
$dataPath = Join-Path $env:USERPROFILE 'BagBoard-data.json'
$tag = "<script>window.BB_STORE='/api/state?k=$token';"
if ($shared -and $lan) { $tag += "window.BB_SHARE='http://${lan}:$port/';" }
$tag += "</script>"
$htmlText = [System.IO.File]::ReadAllText($htmlPath)
$htmlText = $htmlText.Replace('</head>', "$tag</head>")
$htmlBytes = [System.Text.Encoding]::UTF8.GetBytes($htmlText)
while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
        $stream = $client.GetStream()
        try { $stream.ReadTimeout = 8000 } catch {}
        $ms = New-Object System.IO.MemoryStream
        $buf = New-Object 'byte[]' 8192
        $headerEnd = -1
        while ($headerEnd -lt 0) {
            $read = $stream.Read($buf, 0, $buf.Length)
            if ($read -le 0) { break }
            $ms.Write($buf, 0, $read)
            $arr = $ms.GetBuffer(); $len = [int]$ms.Length
            for ($i = 0; $i -le $len - 4; $i++) {
                if ($arr[$i] -eq 13 -and $arr[$i+1] -eq 10 -and $arr[$i+2] -eq 13 -and $arr[$i+3] -eq 10) { $headerEnd = $i; break }
            }
            if ($len -gt 262144) { break }
        }
        $all = $ms.ToArray()
        $method = 'GET'; $path = '/'; $clen = 0
        if ($headerEnd -ge 0) {
            $headerText = [System.Text.Encoding]::ASCII.GetString($all, 0, $headerEnd)
            $hlines = $headerText -split "`r`n"
            $rl = $hlines[0] -split ' '
            if ($rl.Length -ge 2) { $method = $rl[0]; $path = $rl[1] }
            foreach ($hl in $hlines) { if ($hl -match '^(?i)content-length:\s*(\d+)') { $clen = [int]$matches[1] } }
        }
        $status = '200 OK'; $ctype = 'text/html; charset=utf-8'; $respBytes = $null
        if ($path -like '/api/state*') {
            $ctype = 'application/json'
            if ($path -notlike "*k=$token*") {
                $status = '403 Forbidden'; $respBytes = [System.Text.Encoding]::UTF8.GetBytes('{"error":"forbidden"}')
            } elseif ($method -eq 'POST') {
                $bodyStart = $headerEnd + 4
                $body = New-Object System.IO.MemoryStream
                if ($all.Length -gt $bodyStart) { $body.Write($all, $bodyStart, $all.Length - $bodyStart) }
                while ($body.Length -lt $clen) {
                    $read = $stream.Read($buf, 0, $buf.Length)
                    if ($read -le 0) { break }
                    $body.Write($buf, 0, $read)
                }
                try { [System.IO.File]::WriteAllBytes($dataPath, $body.ToArray()) } catch {}
                $respBytes = [System.Text.Encoding]::UTF8.GetBytes('{"ok":true}')
            } else {
                if (Test-Path $dataPath) { $respBytes = [System.IO.File]::ReadAllBytes($dataPath) }
                else { $respBytes = [System.Text.Encoding]::UTF8.GetBytes('{}') }
            }
        } else {
            $respBytes = $htmlBytes
        }
        $respHeader = "HTTP/1.1 $status`r`nContent-Type: $ctype`r`nContent-Length: $($respBytes.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
        $rhb = [System.Text.Encoding]::ASCII.GetBytes($respHeader)
        $stream.Write($rhb, 0, $rhb.Length); $stream.Write($respBytes, 0, $respBytes.Length); $stream.Flush()
    } catch { } finally { $client.Close() }
}
