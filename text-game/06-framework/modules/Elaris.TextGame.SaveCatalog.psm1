Set-StrictMode -Version Latest

function Get-ElarisSaveCatalog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot
    )

    $saveFiles = @(Get-ChildItem -Path $TextGameRoot -Recurse -Filter '*-save.json' -File -ErrorAction SilentlyContinue)
    $catalog = @()

    foreach ($file in $saveFiles) {
        $record = $null
        try {
            $raw = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
            $record = $raw | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            $catalog += [pscustomobject]@{
                SaveName    = $file.Name
                Character   = '(無法讀取)'
                Slice       = '(未知)'
                Location    = '(未知)'
                UpdatedAt   = $file.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
                FullPath    = $file.FullName
                Readable    = $false
            }
            continue
        }

        $slice = '(未知)'
        if ($null -ne $record.location -and $null -ne $record.location.current_region_id) {
            $slice = [string]$record.location.current_region_id
        }

        $character = '(未命名)'
        if ($null -ne $record.character -and $null -ne $record.character.name) {
            $character = [string]$record.character.name
        }

        $location = '(未知)'
        if ($null -ne $record.location -and $null -ne $record.location.current_scene_id) {
            $location = [string]$record.location.current_scene_id
        }

        $updatedAt = if ($null -ne $record.updated_at -and -not [string]::IsNullOrWhiteSpace([string]$record.updated_at)) {
            [string]$record.updated_at
        }
        else {
            $file.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
        }

        $catalog += [pscustomobject]@{
            SaveName  = $file.Name
            Character = $character
            Slice     = $slice
            Location  = $location
            UpdatedAt = $updatedAt
            FullPath  = $file.FullName
            Readable  = $true
        }
    }

    return $catalog | Sort-Object UpdatedAt -Descending
}

function Show-ElarisSaveCatalog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot
    )

    $catalog = @(Get-ElarisSaveCatalog -TextGameRoot $TextGameRoot)

    Write-Host ''
    Write-Host '--- 存檔總覽 ---' -ForegroundColor Cyan

    if ($catalog.Count -eq 0) {
        Write-Host '目前還沒有找到任何存檔。' -ForegroundColor Yellow
        return
    }

    $index = 1
    foreach ($entry in $catalog) {
        Write-Host ("{0}. {1}" -f $index, $entry.SaveName) -ForegroundColor Green
        Write-Host ("   角色：{0}" -f $entry.Character) -ForegroundColor DarkCyan
        Write-Host ("   區域：{0}" -f $entry.Slice) -ForegroundColor DarkCyan
        Write-Host ("   位置：{0}" -f $entry.Location) -ForegroundColor DarkCyan
        Write-Host ("   更新：{0}" -f $entry.UpdatedAt) -ForegroundColor DarkGray
        Write-Host ("   檔案：{0}" -f $entry.FullPath) -ForegroundColor DarkGray
        if (-not $entry.Readable) {
            Write-Host '   狀態：這份存檔目前無法正常讀取。' -ForegroundColor Yellow
        }
        $index++
    }
}

Export-ModuleMember -Function Get-ElarisSaveCatalog, Show-ElarisSaveCatalog

