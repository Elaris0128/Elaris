param(
    [int]$Port = 43124,
    [string]$OpenBrowser = 'true'
)

Set-StrictMode -Version Latest
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [Console]::OutputEncoding

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$textGameRoot = Split-Path -Parent $scriptRoot
$frameworkConfigPath = Join-Path $textGameRoot '06-framework\config\slices.registry.json'
$generatorPath = Join-Path $scriptRoot 'generate-ui-shell-data.ps1'
$baseUrl = "http://127.0.0.1:$Port/"
$shouldOpenBrowser = -not ([string]$OpenBrowser -match '^(?i:false|0|no)$')

function Add-NoCacheHeaders {
    param([System.Net.HttpListenerResponse]$Response)

    $Response.Headers['Cache-Control'] = 'no-store, no-cache, must-revalidate'
    $Response.Headers['Pragma'] = 'no-cache'
    $Response.Headers['Expires'] = '0'
}

function Write-JsonResponse {
    param(
        [Parameter(Mandatory)]
        [System.Net.HttpListenerResponse]$Response,
        [Parameter(Mandatory)]
        [int]$StatusCode,
        [Parameter(Mandatory)]
        [object]$Payload
    )

    $json = $Payload | ConvertTo-Json -Depth 8
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $Response.StatusCode = $StatusCode
    $Response.ContentType = 'application/json; charset=utf-8'
    $Response.ContentLength64 = $bytes.Length
    Add-NoCacheHeaders -Response $Response
    $Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $Response.OutputStream.Close()
}

function Write-FileResponse {
    param(
        [Parameter(Mandatory)]
        [System.Net.HttpListenerResponse]$Response,
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    $extension = [System.IO.Path]::GetExtension($FilePath).ToLowerInvariant()
    $contentType = switch ($extension) {
        '.html' { 'text/html; charset=utf-8' }
        '.css' { 'text/css; charset=utf-8' }
        '.js' { 'application/javascript; charset=utf-8' }
        '.json' { 'application/json; charset=utf-8' }
        '.png' { 'image/png' }
        '.jpg' { 'image/jpeg' }
        '.jpeg' { 'image/jpeg' }
        '.svg' { 'image/svg+xml' }
        default { 'application/octet-stream' }
    }

    $bytes = [System.IO.File]::ReadAllBytes($FilePath)
    $Response.StatusCode = 200
    $Response.ContentType = $contentType
    $Response.ContentLength64 = $bytes.Length
    Add-NoCacheHeaders -Response $Response
    $Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $Response.OutputStream.Close()
}

function Read-RequestJson {
    param([System.Net.HttpListenerRequest]$Request)

    $reader = [System.IO.StreamReader]::new($Request.InputStream, $Request.ContentEncoding)
    try {
        $raw = $reader.ReadToEnd()
    }
    finally {
        $reader.Close()
    }

    if ([string]::IsNullOrWhiteSpace($raw)) {
        return [pscustomobject]@{}
    }

    return $raw | ConvertFrom-Json
}

function Get-SliceRegistry {
    if (-not (Test-Path $frameworkConfigPath -PathType Leaf)) {
        return @()
    }

    return @(Get-Content -Raw -Encoding UTF8 $frameworkConfigPath | ConvertFrom-Json)
}

function Resolve-EntryScriptPath {
    param([string]$SliceId)

    if ([string]::IsNullOrWhiteSpace($SliceId)) {
        throw 'Missing sliceId.'
    }

    $slice = @(Get-SliceRegistry) | Where-Object { $_.id -eq $SliceId } | Select-Object -First 1
    if ($null -eq $slice) {
        throw "Unknown slice id: $SliceId"
    }

    $entryScriptPath = Join-Path $textGameRoot ([string]$slice.entryScript)
    if (-not (Test-Path $entryScriptPath -PathType Leaf)) {
        throw "Entry script not found: $entryScriptPath"
    }

    return $entryScriptPath
}

function Resolve-RoleStatus {
    param([string]$IdentityId)

    switch ([string]$IdentityId) {
        'wanderer' { return 'wanderer' }
        'displaced' { return 'displaced' }
        'local' { return 'local' }
        'follower' { return 'follower' }
        'apprentice' { return 'apprentice' }
        'oddjob' { return 'oddjob' }
        default { return 'local' }
    }
}

function Start-LocalSliceNewGame {
    param(
        [string]$SliceId,
        [string]$IdentityId,
        [string]$StartId,
        [string]$PlayerName,
        [string[]]$ScriptedInputs = @()
    )

    $entryScriptPath = Resolve-EntryScriptPath -SliceId $SliceId
    $roleStatus = Resolve-RoleStatus -IdentityId $IdentityId

    $argumentList = @(
        '-ExecutionPolicy', 'Bypass',
        '-File', $entryScriptPath,
        '-AutoNewGame',
        '-PresetRoleStatus', $roleStatus
    )

    if (-not [string]::IsNullOrWhiteSpace($StartId)) {
        $argumentList += @('-PresetStartPointId', $StartId)
    }

    if (-not [string]::IsNullOrWhiteSpace($PlayerName)) {
        $argumentList += @('-PresetPlayerName', $PlayerName)
    }

    if (@($ScriptedInputs).Count -gt 0) {
        $argumentList += '-ScriptedInputs'
        $argumentList += @($ScriptedInputs)
    }

    Start-Process -FilePath 'powershell.exe' -ArgumentList $argumentList -WorkingDirectory (Split-Path -Parent $entryScriptPath) | Out-Null
}

function Start-LocalSliceContinue {
    param(
        [string]$SliceId,
        [string]$SaveFileName,
        [string[]]$ScriptedInputs = @()
    )

    if ([string]::IsNullOrWhiteSpace($SaveFileName)) {
        throw 'Missing save file name.'
    }

    $entryScriptPath = Resolve-EntryScriptPath -SliceId $SliceId
    $argumentList = @(
        '-ExecutionPolicy', 'Bypass',
        '-File', $entryScriptPath,
        '-AutoLoadSave', ([System.IO.Path]::GetFileName($SaveFileName))
    )

    if (@($ScriptedInputs).Count -gt 0) {
        $argumentList += '-ScriptedInputs'
        $argumentList += @($ScriptedInputs)
    }

    Start-Process -FilePath 'powershell.exe' -ArgumentList $argumentList -WorkingDirectory (Split-Path -Parent $entryScriptPath) | Out-Null
}

function Handle-ApiRequest {
    param([System.Net.HttpListenerContext]$Context)

    $request = $Context.Request
    $response = $Context.Response
    $path = $request.Url.AbsolutePath

    switch ($path) {
        '/api/health' {
            Write-JsonResponse -Response $response -StatusCode 200 -Payload @{
                ok = $true
                status = 'ready'
                port = $Port
            }
            return
        }
        '/api/start' {
            $body = Read-RequestJson -Request $request

            Start-LocalSliceNewGame `
                -SliceId ([string]$body.sliceId) `
                -IdentityId ([string]$body.identityId) `
                -StartId ([string]$body.startId) `
                -PlayerName ([string]$body.playerName) `
                -ScriptedInputs @($body.scriptedInputs)

            Write-JsonResponse -Response $response -StatusCode 200 -Payload @{
                ok = $true
                message = 'Started a new local game window.'
            }
            return
        }
        '/api/continue' {
            $body = Read-RequestJson -Request $request

            Start-LocalSliceContinue `
                -SliceId ([string]$body.sliceId) `
                -SaveFileName ([string]$body.saveFileName) `
                -ScriptedInputs @($body.scriptedInputs)

            Write-JsonResponse -Response $response -StatusCode 200 -Payload @{
                ok = $true
                message = 'Loaded the selected local save in a new game window.'
            }
            return
        }
        default {
            Write-JsonResponse -Response $response -StatusCode 404 -Payload @{
                ok = $false
                message = "Unknown API path: $path"
            }
            return
        }
    }
}

function Handle-StaticRequest {
    param([System.Net.HttpListenerContext]$Context)

    $request = $Context.Request
    $response = $Context.Response

    $relativePath = $request.Url.AbsolutePath.TrimStart('/')
    if ([string]::IsNullOrWhiteSpace($relativePath)) {
        $relativePath = 'index.html'
    }

    $safeRelativePath = $relativePath.Replace('/', '\')
    $resolvedPath = [System.IO.Path]::GetFullPath((Join-Path $scriptRoot $safeRelativePath))
    if (-not $resolvedPath.StartsWith($scriptRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-JsonResponse -Response $response -StatusCode 403 -Payload @{
            ok = $false
            message = 'Path access denied.'
        }
        return
    }

    if (-not (Test-Path $resolvedPath -PathType Leaf)) {
        Write-JsonResponse -Response $response -StatusCode 404 -Payload @{
            ok = $false
            message = 'Resource not found.'
        }
        return
    }

    Write-FileResponse -Response $response -FilePath $resolvedPath
}

& $generatorPath

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($baseUrl)

try {
    $listener.Start()
}
catch {
    Write-Warning ("Failed to start local UI server at {0}. {1}" -f $baseUrl, $_.Exception.Message)
    return
}

Write-Host ''
Write-Host '=========================================' -ForegroundColor DarkCyan
Write-Host ' Elaris UI Shell Local Server Ready ' -ForegroundColor Cyan
Write-Host '=========================================' -ForegroundColor DarkCyan
Write-Host ("URL: {0}" -f $baseUrl) -ForegroundColor Green
Write-Host 'Press Ctrl+C to stop the local UI shell.' -ForegroundColor DarkGray

if ($shouldOpenBrowser) {
    $cacheBust = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    Start-Process ("{0}?v={1}" -f $baseUrl, $cacheBust) | Out-Null
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        try {
            if ($context.Request.Url.AbsolutePath.StartsWith('/api/', [System.StringComparison]::OrdinalIgnoreCase)) {
                Handle-ApiRequest -Context $context
            }
            else {
                Handle-StaticRequest -Context $context
            }
        }
        catch {
            if ($null -ne $context -and $null -ne $context.Response -and $context.Response.OutputStream.CanWrite) {
                Write-JsonResponse -Response $context.Response -StatusCode 500 -Payload @{
                    ok = $false
                    message = $_.Exception.Message
                    detail = $_.ScriptStackTrace
                }
            }
        }
    }
}
finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    $listener.Close()
}
