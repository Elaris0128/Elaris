Set-StrictMode -Version Latest
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [Console]::OutputEncoding

$uiRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$textGameRoot = Split-Path -Parent $uiRoot
$registryPath = Join-Path $textGameRoot '06-framework\config\slices.registry.json'
$regionPackRoot = Join-Path $textGameRoot '02-data\regions'
$outputPath = Join-Path $uiRoot 'generated-data.js'

function Convert-RegionPack {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$RegistryItem,
        [AllowNull()]
        [pscustomobject]$RegionPack
    )

    $starts = @()
    $blankSlateRoles = @()
    $starterQuestPool = @()
    $npcHooks = @()

    if ($null -ne $RegionPack) {
        foreach ($start in @($RegionPack.start_points)) {
            $starts += [ordered]@{
                id                    = $start.id
                title                 = $start.name
                note                  = $start.why_start_here
                whyStartHere          = $start.why_start_here
                pressureTags          = @($start.pressure_tags)
                linkedNpcIds          = @($start.linked_npcs)
                recommendedFirstQuest = $start.recommended_first_quest
            }
        }

        foreach ($role in @($RegionPack.blank_slate_roles)) {
            $blankSlateRoles += [ordered]@{
                status  = $role.status
                why     = $role.why
                bestFit = @($role.best_fit)
            }
        }

        foreach ($quest in @($RegionPack.starter_quest_pool)) {
            $steps = @()
            foreach ($step in @($quest.progress.steps)) {
                $steps += [ordered]@{
                    stepId         = $step.step_id
                    title          = $step.title
                    locationId     = $step.location_id
                    goalText       = $step.goal_text
                    advanceCommand = $step.advance_command
                }
            }

            $starterQuestPool += [ordered]@{
                questId       = $quest.quest_id
                title         = $quest.title
                entryPointId  = $quest.entry_point_id
                arc           = $quest.arc
                chapterTier   = $quest.chapter_tier
                coreConflict  = $quest.core_conflict
                decision      = $quest.decision
                progress      = [ordered]@{
                    steps      = $steps
                    completion = [ordered]@{
                        turnInLocationId = $quest.progress.completion.turn_in_location_id
                        turnInNpcId      = $quest.progress.completion.turn_in_npc_id
                    }
                }
            }
        }

        foreach ($npc in @($RegionPack.npc_hooks)) {
            $npcHooks += [ordered]@{
                id       = $npc.id
                name     = $npc.name
                role     = $npc.role
                introUse = $npc.intro_use
            }
        }
    }

    return [ordered]@{
        id               = $RegistryItem.id
        title            = $RegistryItem.title
        subtitle         = $RegistryItem.subtitle
        status           = $RegistryItem.status
        progress         = $RegistryItem.progress
        entryScript      = $RegistryItem.entryScript
        saveDirectory    = $RegistryItem.saveDirectory
        notes            = $RegistryItem.notes
        starts           = $starts
        blankSlateRoles  = $blankSlateRoles
        starterQuestPool = $starterQuestPool
        npcHooks         = $npcHooks
    }
}

function Find-RegionPackById {
    param(
        [Parameter(Mandatory)]
        [string]$RegionId
    )

    if (-not (Test-Path $regionPackRoot)) {
        return $null
    }

    foreach ($candidate in Get-ChildItem $regionPackRoot -Filter '*.json' -File) {
        try {
            $raw = Get-Content -Raw -Encoding UTF8 $candidate.FullName | ConvertFrom-Json
        }
        catch {
            continue
        }

        if ([string]$raw.region_id -eq $RegionId) {
            return $raw
        }
    }

    return $null
}

function Get-SaveSummary {
    param(
        [Parameter(Mandatory)]
        [string]$SavePath
    )

    try {
        $raw = Get-Content -Raw -Encoding UTF8 $SavePath | ConvertFrom-Json
    }
    catch {
        return $null
    }

    $activeQuest = $null
    if ($raw.quests.active_quests -and $raw.quests.active_quests.Count -gt 0) {
        $activeQuest = $raw.quests.active_quests[0]
    }

    $dayCount = if ($null -ne $raw.location.day_count) { $raw.location.day_count } else { 1 }
    $timeOfDay = if ($raw.location.time_of_day) { $raw.location.time_of_day } else { 'unknown' }
    $note = if ($activeQuest) { "Active: $($activeQuest.quest_id)" } else { 'No active quest' }

    return [ordered]@{
        id               = [System.IO.Path]::GetFileNameWithoutExtension($SavePath)
        title            = $raw.character.name
        slice            = if ($raw.location.current_region_id) { $raw.location.current_region_id } else { 'unknown' }
        location         = $raw.location.current_scene_name
        time             = "Day $dayCount / $timeOfDay"
        note             = $note
        currency         = $raw.inventory.currency
        identity         = $raw.character.blank_slate_status
        primaryDirection = $raw.character.job_direction_primary
        currentSceneId   = $raw.location.current_scene_id
        rawFileName      = [System.IO.Path]::GetFileName($SavePath)
        updatedAt        = $raw.updated_at
        character        = [ordered]@{
            name                  = $raw.character.name
            race                  = $raw.character.race
            branch                = $raw.character.branch
            originRegion          = $raw.character.origin_region
            blankSlateStatus      = $raw.character.blank_slate_status
            jobDirectionPrimary   = $raw.character.job_direction_primary
            jobDirectionSecondary = $raw.character.job_direction_secondary
            background            = $raw.character.background
        }
        locationState    = [ordered]@{
            currentRegionId = $raw.location.current_region_id
            currentSceneId  = $raw.location.current_scene_id
            currentSceneName = $raw.location.current_scene_name
            timeOfDay       = $raw.location.time_of_day
            dayCount        = $raw.location.day_count
        }
        inventory        = [ordered]@{
            currency       = $raw.inventory.currency
            equippedItems  = @($raw.inventory.equipped_items)
            inventorySlots = @($raw.inventory.inventory_slots)
            containers     = @($raw.inventory.containers)
        }
        activeQuest      = if ($null -ne $activeQuest) {
            [ordered]@{
                questId      = $activeQuest.quest_id
                status       = $activeQuest.status
                stepIndex    = $activeQuest.step_index
                progressLog  = $activeQuest.progress_log
                startedAt    = $activeQuest.started_at
                completedAt  = $activeQuest.completed_at
            }
        }
        else {
            $null
        }
        clues            = @($raw.notebook.known_clues)
        linkedNpcIds     = @($raw.runtime.linked_npcs)
        pressure         = @($raw.runtime.current_pressure_tags)
    }
}

$slices = @()
if (Test-Path $registryPath) {
    $registryItems = @(Get-Content -Raw -Encoding UTF8 $registryPath | ConvertFrom-Json)
    foreach ($item in $registryItems) {
        $pack = Find-RegionPackById -RegionId ([string]$item.id)
        $slices += (Convert-RegionPack -RegistryItem $item -RegionPack $pack)
    }
}

$saveFiles = Get-ChildItem $textGameRoot -Recurse -Filter '*save*.json' -File |
    Sort-Object LastWriteTime -Descending

$saves = @()
foreach ($saveFile in $saveFiles) {
    $summary = Get-SaveSummary -SavePath $saveFile.FullName
    if ($null -ne $summary) {
        $saves += $summary
    }
}

$payload = [ordered]@{
    generated_at = (Get-Date).ToString('o')
    slices       = $slices
    saves        = $saves
}

$json = $payload | ConvertTo-Json -Depth 10
$content = "window.elarisRuntimeData = $json;"
[System.IO.File]::WriteAllText($outputPath, $content, (New-Object System.Text.UTF8Encoding($true)))
