Set-StrictMode -Version Latest

function Get-ElarisSliceRegistry {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot
    )

    $paths = Get-ElarisFrameworkPaths -TextGameRoot $TextGameRoot
    if (-not (Test-Path -LiteralPath $paths.RegistryPath)) {
        throw "找不到切片註冊表：$($paths.RegistryPath)"
    }

    $raw = Get-Content -LiteralPath $paths.RegistryPath -Raw -Encoding UTF8
    $entries = @($raw | ConvertFrom-Json)
    $registry = @()

    foreach ($entry in $entries) {
        $registry += [pscustomobject]@{
            Id            = [string]$entry.id
            Title         = [string]$entry.title
            Subtitle      = [string]$entry.subtitle
            Status        = [string]$entry.status
            Progress      = [string]$entry.progress
            EntryScript   = Join-Path $TextGameRoot ([string]$entry.entryScript)
            SaveDirectory = if ($null -ne $entry.saveDirectory -and -not [string]::IsNullOrWhiteSpace([string]$entry.saveDirectory)) {
                Join-Path $TextGameRoot ([string]$entry.saveDirectory)
            }
            else {
                $null
            }
            Notes         = [string]$entry.notes
        }
    }

    return $registry
}

function Get-ElarisSliceById {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot,
        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    foreach ($slice in @(Get-ElarisSliceRegistry -TextGameRoot $TextGameRoot)) {
        if ([string]$slice.Id -eq $Id) {
            return $slice
        }
    }

    return $null
}

Export-ModuleMember -Function Get-ElarisSliceRegistry, Get-ElarisSliceById

