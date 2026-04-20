Set-StrictMode -Version Latest

function Get-ElarisFrameworkPaths {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot
    )

    $frameworkRoot = Join-Path $TextGameRoot '06-framework'

    return [ordered]@{
        TextGameRoot   = $TextGameRoot
        FrameworkRoot  = $frameworkRoot
        ConfigRoot     = Join-Path $frameworkRoot 'config'
        ModuleRoot     = Join-Path $frameworkRoot 'modules'
        RegistryPath   = Join-Path $frameworkRoot 'config\slices.registry.json'
        FrameworkSaves = Join-Path $frameworkRoot 'saves'
        PrototypeRoot  = Join-Path $TextGameRoot '05-prototypes'
    }
}

function Initialize-ElarisFrameworkPaths {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot
    )

    $paths = Get-ElarisFrameworkPaths -TextGameRoot $TextGameRoot
    foreach ($key in @('FrameworkRoot', 'ConfigRoot', 'ModuleRoot', 'FrameworkSaves')) {
        $target = [string]$paths[$key]
        if (-not (Test-Path -LiteralPath $target)) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        }
    }

    return $paths
}

Export-ModuleMember -Function Get-ElarisFrameworkPaths, Initialize-ElarisFrameworkPaths

