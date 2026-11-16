$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
$baseDir = "C:\Users\redve\.gemini\antigravity\scratch\electro-shield-pwa"
Write-Host "Server listening on http://localhost:8080/"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $req = $context.Request
    $res = $context.Response
    $rel = $req.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrEmpty($rel)) { $rel = "index.html" }
    $file = Join-Path $baseDir $rel
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllBytes($file)
        if ($file.EndsWith(".html")) { $res.ContentType = "text/html; charset=utf-8" }
        elseif ($file.EndsWith(".json")) { $res.ContentType = "application/json" }
        elseif ($file.EndsWith(".js")) { $res.ContentType = "application/javascript" }
        elseif ($file.EndsWith(".png")) { $res.ContentType = "image/png" }
        $res.ContentLength64 = $content.Length
        $res.OutputStream.Write($content, 0, $content.Length)
    } else {
        $res.StatusCode = 404
    }
    $res.Close()
}
