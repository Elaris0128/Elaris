Set-StrictMode -Version Latest

$script:ElarisInputQueue = $null
$script:ElarisScriptedMode = $false

function Initialize-ElarisInputQueue {
    param(
        [string[]]$ScriptedInputs = @()
    )

    $script:ElarisInputQueue = New-Object 'System.Collections.Generic.Queue[string]'
    foreach ($item in $ScriptedInputs) {
        $script:ElarisInputQueue.Enqueue([string]$item)
    }
    $script:ElarisScriptedMode = $ScriptedInputs.Count -gt 0
}

function Read-ElarisInput {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt
    )

    if ($script:ElarisScriptedMode -and $null -ne $script:ElarisInputQueue -and $script:ElarisInputQueue.Count -gt 0) {
        $value = $script:ElarisInputQueue.Dequeue()
        Write-Host ("{0}: {1}" -f $Prompt, $value)
        return [string]$value
    }

    return (Read-Host $Prompt)
}

function Pop-ElarisRemainingInputs {
    if ($null -eq $script:ElarisInputQueue -or $script:ElarisInputQueue.Count -eq 0) {
        return @()
    }

    $remaining = @()
    while ($script:ElarisInputQueue.Count -gt 0) {
        $remaining += [string]$script:ElarisInputQueue.Dequeue()
    }
    return $remaining
}

function Test-ElarisScriptedMode {
    return [bool]$script:ElarisScriptedMode
}

function Write-ElarisFrameworkBanner {
    Write-Host ''
    Write-Host '=========================================' -ForegroundColor DarkCyan
    Write-Host ' Elaris Text Game Framework' -ForegroundColor Cyan
    Write-Host '=========================================' -ForegroundColor DarkCyan
    Write-Host ''
}

function Read-ElarisMenuChoice {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [Parameter(Mandatory = $true)]
        [int]$Min,
        [Parameter(Mandatory = $true)]
        [int]$Max
    )

    while ($true) {
        $raw = (Read-ElarisInput -Prompt $Prompt).Trim()
        $parsed = 0
        if ([int]::TryParse($raw, [ref]$parsed) -and $parsed -ge $Min -and $parsed -le $Max) {
            return $parsed
        }
        Write-Host ("請輸入 {0} 到 {1} 之間的數字。" -f $Min, $Max) -ForegroundColor Yellow
    }
}

Export-ModuleMember -Function Initialize-ElarisInputQueue, Read-ElarisInput, Pop-ElarisRemainingInputs, Test-ElarisScriptedMode, Write-ElarisFrameworkBanner, Read-ElarisMenuChoice

