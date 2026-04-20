param(
    [string[]]$ScriptedInputs = @()
)

Set-StrictMode -Version Latest
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [Console]::OutputEncoding

$Script:TextGameRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$frameworkRoot = Join-Path $Script:TextGameRoot '06-framework'
$moduleRoot = Join-Path $frameworkRoot 'modules'

Import-Module (Join-Path $moduleRoot 'Elaris.TextGame.Common.psm1') -Force
Import-Module (Join-Path $moduleRoot 'Elaris.TextGame.Paths.psm1') -Force
Import-Module (Join-Path $moduleRoot 'Elaris.TextGame.RegionRegistry.psm1') -Force
Import-Module (Join-Path $moduleRoot 'Elaris.TextGame.SaveCatalog.psm1') -Force
Import-Module (Join-Path $moduleRoot 'Elaris.TextGame.Session.psm1') -Force

Initialize-ElarisFrameworkPaths -TextGameRoot $Script:TextGameRoot | Out-Null
Initialize-ElarisInputQueue -ScriptedInputs $ScriptedInputs
Start-ElarisLauncher -TextGameRoot $Script:TextGameRoot

