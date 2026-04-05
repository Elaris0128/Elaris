param(
    [string[]]$ScriptedInputs = @()
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [Console]::OutputEncoding

$Script:PrototypeRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:ProjectRoot = Split-Path -Parent (Split-Path -Parent $Script:PrototypeRoot)
$Script:RegionPackPath = Join-Path $Script:ProjectRoot 'text-game\02-data\regions\whispersea-region-pack-v1.json'
$Script:SaveDirectory = Join-Path $Script:PrototypeRoot 'saves'
$Script:InputQueue = New-Object 'System.Collections.Generic.Queue[string]'
$Script:ScriptedMode = $ScriptedInputs.Count -gt 0
$Script:TimeCycle = @('night', 'dawn', 'day', 'dusk')
$Script:EncounterProfiles = @{
    'social-anomaly' = [ordered]@{
        title = '霧邊低歌'
        category = 'social'
        options = @(
            [ordered]@{
                key = 'observe'
                title = '先停下來觀察'
                result_text = '你先壓住動作，任海霧和低低的潮歌從耳邊擦過。很快你就聽出來，那不是單純的怪聲，而是有人在用半斷的舊歌確認來者懂不懂這片水路的規矩。'
                clues = @('霧邊低歌常被用來試探來者是否懂潮路規矩')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('採樣短工')
                pressure_tags = @('霧歌餘響')
            },
            [ordered]@{
                key = 'approach'
                title = '靠近並開口搭話'
                result_text = '你沒有把場面往壞處想，而是先照著本地人的節奏報上來意。霧裡的人聲沒有立刻親近你，但至少不再把你當成亂闖的人，還反手塞來一點潮路消息。'
                clues = @('幽語海的陌生接觸常靠歌句和語序辨認敵我')
                currency = 2
                items = @()
                reputation_track = 'whispersea-local'
                reputation_delta = 1
                job_directions = @('引路見習')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'withdraw'
                title = '先退一步保命'
                result_text = '你沒有逞強，先讓自己脫離那團不對勁的霧。你失去了一次接觸的機會，但也沒有把自己硬塞進不確定的局裡。'
                clues = @('有些海霧裡的聲音不是給白身硬接的')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('錯過一次霧邊接觸')
            }
        )
    }
    'monster-blockage' = [ordered]@{
        title = '海獸阻路'
        category = 'danger'
        options = @(
            [ordered]@{
                key = 'detour'
                title = '先找繞行線'
                result_text = '你不和那團不安分的影子硬頂，而是貼著較淺的回流邊找到一條勉強能過的替代線。慢是慢了些，但至少人和貨都還在。'
                clues = @('幽語海很多阻路海獸都有可避讓的側線')
                currency = 0
                items = @()
                reputation_track = 'whispersea-route'
                reputation_delta = 1
                job_directions = @('引水見習')
                pressure_tags = @('行程延後')
            },
            [ordered]@{
                key = 'drive'
                title = '試著驅離'
                result_text = '你舉燈、敲繩、用最笨但也最直接的法子把那頭攔路的東西逼開。場面很狼狽，但總算替後面的人搶出一小段能用的窗口。'
                clues = @('高聲與燈影在近岸海獸面前比武器更常派上用場')
                currency = 4
                items = @()
                reputation_track = 'whispersea-watch'
                reputation_delta = 1
                job_directions = @('夜巡短工')
                pressure_tags = @('手臂發麻')
            },
            [ordered]@{
                key = 'retreat'
                title = '後撤保線'
                result_text = '你沒有賭那一瞬的勇氣，而是先把人和物往後帶，留下明確的避讓標記。這次沒賺到什麼，但也沒有把局勢變成事故。'
                clues = @('保線和保命有時比硬過去更重要')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('岬哨候補')
                pressure_tags = @('退讓記號')
            }
        )
    }
    'ambush' = [ordered]@{
        title = '霧中試探'
        category = 'danger'
        options = @(
            [ordered]@{
                key = 'hide'
                title = '先壓低身形藏住'
                result_text = '你沒有急著動，而是先把自己的呼吸藏到潮聲後面。那幾道試探的影子晃過去時，並沒有真抓到你的準位置，反而讓你摸清了他們是從哪邊來的。'
                clues = @('霧中包夾常先試聲，不先露位就還有轉圜')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('夜巡短工')
                pressure_tags = @('心跳未平')
            },
            [ordered]@{
                key = 'callout'
                title = '先出聲壓住對方'
                result_text = '你先一步喝出聲，逼對方意識到這裡不是完全無人的暗口。那幾道影子沒有戀戰，只留下一句試探意味很重的話就退了。'
                clues = @('有些伏影不是來殺人，而是來試誰敢站線')
                currency = 3
                items = @()
                reputation_track = 'whispersea-watch'
                reputation_delta = 1
                job_directions = @('岬哨候補')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'breakaway'
                title = '趁亂抽身離開'
                result_text = '你沒有跟那幾道影子糾纏，抓準一個浪頭就抽身離開。這讓你少聽到一些內情，但也保住了接下來還能繼續跑事的本錢。'
                clues = @('霧裡的試探往往比真正動手更常見')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('留了個背影給對方')
            }
        )
    }
    'grayline-pressure' = [ordered]@{
        title = '灰線施壓'
        category = 'social'
        options = @(
            [ordered]@{
                key = 'stall'
                title = '先拖字句，不立刻表態'
                result_text = '你沒有正面答應，也沒有把話說死，只把對方的條件記進心裡，再把自己從那條灰線的嘴上慢慢抽開。對方不滿，但也知道你不是完全沒腦子。'
                clues = @('灰線買手最常測的是白身會不會為小利直接鬆口')
                currency = 1
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('引路見習')
                pressure_tags = @('灰線記住了你的臉')
            },
            [ordered]@{
                key = 'refuse'
                title = '直接拒絕'
                result_text = '你把話說得夠硬，讓對方知道這件事今天在你身上過不了。這不會讓灰線喜歡你，但至少守線的人會知道你沒有亂開口子。'
                clues = @('灰線會記仇，但地方守線也會記得你有沒有守住底線')
                currency = 0
                items = @()
                reputation_track = 'whispersea-local'
                reputation_delta = 1
                job_directions = @('守誓學徒')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'trade'
                title = '只換不碰底線'
                result_text = '你沒有讓對方碰真正要命的東西，只用一點邊角消息換到自己眼下用得上的補給。這筆買賣不乾淨，但還沒壞到不可收拾。'
                clues = @('灰線往往先用小換小，慢慢試你能退到哪')
                currency = 3
                items = @('灰線乾鹽包')
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('採樣短工')
                pressure_tags = @('灰線欠條')
            }
        )
    }
    'inspection' = [ordered]@{
        title = '水路查驗'
        category = 'social'
        options = @(
            [ordered]@{
                key = 'cooperate'
                title = '照規矩配合查驗'
                result_text = '你老老實實把身上的東西攤開，讓查驗的人一件件過。過程不舒服，但也因此少了很多猜忌，對方最後還順手提醒了你這一帶最近的禁線。'
                clues = @('配合查驗雖然慢，卻能換到更穩的地方信任')
                currency = 0
                items = @()
                reputation_track = 'whispersea-local'
                reputation_delta = 1
                job_directions = @('守誓學徒')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'explain'
                title = '主動把來意講清楚'
                result_text = '你不是只把東西掏出來，而是把自己為什麼在這裡、接的是哪條事也講明白。對方不見得完全信你，但至少知道你不是憑空冒出來的影子。'
                clues = @('在水路查驗裡，說得清自己站在哪條線上，本身就是一種本事')
                currency = 2
                items = @()
                reputation_track = 'whispersea-route'
                reputation_delta = 1
                job_directions = @('引水見習')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'slip'
                title = '找縫先溜'
                result_text = '你在查驗線真正收緊前先滑了出去。這讓你保住了時間，但也讓某些人對你的臉和步子多留了心。'
                clues = @('躲過查驗不一定等於安全，只是把問題往後推')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('查驗名單上多了一筆未明記號')
            }
        )
    }
}

foreach ($scripted in $ScriptedInputs) {
    $Script:InputQueue.Enqueue([string]$scripted)
}

function Read-GameInput {
    param([string]$Prompt)

    if ($Script:InputQueue.Count -gt 0) {
        $value = $Script:InputQueue.Dequeue()
        Write-Host ("{0}: {1}" -f $Prompt, $value) -ForegroundColor DarkGray
        return $value
    }

    return Read-Host $Prompt
}

function Ensure-SaveDirectory {
    if (-not (Test-Path $Script:SaveDirectory)) {
        New-Item -ItemType Directory -Force -Path $Script:SaveDirectory | Out-Null
    }
}

function ConvertTo-Hashtable {
    param([Parameter(ValueFromPipeline = $true)]$InputObject)

    if ($null -eq $InputObject) {
        return $null
    }

    if ($InputObject -is [System.Collections.IDictionary]) {
        $hash = [ordered]@{}
        foreach ($key in $InputObject.Keys) {
            $hash[$key] = ConvertTo-Hashtable -InputObject $InputObject[$key]
        }
        return $hash
    }

    if ($InputObject -is [pscustomobject]) {
        $hash = [ordered]@{}
        foreach ($property in $InputObject.PSObject.Properties) {
            $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
        }
        return $hash
    }

    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $collection = @()
        foreach ($item in $InputObject) {
            $collection += ConvertTo-Hashtable -InputObject $item
        }
        return $collection
    }

    return $InputObject
}

function Load-RegionPack {
    if (-not (Test-Path $Script:RegionPackPath)) {
        throw "找不到幽語海 region pack：$Script:RegionPackPath"
    }

    return Get-Content -Raw -Encoding utf8 $Script:RegionPackPath | ConvertFrom-Json
}

function Show-Title {
    Write-Host ''
    Write-Host '=========================================' -ForegroundColor DarkCyan
    Write-Host ' Elaris CLI Prototype - 幽語海白身開局 ' -ForegroundColor Cyan
    Write-Host '=========================================' -ForegroundColor DarkCyan
    Write-Host ''
}

function Show-Menu {
    Write-Host '1. 新遊戲'
    Write-Host '2. 讀取存檔'
    Write-Host '3. 離開'
}

function Read-Choice {
    param(
        [string]$Prompt,
        [int]$Min,
        [int]$Max
    )

    while ($true) {
        $raw = Read-GameInput $Prompt
        $number = 0
        if ([int]::TryParse($raw, [ref]$number) -and $number -ge $Min -and $number -le $Max) {
            return $number
        }
        Write-Host "請輸入 $Min 到 $Max 之間的數字。" -ForegroundColor Yellow
    }
}

function Add-UniqueString {
    param(
        [object[]]$Collection,
        [string]$Value
    )

    $base = @($Collection)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $base
    }
    if ($base -contains $Value) {
        return $base
    }
    return @($base + $Value)
}

function Add-UniqueStrings {
    param(
        [object[]]$Collection,
        [object[]]$Values
    )

    $result = @($Collection)
    foreach ($value in @($Values)) {
        $result = Add-UniqueString -Collection $result -Value ([string]$value)
    }
    return $result
}

function Add-ReputationDelta {
    param(
        [hashtable]$GameState,
        [string]$TrackId,
        [int]$Delta
    )

    if ([string]::IsNullOrWhiteSpace($TrackId) -or $Delta -eq 0) {
        return
    }

    $existingValue = 0
    if ($GameState.reputation.tracks.Contains($TrackId)) {
        $existingValue = [int]$GameState.reputation.tracks[$TrackId]
    }
    $GameState.reputation.tracks[$TrackId] = $existingValue + $Delta
}

function Get-EncounterProfile {
    param([string]$Type)

    if ($Script:EncounterProfiles.Contains($Type)) {
        return $Script:EncounterProfiles[$Type]
    }

    return [ordered]@{
        title = '未分類遭遇'
        category = 'unknown'
        options = @(
            [ordered]@{
                key = 'withdraw'
                title = '先退一步保命'
                result_text = '你先讓自己從不明局勢裡抽身，至少沒有把事情變得更糟。'
                clues = @()
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('遇到未分類風險')
            }
        )
    }
}

function Get-ActiveEncounter {
    param([hashtable]$GameState)

    if ($null -eq $GameState.runtime.active_encounter) {
        return $null
    }

    if ([string]::IsNullOrWhiteSpace([string]$GameState.runtime.active_encounter.type)) {
        return $null
    }

    return $GameState.runtime.active_encounter
}

function Ensure-NoActiveEncounter {
    param(
        [hashtable]$GameState,
        [string]$ActionLabel
    )

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -eq $activeEncounter) {
        return $true
    }

    Write-Host ("你眼前還有一個遭遇沒有處理完：{0}。先用 respond <number> 做出選擇，再來{1}。" -f $activeEncounter.title, $ActionLabel) -ForegroundColor Yellow
    return $false
}

function Get-StartPointById {
    param(
        [object]$RegionPack,
        [string]$PointId
    )

    return $RegionPack.start_points | Where-Object { $_.id -eq $PointId } | Select-Object -First 1
}

function Get-QuestById {
    param(
        [object]$RegionPack,
        [string]$QuestId
    )

    return $RegionPack.starter_quest_pool | Where-Object { $_.quest_id -eq $QuestId } | Select-Object -First 1
}

function Get-NpcById {
    param(
        [object]$RegionPack,
        [string]$NpcId
    )

    return $RegionPack.npc_hooks | Where-Object { $_.id -eq $NpcId } | Select-Object -First 1
}

function Get-ActiveQuestRecord {
    param([hashtable]$GameState)

    foreach ($record in @($GameState.quests.active_quests)) {
        if ($record.status -eq 'active' -or $record.status -eq 'ready_to_turn_in') {
            return $record
        }
    }

    return $null
}

function Get-ActiveQuestDefinition {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        return $null
    }

    return Get-QuestById -RegionPack $RegionPack -QuestId $record.quest_id
}

function Get-CurrentQuestStep {
    param(
        [hashtable]$QuestRecord,
        [object]$QuestDefinition
    )

    if ($null -eq $QuestRecord -or $null -eq $QuestDefinition) {
        return $null
    }

    if ($QuestRecord.status -ne 'active') {
        return $null
    }

    $steps = @($QuestDefinition.progress.steps)
    if ($QuestRecord.step_index -lt 0 -or $QuestRecord.step_index -ge $steps.Count) {
        return $null
    }

    return $steps[$QuestRecord.step_index]
}

function Get-TrackedQuestIds {
    param([hashtable]$GameState)

    $ids = @()
    foreach ($record in @($GameState.quests.active_quests)) {
        $ids += [string]$record.quest_id
    }
    foreach ($record in @($GameState.quests.completed_quests)) {
        $ids += [string]$record.quest_id
    }
    foreach ($record in @($GameState.quests.failed_quests)) {
        $ids += [string]$record.quest_id
    }
    return ,@($ids | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
}

function Get-AvailableQuestsForCurrentScene {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $tracked = Get-TrackedQuestIds -GameState $GameState
    $sceneId = [string]$GameState.location.current_scene_id
    $available = @()
    foreach ($quest in @($RegionPack.starter_quest_pool)) {
        if ($quest.entry_point_id -eq $sceneId -and -not ($tracked -contains [string]$quest.quest_id)) {
            $available += $quest
        }
    }
    return ,@($available)
}

function New-QuestRecord {
    param([string]$QuestId)

    return [ordered]@{
        quest_id = $QuestId
        status = 'active'
        step_index = 0
        progress_log = @()
        started_at = (Get-Date).ToString('o')
        completed_at = $null
    }
}

function Select-BlankSlateRole {
    param([object]$RegionPack)

    Write-Host ''
    Write-Host '選擇你的白身狀態：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $RegionPack.blank_slate_roles.Count; $i++) {
        $role = $RegionPack.blank_slate_roles[$i]
        Write-Host ("{0}. {1} - {2}" -f ($i + 1), $role.status, $role.why)
    }

    $selectedIndex = Read-Choice -Prompt '請選擇白身狀態編號' -Min 1 -Max $RegionPack.blank_slate_roles.Count
    return $RegionPack.blank_slate_roles[$selectedIndex - 1]
}

function Select-StartPoint {
    param([object]$RegionPack)

    Write-Host ''
    Write-Host '選擇你的起始落點：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $RegionPack.start_points.Count; $i++) {
        $point = $RegionPack.start_points[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $point.name)
        Write-Host ("   {0}" -f $point.why_start_here) -ForegroundColor DarkGray
    }

    $selectedIndex = Read-Choice -Prompt '請選擇起始落點編號' -Min 1 -Max $RegionPack.start_points.Count
    return $RegionPack.start_points[$selectedIndex - 1]
}

function Advance-TimeState {
    param(
        [hashtable]$GameState,
        [int]$Steps = 1
    )

    for ($i = 0; $i -lt $Steps; $i++) {
        $currentIndex = [array]::IndexOf($Script:TimeCycle, $GameState.location.time_of_day)
        if ($currentIndex -lt 0) {
            $currentIndex = 0
        }
        $nextIndex = ($currentIndex + 1) % $Script:TimeCycle.Count
        if ($nextIndex -eq 0) {
            $GameState.location.day_count += 1
        }
        $GameState.location.time_of_day = $Script:TimeCycle[$nextIndex]
    }
}

function New-GameState {
    param([object]$RegionPack)

    $name = Read-GameInput '角色名字（留空則使用「無名潮客」）'
    if ([string]::IsNullOrWhiteSpace($name)) {
        $name = '無名潮客'
    }

    $role = Select-BlankSlateRole -RegionPack $RegionPack
    $startPoint = Select-StartPoint -RegionPack $RegionPack
    $quest = Get-QuestById -RegionPack $RegionPack -QuestId $startPoint.recommended_first_quest

    $timestamp = Get-Date
    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars() + ' '
    $safeName = -join ($name.ToCharArray() | ForEach-Object {
        if ($invalidChars -contains $_) { '_' } else { $_ }
    })

    return [ordered]@{
        save_version = 'v2'
        created_at = $timestamp.ToString('o')
        updated_at = $timestamp.ToString('o')
        playtime_minutes = 0
        seed = ('whispersea-{0}' -f $startPoint.id)
        character = [ordered]@{
            name = $name
            race = '諾魯因人'
            branch = $null
            origin_region = 'whispersea'
            blank_slate_status = $role.status
            job_direction_primary = '未定'
            job_direction_secondary = '未定'
            traits = @()
            flaws = @()
            background = '白身開局'
        }
        location = [ordered]@{
            current_region_id = 'whispersea'
            current_scene_id = $startPoint.id
            current_scene_name = $startPoint.name
            time_of_day = 'night'
            day_count = 1
        }
        quests = [ordered]@{
            active_quests = @((New-QuestRecord -QuestId $quest.quest_id))
            completed_quests = @()
            failed_quests = @()
        }
        notebook = [ordered]@{
            known_clues = @()
            revealed_truths = @()
        }
        reputation = [ordered]@{
            region = 'neutral'
            factions = @{}
            tracks = @{}
        }
        inventory = [ordered]@{
            currency = 10
            equipped_items = @()
            inventory_slots = @('封聲袋', '短窗照燈', '簡索繩')
            containers = @('潮布肩包')
        }
        runtime = [ordered]@{
            current_pressure_tags = @($startPoint.pressure_tags)
            linked_npcs = @($startPoint.linked_npcs)
            save_name = ('{0}-whispersea-save.json' -f $safeName)
            learned_job_directions = @()
            active_encounter = $null
        }
    }
}

function Normalize-GameState {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if (-not $GameState.save_version) {
        $GameState.save_version = 'v2'
    }

    if (-not $GameState.reputation.tracks) {
        $GameState.reputation.tracks = @{}
    }

    if (-not $GameState.runtime.learned_job_directions) {
        $GameState.runtime.learned_job_directions = @()
    }

    if (-not $GameState.runtime.Contains('active_encounter')) {
        $GameState.runtime.active_encounter = $null
    }
    elseif ($null -ne $GameState.runtime.active_encounter -and $GameState.runtime.active_encounter.options) {
        $GameState.runtime.active_encounter.options = @($GameState.runtime.active_encounter.options)
    }

    if ($GameState.quests.active_quests -is [System.Collections.IDictionary]) {
        $GameState.quests.active_quests = @($GameState.quests.active_quests)
    }
    else {
        $GameState.quests.active_quests = @($GameState.quests.active_quests)
    }

    if ($GameState.quests.completed_quests -is [System.Collections.IDictionary]) {
        $GameState.quests.completed_quests = @($GameState.quests.completed_quests)
    }
    else {
        $GameState.quests.completed_quests = @($GameState.quests.completed_quests)
    }

    if ($GameState.quests.failed_quests -is [System.Collections.IDictionary]) {
        $GameState.quests.failed_quests = @($GameState.quests.failed_quests)
    }
    else {
        $GameState.quests.failed_quests = @($GameState.quests.failed_quests)
    }

    if ($GameState.quests.active_quests.Count -gt 0 -and $GameState.quests.active_quests[0] -is [string]) {
        $newRecords = @()
        foreach ($questId in @($GameState.quests.active_quests)) {
            $newRecords += New-QuestRecord -QuestId ([string]$questId)
        }
        $GameState.quests.active_quests = $newRecords
    }

    foreach ($record in @($GameState.quests.active_quests)) {
        if (-not $record.progress_log) {
            $record.progress_log = @()
        }
        elseif ($record.progress_log -is [string]) {
            $record.progress_log = @([string]$record.progress_log)
        }
    }

    return $GameState
}

function Save-GameState {
    param([hashtable]$GameState)

    Ensure-SaveDirectory
    $GameState.updated_at = (Get-Date).ToString('o')
    $savePath = Join-Path $Script:SaveDirectory $GameState.runtime.save_name
    $GameState | ConvertTo-Json -Depth 20 | Set-Content -Encoding utf8 $savePath
    Write-Host ("已存檔：{0}" -f $savePath) -ForegroundColor Green
}

function Load-GameState {
    param([object]$RegionPack)

    Ensure-SaveDirectory
    $saveFiles = Get-ChildItem $Script:SaveDirectory -Filter '*.json' | Sort-Object LastWriteTime -Descending

    if (-not $saveFiles) {
        Write-Host '目前沒有可讀取的存檔。' -ForegroundColor Yellow
        return $null
    }

    Write-Host ''
    Write-Host '可讀取存檔：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $saveFiles.Count; $i++) {
        $file = $saveFiles[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $file.Name)
    }

    $selectedIndex = Read-Choice -Prompt '請選擇存檔編號' -Min 1 -Max $saveFiles.Count
    $selectedFile = $saveFiles[$selectedIndex - 1]
    $loaded = Get-Content -Raw -Encoding utf8 $selectedFile.FullName | ConvertFrom-Json
    $state = ConvertTo-Hashtable -InputObject $loaded
    return Normalize-GameState -GameState $state -RegionPack $RegionPack
}

function Show-Opening {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $scene = Get-StartPointById -RegionPack $RegionPack -PointId $GameState.location.current_scene_id
    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack

    Write-Host ''
    Write-Host '--- 開場 ---' -ForegroundColor Cyan
    Write-Host ("你在 {0} 醒來。" -f $scene.name)
    Write-Host $scene.why_start_here
    Write-Host ("你現在的身分是：{0}" -f $GameState.character.blank_slate_status)
    if ($null -ne $quest) {
        Write-Host ("你眼前第一個最明確的麻煩是：{0}" -f $quest.core_conflict)
        Write-Host ("目前掛在你身上的任務：{0}" -f $quest.title) -ForegroundColor Yellow
    }
    Write-Host ''
}

function Show-Status {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 狀態 ---' -ForegroundColor Cyan
    Write-Host ("角色：{0}" -f $GameState.character.name)
    Write-Host ("種族：{0}" -f $GameState.character.race)
    Write-Host ("白身狀態：{0}" -f $GameState.character.blank_slate_status)
    Write-Host ("地區：{0}" -f $RegionPack.display_name)
    Write-Host ("位置：{0}" -f $GameState.location.current_scene_name)
    Write-Host ("第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day)
    Write-Host ("身上物資：{0}" -f ($GameState.inventory.inventory_slots -join '、'))
    Write-Host ("現金：{0}" -f $GameState.inventory.currency)
    if ($GameState.runtime.learned_job_directions.Count -gt 0) {
        Write-Host ("已開出的職業方向：{0}" -f ($GameState.runtime.learned_job_directions -join '、')) -ForegroundColor DarkCyan
    }
    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -ne $activeEncounter) {
        Write-Host ("目前遭遇：{0}（{1}）" -f $activeEncounter.title, $activeEncounter.category) -ForegroundColor Yellow
    }
    if ($GameState.notebook.known_clues.Count -gt 0) {
        Write-Host ("已知線索：{0}" -f ($GameState.notebook.known_clues -join '；')) -ForegroundColor DarkGray
    }
    Write-Host ("完成任務數：{0}" -f @($GameState.quests.completed_quests).Count) -ForegroundColor DarkGray
}

function Show-Quest {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host ''
        Write-Host '目前沒有進行中的任務。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    $keyNpcNames = @()
    foreach ($npcId in @($quest.key_npcs)) {
        $npc = Get-NpcById -RegionPack $RegionPack -NpcId ([string]$npcId)
        if ($null -ne $npc) {
            $keyNpcNames += $npc.name
        }
        else {
            $keyNpcNames += [string]$npcId
        }
    }
    Write-Host ''
    Write-Host '--- 任務 ---' -ForegroundColor Cyan
    Write-Host ("任務：{0}" -f $quest.title) -ForegroundColor Yellow
    Write-Host ("衝突：{0}" -f $quest.core_conflict)
    Write-Host ("抉擇：{0}" -f $quest.decision)
    Write-Host ("關鍵人物：{0}" -f ($keyNpcNames -join '、'))

    if ($record.status -eq 'ready_to_turn_in') {
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $quest.progress.completion.turn_in_location_id
        $turnInNpc = Get-NpcById -RegionPack $RegionPack -NpcId $quest.progress.completion.turn_in_npc_id
        Write-Host ''
        Write-Host '你已經完成調查，現在可以交付任務。' -ForegroundColor Green
        Write-Host ("交付地點：{0}" -f $turnInPoint.name)
        Write-Host ("交付對象：{0}" -f $turnInNpc.name)
        Write-Host ("可得報酬：{0} 現金、{1}" -f $quest.progress.completion.rewards.currency, ($quest.progress.completion.rewards.items -join '、'))
        return
    }

    $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
    $stepPoint = Get-StartPointById -RegionPack $RegionPack -PointId $step.location_id
    Write-Host ''
    Write-Host ("目前進度：第 {0}/{1} 步 - {2}" -f ($record.step_index + 1), @($quest.progress.steps).Count, $step.title) -ForegroundColor Green
    Write-Host ("目標地點：{0}" -f $stepPoint.name)
    Write-Host ("目標內容：{0}" -f $step.goal_text)
    Write-Host ("推進指令：do {0}" -f $step.advance_command) -ForegroundColor DarkCyan
    Write-Host ("完成後可交付報酬：{0} 現金、{1}" -f $quest.progress.completion.rewards.currency, ($quest.progress.completion.rewards.items -join '、')) -ForegroundColor DarkGray
}

function Show-Actions {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host ''
        Write-Host '目前沒有可推進的任務動作。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    Write-Host ''
    Write-Host '--- 可用任務動作 ---' -ForegroundColor Cyan

    if ($record.status -eq 'ready_to_turn_in') {
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $quest.progress.completion.turn_in_location_id
        Write-Host ("- turnin（前往 {0} 交付任務）" -f $turnInPoint.name) -ForegroundColor Green
        return
    }

    $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
    $stepPoint = Get-StartPointById -RegionPack $RegionPack -PointId $step.location_id
    Write-Host ("- do {0}" -f $step.advance_command) -ForegroundColor Green
    Write-Host ("  地點：{0}" -f $stepPoint.name)
    Write-Host ("  目標：{0}" -f $step.goal_text)
    Write-Host ("  別名：{0}" -f ($step.advance_aliases -join '、')) -ForegroundColor DarkGray
    Write-Host '- advance（在正確地點時，直接執行當前步驟）' -ForegroundColor DarkGray
}

function Show-Npcs {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 眼前可能接觸的人 ---' -ForegroundColor Cyan
    foreach ($npcId in $GameState.runtime.linked_npcs) {
        $npc = Get-NpcById -RegionPack $RegionPack -NpcId $npcId
        if ($null -ne $npc) {
            Write-Host ("- {0}：{1}" -f $npc.name, $npc.role)
            Write-Host ("  {0}" -f $npc.intro_use) -ForegroundColor DarkGray
        }
    }
}

function Show-QuestBoard {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if ($null -ne (Get-ActiveQuestRecord -GameState $GameState)) {
        Write-Host ''
        Write-Host '你手上已經有進行中的任務，先把它推完或交付再來接下一條。' -ForegroundColor Yellow
        return
    }

    $available = @(Get-AvailableQuestsForCurrentScene -GameState $GameState -RegionPack $RegionPack)
    Write-Host ''
    Write-Host '--- 當地任務板 ---' -ForegroundColor Cyan
    if ($available.Count -eq 0) {
        Write-Host '這個落點目前沒有新的 starter quest 可接。你可以先移動到其他落點再看看。' -ForegroundColor Yellow
        return
    }

    for ($i = 0; $i -lt $available.Count; $i++) {
        $quest = $available[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $quest.title) -ForegroundColor Green
        Write-Host ("   衝突：{0}" -f $quest.core_conflict)
        Write-Host ("   完成後可得：{0} 現金、{1}" -f $quest.progress.completion.rewards.currency, ($quest.progress.completion.rewards.items -join '、')) -ForegroundColor DarkGray
    }

    Write-Host '輸入 take 1 之類的指令即可接任務。' -ForegroundColor DarkCyan
}

function Show-Services {
    param([object]$RegionPack)

    Write-Host ''
    Write-Host '--- 補給與服務 ---' -ForegroundColor Cyan
    foreach ($tag in $RegionPack.service_tags) {
        Write-Host ("- {0}" -f $tag)
    }
}

function Show-Circuits {
    param([object]$RegionPack)

    Write-Host ''
    Write-Host '--- 地方迴路 ---' -ForegroundColor Cyan
    foreach ($circuit in $RegionPack.location_circuits) {
        Write-Host ("- {0}：{1}" -f $circuit.name, ($circuit.route -join ' -> '))
    }
}

function Show-ActiveEncounter {
    param([hashtable]$GameState)

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -eq $activeEncounter) {
        Write-Host '目前沒有正在進行中的遭遇。' -ForegroundColor Yellow
        return
    }

    Write-Host ''
    Write-Host '--- 遭遇 ---' -ForegroundColor Cyan
    Write-Host ("類型：{0}" -f $activeEncounter.title) -ForegroundColor Yellow
    Write-Host $activeEncounter.text
    Write-Host ''
    Write-Host '你可以這樣應對：' -ForegroundColor Cyan
    for ($i = 0; $i -lt @($activeEncounter.options).Count; $i++) {
        $option = $activeEncounter.options[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $option.title) -ForegroundColor Green
    }
    Write-Host '輸入 respond 1 之類的指令即可處理這次遭遇。' -ForegroundColor DarkCyan
}

function Trigger-Encounter {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -ne $activeEncounter) {
        Show-ActiveEncounter -GameState $GameState
        return
    }

    $encounter = Get-Random -InputObject $RegionPack.encounter_seeds
    $profile = Get-EncounterProfile -Type ([string]$encounter.type)
    $GameState.runtime.active_encounter = [ordered]@{
        type = [string]$encounter.type
        title = [string]$profile.title
        category = [string]$profile.category
        scene_id = [string]$GameState.location.current_scene_id
        scene_name = [string]$GameState.location.current_scene_name
        text = [string]$encounter.text
        options = @(
            foreach ($option in @($profile.options)) {
                [ordered]@{
                    key = [string]$option.key
                    title = [string]$option.title
                }
            }
        )
    }
    Advance-TimeState -GameState $GameState -Steps 1
    Show-ActiveEncounter -GameState $GameState
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Resolve-Encounter {
    param(
        [hashtable]$GameState,
        [string]$Selection
    )

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -eq $activeEncounter) {
        Write-Host '目前沒有需要處理的遭遇。' -ForegroundColor Yellow
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt @($activeEncounter.options).Count) {
        Write-Host ("請輸入 1 到 {0} 之間的遭遇選項編號。" -f @($activeEncounter.options).Count) -ForegroundColor Yellow
        return
    }

    $profile = Get-EncounterProfile -Type ([string]$activeEncounter.type)
    $resolution = @($profile.options)[$selectedIndex - 1]

    $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($resolution.clues)
    $GameState.inventory.inventory_slots = Add-UniqueStrings -Collection $GameState.inventory.inventory_slots -Values @($resolution.items)
    $GameState.runtime.learned_job_directions = Add-UniqueStrings -Collection $GameState.runtime.learned_job_directions -Values @($resolution.job_directions)
    $GameState.runtime.current_pressure_tags = Add-UniqueStrings -Collection $GameState.runtime.current_pressure_tags -Values @($resolution.pressure_tags)
    $GameState.inventory.currency += [int]$resolution.currency
    Add-ReputationDelta -GameState $GameState -TrackId ([string]$resolution.reputation_track) -Delta ([int]$resolution.reputation_delta)
    $GameState.runtime.active_encounter = $null
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 遭遇結果 ---' -ForegroundColor Cyan
    Write-Host $resolution.result_text -ForegroundColor Green
    if ([int]$resolution.currency -ne 0) {
        Write-Host ("現金變動：{0}" -f $resolution.currency) -ForegroundColor Yellow
    }
    if (@($resolution.items).Count -gt 0) {
        Write-Host ("獲得物品：{0}" -f (@($resolution.items) -join '、'))
    }
    if ([int]$resolution.reputation_delta -ne 0 -and -not [string]::IsNullOrWhiteSpace([string]$resolution.reputation_track)) {
        Write-Host ("地區評價：{0} +{1}" -f $resolution.reputation_track, $resolution.reputation_delta) -ForegroundColor DarkCyan
    }
    if (@($resolution.job_directions).Count -gt 0) {
        Write-Host ("開出的職業方向：{0}" -f (@($resolution.job_directions) -join '、')) -ForegroundColor DarkCyan
    }
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Move-Location {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '移動')) {
        return
    }

    Write-Host ''
    Write-Host '你可以往哪裡轉移：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $RegionPack.start_points.Count; $i++) {
        $point = $RegionPack.start_points[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $point.name)
    }

    $selectedIndex = Read-Choice -Prompt '請選擇要移動的地點編號' -Min 1 -Max $RegionPack.start_points.Count
    $target = $RegionPack.start_points[$selectedIndex - 1]
    $GameState.location.current_scene_id = $target.id
    $GameState.location.current_scene_name = $target.name
    $GameState.runtime.current_pressure_tags = @($target.pressure_tags)
    $GameState.runtime.linked_npcs = @($target.linked_npcs)
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ("你轉移到了 {0}。" -f $target.name) -ForegroundColor Green
    Write-Host $target.why_start_here
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Show-Help {
    Write-Host ''
    Write-Host '可用指令：' -ForegroundColor Cyan
    Write-Host '- look              看目前場景'
    Write-Host '- status            看角色狀態'
    Write-Host '- quest             看目前任務與進度'
    Write-Host '- board             看當地可接任務'
    Write-Host '- actions           看目前任務可推進的動作'
    Write-Host '- take <number>     接下任務板上的一條任務'
    Write-Host '- do <keyword>      執行當前任務步驟'
    Write-Host '- advance           在正確地點時直接推進當前步驟'
    Write-Host '- turnin            交付已完成任務並領報酬'
    Write-Host '- npcs              看目前關鍵人物'
    Write-Host '- services          看補給與服務'
    Write-Host '- circuits          看地方迴路'
    Write-Host '- move              移動到其他起始點'
    Write-Host '- encounter         抽出或重看當前遭遇'
    Write-Host '- respond <number>  處理眼前遭遇'
    Write-Host '- save              存檔'
    Write-Host '- help              顯示指令'
    Write-Host '- exit              離開原型'
}

function Show-Look {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $scene = Get-StartPointById -RegionPack $RegionPack -PointId $GameState.location.current_scene_id
    Write-Host ''
    Write-Host '--- 場景 ---' -ForegroundColor Cyan
    Write-Host ("你現在在 {0}。" -f $scene.name)
    Write-Host $scene.why_start_here
    Write-Host ("眼前壓力：{0}" -f ($scene.pressure_tags -join '、')) -ForegroundColor Yellow

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -ne $activeEncounter) {
        Write-Host ("眼前還有一個未處理的遭遇：{0}" -f $activeEncounter.title) -ForegroundColor Yellow
        Write-Host '可先輸入 encounter 重新看選項，或用 respond <number> 處理。' -ForegroundColor DarkCyan
        return
    }

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -ne $record) {
        $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
        if ($record.status -eq 'ready_to_turn_in') {
            if ($quest.progress.completion.turn_in_location_id -eq $scene.id) {
                Write-Host '你已經能在這裡交付任務，輸入 turnin 即可結算。' -ForegroundColor Green
            }
        }
        else {
            $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
            if ($step.location_id -eq $scene.id) {
                Write-Host ("這裡可以推進任務：{0}" -f $step.title) -ForegroundColor Green
                Write-Host ("建議指令：do {0}" -f $step.advance_command) -ForegroundColor DarkCyan
            }
        }
    }
    else {
        $available = @(Get-AvailableQuestsForCurrentScene -GameState $GameState -RegionPack $RegionPack)
        if ($available.Count -gt 0) {
            Write-Host '這裡有新的 starter quest 可接，輸入 board 可查看。' -ForegroundColor Green
        }
    }
}

function Accept-Quest {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '接任務')) {
        return
    }

    if ($null -ne (Get-ActiveQuestRecord -GameState $GameState)) {
        Write-Host '你目前還有進行中的任務，先把它處理完。' -ForegroundColor Yellow
        return
    }

    $available = @(Get-AvailableQuestsForCurrentScene -GameState $GameState -RegionPack $RegionPack)
    if ($available.Count -eq 0) {
        Write-Host '這裡沒有可接的新任務。' -ForegroundColor Yellow
        return
    }

    $selectedIndex = 1
    if (-not [string]::IsNullOrWhiteSpace($Selection)) {
        $parsed = 0
        if (-not ([int]::TryParse($Selection, [ref]$parsed)) -or $parsed -lt 1 -or $parsed -gt $available.Count) {
            Write-Host ("請輸入 1 到 {0} 之間的任務編號。" -f $available.Count) -ForegroundColor Yellow
            return
        }
        $selectedIndex = $parsed
    }
    elseif ($available.Count -gt 1) {
        Write-Host '這裡有不只一條任務，請用 take 1 之類的方式指定。' -ForegroundColor Yellow
        return
    }

    $quest = $available[$selectedIndex - 1]
    $GameState.quests.active_quests = @((New-QuestRecord -QuestId ([string]$quest.quest_id)))
    Write-Host ''
    Write-Host '--- 接下任務 ---' -ForegroundColor Cyan
    Write-Host ("你接下了：{0}" -f $quest.title) -ForegroundColor Green
    Write-Host ("衝突：{0}" -f $quest.core_conflict)
    Write-Host ("第一步建議：{0}" -f $quest.progress.steps[0].title) -ForegroundColor Yellow
    Write-Host ("可先輸入：do {0}" -f $quest.progress.steps[0].advance_command) -ForegroundColor DarkCyan
}

function Resolve-QuestAction {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$ActionToken,
        [switch]$AdvanceCurrent
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '推進任務')) {
        return
    }

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host '目前沒有進行中的任務。' -ForegroundColor Yellow
        return
    }

    if ($record.status -eq 'ready_to_turn_in') {
        Write-Host '這條任務已可交付，請改用 turnin。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
    $requiredScene = Get-StartPointById -RegionPack $RegionPack -PointId $step.location_id

    if ($GameState.location.current_scene_id -ne $step.location_id) {
        Write-Host ("你現在不在正確地點。這一步要去 {0}。" -f $requiredScene.name) -ForegroundColor Yellow
        return
    }

    $matched = $AdvanceCurrent.IsPresent
    if (-not $matched) {
        $candidates = @($step.advance_command) + @($step.advance_aliases)
        foreach ($candidate in $candidates) {
            if ($candidate -eq $ActionToken) {
                $matched = $true
                break
            }
        }
    }

    if (-not $matched) {
        Write-Host ("這一步的有效指令是 do {0}，或使用 advance。" -f $step.advance_command) -ForegroundColor Yellow
        return
    }

    $record.progress_log = Add-UniqueString -Collection $record.progress_log -Value ([string]$step.title)
    $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($step.clues)
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 任務推進 ---' -ForegroundColor Cyan
    Write-Host $step.result_text -ForegroundColor Green

    $nextIndex = $record.step_index + 1
    if ($nextIndex -ge @($quest.progress.steps).Count) {
        $record.status = 'ready_to_turn_in'
        Write-Host ''
        Write-Host '你已完成這條任務的調查或處理階段。' -ForegroundColor Green
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $quest.progress.completion.turn_in_location_id
        $turnInNpc = Get-NpcById -RegionPack $RegionPack -NpcId $quest.progress.completion.turn_in_npc_id
        Write-Host ("接下來請前往 {0}，找 {1} 交付任務。" -f $turnInPoint.name, $turnInNpc.name) -ForegroundColor Yellow
    }
    else {
        $record.step_index = $nextIndex
        $nextStep = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
        $nextPoint = Get-StartPointById -RegionPack $RegionPack -PointId $nextStep.location_id
        Write-Host ''
        Write-Host ("下一步：{0}" -f $nextStep.title) -ForegroundColor Yellow
        Write-Host ("前往地點：{0}" -f $nextPoint.name)
        Write-Host ("目標：{0}" -f $nextStep.goal_text)
    }

    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Complete-QuestTurnIn {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '交付任務')) {
        return
    }

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host '目前沒有可交付的任務。' -ForegroundColor Yellow
        return
    }

    if ($record.status -ne 'ready_to_turn_in') {
        Write-Host '這條任務還沒完成到可交付的階段。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    $completion = $quest.progress.completion
    if ($GameState.location.current_scene_id -ne $completion.turn_in_location_id) {
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $completion.turn_in_location_id
        Write-Host ("你還沒到交付地點，請先前往 {0}。" -f $turnInPoint.name) -ForegroundColor Yellow
        return
    }

    $GameState.inventory.currency += [int]$completion.rewards.currency
    $GameState.inventory.inventory_slots = Add-UniqueStrings -Collection $GameState.inventory.inventory_slots -Values @($completion.rewards.items)
    $GameState.runtime.learned_job_directions = Add-UniqueStrings -Collection $GameState.runtime.learned_job_directions -Values @($completion.rewards.job_directions)

    $trackId = [string]$completion.rewards.reputation.track_id
    $existingValue = 0
    if ($GameState.reputation.tracks.Contains($trackId)) {
        $existingValue = [int]$GameState.reputation.tracks[$trackId]
    }
    $GameState.reputation.tracks[$trackId] = $existingValue + [int]$completion.rewards.reputation.delta
    $GameState.notebook.revealed_truths = Add-UniqueString -Collection $GameState.notebook.revealed_truths -Value ([string]$completion.turn_in_text)

    $record.status = 'completed'
    $record.completed_at = (Get-Date).ToString('o')
    $completedEntry = [ordered]@{
        quest_id = $record.quest_id
        completed_at = $record.completed_at
        rewards = [ordered]@{
            currency = $completion.rewards.currency
            items = @($completion.rewards.items)
            reputation_track = $completion.rewards.reputation.track_id
            reputation_delta = $completion.rewards.reputation.delta
            job_directions = @($completion.rewards.job_directions)
        }
    }

    $remainingActive = @()
    foreach ($active in @($GameState.quests.active_quests)) {
        if ($active.quest_id -ne $record.quest_id) {
            $remainingActive += $active
        }
    }
    $GameState.quests.active_quests = $remainingActive
    $GameState.quests.completed_quests += $completedEntry
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 任務完成 ---' -ForegroundColor Cyan
    Write-Host $completion.turn_in_text -ForegroundColor Green
    Write-Host ("獲得現金：{0}" -f $completion.rewards.currency) -ForegroundColor Yellow
    Write-Host ("獲得物品：{0}" -f ($completion.rewards.items -join '、'))
    Write-Host ("地區評價：{0} +{1}" -f $completion.rewards.reputation.label, $completion.rewards.reputation.delta)
    Write-Host ("開出的職業方向：{0}" -f ($completion.rewards.job_directions -join '、')) -ForegroundColor DarkCyan
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Start-Loop {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Show-Opening -GameState $GameState -RegionPack $RegionPack
    Show-Help

    while ($true) {
        $inputLine = (Read-GameInput "`n你要做什麼").Trim()
        if ([string]::IsNullOrWhiteSpace($inputLine)) {
            continue
        }

        $parts = $inputLine -split '\s+', 2
        $command = $parts[0].ToLowerInvariant()
        $argument = ''
        if ($parts.Count -gt 1) {
            $argument = $parts[1].Trim().ToLowerInvariant()
        }

        switch ($command) {
            'look' { Show-Look -GameState $GameState -RegionPack $RegionPack }
            'status' { Show-Status -GameState $GameState -RegionPack $RegionPack }
            'quest' { Show-Quest -GameState $GameState -RegionPack $RegionPack }
            'board' { Show-QuestBoard -GameState $GameState -RegionPack $RegionPack }
            'actions' { Show-Actions -GameState $GameState -RegionPack $RegionPack }
            'take' { Accept-Quest -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'do' { Resolve-QuestAction -GameState $GameState -RegionPack $RegionPack -ActionToken $argument }
            'advance' { Resolve-QuestAction -GameState $GameState -RegionPack $RegionPack -AdvanceCurrent }
            'turnin' { Complete-QuestTurnIn -GameState $GameState -RegionPack $RegionPack }
            'npcs' { Show-Npcs -GameState $GameState -RegionPack $RegionPack }
            'services' { Show-Services -RegionPack $RegionPack }
            'circuits' { Show-Circuits -RegionPack $RegionPack }
            'move' { Move-Location -GameState $GameState -RegionPack $RegionPack }
            'encounter' { Trigger-Encounter -GameState $GameState -RegionPack $RegionPack }
            'respond' { Resolve-Encounter -GameState $GameState -Selection $argument }
            'save' { Save-GameState -GameState $GameState }
            'help' { Show-Help }
            'exit' {
                $saveBeforeExit = Read-GameInput '離開前要先存檔嗎？(y/n)'
                if ($saveBeforeExit.Trim().ToLowerInvariant() -eq 'y') {
                    Save-GameState -GameState $GameState
                }
                Write-Host '已離開幽語海原型。' -ForegroundColor Cyan
                break
            }
            default {
                Write-Host '目前原型只支援 help 顯示的指令。' -ForegroundColor Yellow
            }
        }

        if ($command -eq 'exit') {
            break
        }
    }
}

function Main {
    Show-Title
    $regionPack = Load-RegionPack

    while ($true) {
        Show-Menu
        $choice = Read-Choice -Prompt '請選擇功能編號' -Min 1 -Max 3
        switch ($choice) {
            1 {
                $gameState = New-GameState -RegionPack $regionPack
                Start-Loop -GameState $gameState -RegionPack $regionPack
                if ($Script:ScriptedMode -and $Script:InputQueue.Count -eq 0) {
                    return
                }
            }
            2 {
                $gameState = Load-GameState -RegionPack $regionPack
                if ($null -ne $gameState) {
                    Start-Loop -GameState $gameState -RegionPack $regionPack
                    if ($Script:ScriptedMode -and $Script:InputQueue.Count -eq 0) {
                        return
                    }
                }
            }
            3 {
                Write-Host '結束原型。' -ForegroundColor Cyan
                return
            }
        }
    }
}

Main
