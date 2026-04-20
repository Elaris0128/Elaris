Set-StrictMode -Version Latest

function Show-ElarisFrameworkStatus {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot
    )

    $slices = @(Get-ElarisSliceRegistry -TextGameRoot $TextGameRoot)

    Write-Host ''
    Write-Host '--- 框架狀態 ---' -ForegroundColor Cyan
    Write-Host ("根目錄：{0}" -f $TextGameRoot)
    Write-Host ("目前已註冊切片：{0}" -f $slices.Count) -ForegroundColor DarkCyan
    Write-Host ''

    foreach ($slice in $slices) {
        Write-Host ("- {0}：{1}" -f $slice.Title, $slice.Subtitle) -ForegroundColor Green
        Write-Host ("  狀態：{0} / 進度：{1}" -f $slice.Status, $slice.Progress) -ForegroundColor DarkCyan
        if ($null -ne $slice.SaveDirectory) {
            Write-Host ("  存檔目錄：{0}" -f $slice.SaveDirectory) -ForegroundColor DarkGray
        }
        Write-Host ("  說明：{0}" -f $slice.Notes) -ForegroundColor DarkGray
    }

    Write-Host ''
    Write-Host '這個入口目前先負責：選切片、啟動切片、查看存檔，並替之後多區域整合留位置。' -ForegroundColor DarkGray
}

function Start-ElarisSlice {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot,
        [Parameter(Mandatory = $true)]
        [psobject]$Slice
    )

    if (-not (Test-Path -LiteralPath $Slice.EntryScript)) {
        Write-Host ("找不到切片腳本：{0}" -f $Slice.EntryScript) -ForegroundColor Red
        return
    }

    Write-Host ''
    Write-Host ("--- 進入 {0} ---" -f $Slice.Title) -ForegroundColor Cyan
    Write-Host $Slice.Notes -ForegroundColor DarkGray
    if ($null -ne $Slice.SaveDirectory) {
        Write-Host ("這個切片的存檔目前會寫在：{0}" -f $Slice.SaveDirectory) -ForegroundColor DarkGray
    }
    Write-Host ''

    $remainingInputs = @(Pop-ElarisRemainingInputs)
    if ($remainingInputs.Count -gt 0) {
        & $Slice.EntryScript -ScriptedInputs $remainingInputs
    }
    else {
        & $Slice.EntryScript
    }
}

function Start-ElarisLauncher {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TextGameRoot
    )

    while ($true) {
        $slices = @(Get-ElarisSliceRegistry -TextGameRoot $TextGameRoot)
        Write-ElarisFrameworkBanner
        Write-Host '目前可進入的切片：' -ForegroundColor Cyan

        $indexMap = @{}
        $index = 1
        foreach ($slice in $slices) {
            Write-Host ("{0}. {1} - {2}" -f $index, $slice.Title, $slice.Subtitle)
            $indexMap[$index] = $slice
            $index++
        }

        $statusIndex = $index
        Write-Host ("{0}. 查看框架狀態" -f $statusIndex)
        $saveIndex = $statusIndex + 1
        Write-Host ("{0}. 查看存檔總覽" -f $saveIndex)
        $exitIndex = $saveIndex + 1
        Write-Host ("{0}. 離開" -f $exitIndex)

        $choice = Read-ElarisMenuChoice -Prompt '請選擇功能編號' -Min 1 -Max $exitIndex

        if ($choice -eq $statusIndex) {
            Show-ElarisFrameworkStatus -TextGameRoot $TextGameRoot
            continue
        }

        if ($choice -eq $saveIndex) {
            Show-ElarisSaveCatalog -TextGameRoot $TextGameRoot
            continue
        }

        if ($choice -eq $exitIndex) {
            Write-Host '結束 Elaris 文字遊戲框架。' -ForegroundColor Cyan
            return
        }

        Start-ElarisSlice -TextGameRoot $TextGameRoot -Slice $indexMap[$choice]
        if (Test-ElarisScriptedMode) {
            return
        }
    }
}

Export-ModuleMember -Function Show-ElarisFrameworkStatus, Start-ElarisSlice, Start-ElarisLauncher

