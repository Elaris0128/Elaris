$ErrorActionPreference = 'Stop'

$root = 'C:\Users\rabbi\OneDrive\Desktop\Elaris'
$isamelRoot = Join-Path $root 'content\world\02-continents\04-isamel'
$charRoot = Join-Path $root 'content\world\07-characters'
$regionRoot = Join-Path $root 'content\scenarios\regions'
$utf8Bom = New-Object System.Text.UTF8Encoding($true)

function Ensure-Dir([string]$Path) {
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
}

function Write-Utf8Bom([string]$Path, [string]$Content) {
  Ensure-Dir $Path
  [System.IO.File]::WriteAllText($Path, $Content.Trim() + "`r`n", $utf8Bom)
}

function Abs-Path([string]$Relative) {
  return ((Join-Path $root $Relative) -replace '\\', '/')
}

function Md-Link([string]$Label, [string]$Relative) {
  return "[$Label]($(Abs-Path $Relative))"
}

function Get-BaseLocationFiles([string]$realmId) {
  $dir = Join-Path $isamelRoot ("locations\" + $realmId)
  Get-ChildItem -Path $dir -Filter '*.md' |
    Where-Object { $_.Name -notmatch '\.(people|shops|relations|events|wares|sidequests|buildings|stalls)\.md$' } |
    Sort-Object Name
}

function Get-CharacterFiles([string]$realmId) {
  $dir = Join-Path $charRoot $realmId
  Get-ChildItem -Path $dir -Filter '*.md' |
    Where-Object { $_.Name -notin @('README.md','supporting-cast.md') } |
    Sort-Object Name
}

function Get-TitleFromFile([string]$Path) {
  $first = Get-Content -Path $Path -Encoding UTF8 | Select-Object -First 1
  return ($first -replace '^#\s*', '').Trim()
}

function Get-RoleFromCharacter([string]$Path) {
  $match = Select-String -Path $Path -Pattern '^- 角色定位：(.+)$' -Encoding UTF8
  if ($match) { return $match.Matches[0].Groups[1].Value.Trim() }
  return '地方角色'
}

function Get-RoleFromLocation([string]$Path) {
  $lines = Get-Content -Path $Path -Encoding UTF8
  foreach ($line in $lines) {
    if ($line -match '是 .+ 的 (.+?)。') { return $Matches[1].Trim() }
  }
  return '地方據點'
}

function Replace-Section([string]$Content, [string]$Heading, [string]$Body) {
  $pattern = "(?ms)^## " + [regex]::Escape($Heading) + "\r?\n.*?(?=^## |\z)"
  $replacement = "## $Heading`r`n$Body`r`n"
  return [regex]::Replace($Content, $pattern, $replacement)
}

$realms = @(
  [ordered]@{
    Id='yunselin'; Name='雲瑟靈雲冠域'; File='yunselin-spiritcloud-canopy.md'; ThemeShort='命名與共息'; TravelWay='枝橋與穴廊'; ResourceMain='樹脂、共生菌絲與花粉鹽'; Pressure='命名失序與禁域開裂'; BeastMain='靈枝誓龍'; Mission='維護母樹的命名秩序，並守住皇族與穴民之間的共息契約。'
    Locations=@(
      @{Slug='mingzhi-archive'; Name='命枝典藏所'; Role='命名抄錄與枝典保存院'}
      @{Slug='kongya-feathernursery'; Name='空芽育羽庭'; Role='幼龍與幼枝共育場'}
      @{Slug='shenyin-rootbell'; Name='深音根鐘窟'; Role='根鐘聽驗與失名追索所'}
    )
    Characters=@(
      @{Slug='xumian'; Name='序冕'; Race='精靈'; Branch='雲瑟皇族'; Role='名錄校定官'}
      @{Slug='hezhu'; Name='荷祝'; Race='巴布窟族'; Branch='共息穴民'; Role='祠井維護者'}
      @{Slug='qingfan'; Name='青梵'; Race='精靈'; Branch='雲瑟皇族'; Role='靈枝誓龍育契官'}
      @{Slug='gencen'; Name='根岑'; Race='巴布窟族'; Branch='共息穴民'; Role='穴廊靜夜守鐘者'}
    )
  }
  [ordered]@{
    Id='thertalyn'; Name='瑟塔嶺星墜臺原'; File='thertalyn-starfall-plateau.md'; ThemeShort='高脊牧龍'; TravelWay='高脊風道'; ResourceMain='風晶、牧脊鹽與龍鞍纖維'; Pressure='高脊風暴與龍群躁動'; BeastMain='冠脊飛龍'; Mission='守住高原風道與星墜臺原的飛龍秩序，避免龍風與風暴失衡。'
    Locations=@(
      @{Slug='xingbei-herdtiers'; Name='星背牧臺'; Role='高原牧群分階駐台'}
      @{Slug='fengji-observatory'; Name='風脊觀象坪'; Role='試飛與觀風平台'}
      @{Slug='huiling-saddleworks'; Name='灰翎鞍坊'; Role='龍鞍與風具總工所'}
    )
    Characters=@(
      @{Slug='xingxiao'; Name='星嘯'; Race='精靈'; Branch='瑟塔嶺族'; Role='飛龍鳴譜記官'}
      @{Slug='hanmu'; Name='寒牧'; Race='人類'; Branch='高原行牧民'; Role='遷牧路權調停者'}
      @{Slug='fengshi'; Name='風誓'; Race='精靈'; Branch='瑟塔嶺族'; Role='高脊試飛誓證官'}
      @{Slug='yueling'; Name='岳翎'; Race='精靈'; Branch='瑟塔嶺族'; Role='星墜臺地地圖師'}
    )
  }
  [ordered]@{
    Id='filune'; Name='菲露涅羽蔭林庭'; File='filune-grove.md'; ThemeShort='羽蔭護林'; TravelWay='冠樹索橋'; ResourceMain='藥脂、羽樹纖維與露香粉'; Pressure='羽獸驚竄與樹冠疫斑'; BeastMain='花翎幼龍'; Mission='守住羽蔭樹海的藥學、冠層路網與鳳羽護林誓律。'
    Locations=@(
      @{Slug='yuyi-resinhouse'; Name='羽裔脂舍'; Role='藥脂精煉與診治庭'}
      @{Slug='linxuan-crownrun'; Name='林旋冠徑'; Role='冠層奔行與巡獸起點'}
      @{Slug='bixi-restbay'; Name='碧溪歇灣'; Role='護林者與旅隊休整灣'}
    )
    Characters=@(
      @{Slug='zhilin'; Name='枝霖'; Race='精靈'; Branch='菲露涅族'; Role='冠橋病斑修復師'}
      @{Slug='yefeng'; Name='葉風'; Race='森馳裔'; Branch='林冠行群'; Role='高冠追獸者'}
      @{Slug='huayu'; Name='花語'; Race='精靈'; Branch='菲露涅族'; Role='羽鳳試伴導唱'}
      @{Slug='qingzhi'; Name='青枝'; Race='精靈'; Branch='菲露涅族'; Role='溪灣藥材辨識官'}
    )
  }
  [ordered]@{
    Id='vithare'; Name='維塔蕾漂葦林灣'; File='vithare-weald.md'; ThemeShort='漂葦工藝'; TravelWay='漂葦浮橋'; ResourceMain='蘆纖、浮木膠與鈴葦工材'; Pressure='沼汐變道與浮棚漂失'; BeastMain='鈴葦小龍'; Mission='維持低潮與漂棚的秩序，守住濕地工藝不被水位與外來商路吞沒。'
    Locations=@(
      @{Slug='luzhou-weavecourt'; Name='蘆洲織庭'; Role='根纖織橋與圖樣庫'}
      @{Slug='manwan-polemoor'; Name='蔓灣樁泊'; Role='漂橋停泊與張力校樁場'}
      @{Slug='dianshui-lowdock'; Name='點水低埠'; Role='低潮交易與換工棚帶'}
    )
    Characters=@(
      @{Slug='luzhen'; Name='蘆真'; Race='精靈'; Branch='維塔蕾族'; Role='根織橋樣師'}
      @{Slug='manqiu'; Name='蔓秋'; Race='森馳裔'; Branch='漂葦行群'; Role='水位巡察手'}
      @{Slug='qiaosong'; Name='橋頌'; Race='精靈'; Branch='維塔蕾族'; Role='漂橋誓見者'}
      @{Slug='dingwei'; Name='定渭'; Race='精靈'; Branch='維塔蕾族'; Role='浮棚契算官'}
    )
  }
  [ordered]@{
    Id='yathire'; Name='雅席爾沉雨澤境'; File='yathire-marshes.md'; ThemeShort='沉雨祭沼'; TravelWay='雨沼舟道'; ResourceMain='雨礦、水藻礦鹽與沉泥藥花'; Pressure='沉雨季失道與礦層下陷'; BeastMain='沼光幼龍'; Mission='看守雨季沼道與眠礦水脈，避免濁雨時期讓整域失去通行與祭儀秩序。'
    Locations=@(
      @{Slug='yushen-siltcamp'; Name='雨深泥營'; Role='雨季救援與泥病處置營'}
      @{Slug='kuanghua-rainyard'; Name='礦花雨場'; Role='礦花洗讀與祭沼點驗場'}
      @{Slug='chenmu-bogrest'; Name='沉木歇灣'; Role='雨道換舟與外客靜泊點'}
    )
    Characters=@(
      @{Slug='yutan'; Name='雨潭'; Race='精靈'; Branch='雅席爾族'; Role='祭沼水脈判讀師'}
      @{Slug='chensu'; Name='沉溯'; Race='海人'; Branch='澤息行民'; Role='深雨救渡者'}
      @{Slug='kuangxi'; Name='礦汐'; Race='精靈'; Branch='雅席爾族'; Role='眠礦封樣官'}
      @{Slug='muhe'; Name='沐荷'; Race='精靈'; Branch='雅席爾族'; Role='泥病祈浴司'}
    )
  }
  [ordered]@{
    Id='olorase'; Name='歐羅瑟聽潮岸林'; File='olorase-coastwood.md'; ThemeShort='岸林聽潮'; TravelWay='崖根聽道'; ResourceMain='鹽霧木脂、礁骨鹽與聽潮索材'; Pressure='岸霧誤訊與礁窗斷流'; BeastMain='潮棘小龍'; Mission='守住岸林聽潮系統，讓整個西南岸線仍能被讀懂、被警示與被接回。'
    Locations=@(
      @{Slug='tingfeng-cliffcourt'; Name='聽風崖庭'; Role='崖訊輪值與風讀訓場'}
      @{Slug='genlang-anchorroot'; Name='根浪泊根'; Role='補給泊位與航歌結誓點'}
      @{Slug='yanzhi-saltwood'; Name='巖枝鹽木坊'; Role='鹽霧木藝與索材整備坊'}
    )
    Characters=@(
      @{Slug='tinglan'; Name='聽瀾'; Race='精靈'; Branch='歐羅瑟族'; Role='聽崖誤訊校辨官'}
      @{Slug='gexing'; Name='歌行'; Race='海人'; Branch='岸歌航民'; Role='根港護航領唱'}
      @{Slug='muyan'; Name='木鹽'; Race='精靈'; Branch='歐羅瑟族'; Role='鹽霧木藝監造師'}
      @{Slug='chaoxun'; Name='潮訊'; Race='精靈'; Branch='歐羅瑟族'; Role='遠岸烽訊轉錄者'}
    )
  }
  [ordered]@{
    Id='aulifan'; Name='奧里梵晨火蔓叢'; File='aulifan-thickets.md'; ThemeShort='晨火藤道'; TravelWay='藤索火徑'; ResourceMain='晨火藤絲、燼皮、熱露樹膠'; Pressure='晨火外溢與切迷路徑改寫'; BeastMain='晨火幼龍'; Mission='讓晨火成為秩序，而不是焚盡整片蔓叢的災禍。'
    Locations=@(
      @{Slug='yanlu-trialforge'; Name='焰露試工庭'; Role='火露工材與試道裝備場'}
      @{Slug='tengmiao-scorchpass'; Name='藤杪灼隘'; Role='高危試路與火線折返點'}
      @{Slug='chenming-vinehall'; Name='晨明索廳'; Role='藤索總廳與晨火錄庫'}
    )
    Characters=@(
      @{Slug='yanqi'; Name='焰柒'; Race='精靈'; Branch='奧里梵族'; Role='火徑裁定官'}
      @{Slug='manxiao'; Name='蔓曉'; Race='森馳裔'; Branch='晨藤試行群'; Role='切迷先行者'}
      @{Slug='luyan'; Name='露焰'; Race='精靈'; Branch='奧里梵族'; Role='火露護具調匠'}
      @{Slug='suotian'; Name='索田'; Race='精靈'; Branch='奧里梵族'; Role='晨火試卷司錄'}
    )
  }
  [ordered]@{
    Id='milanyu'; Name='米蘭羽迷澤川'; File='milanyu-reaches.md'; ThemeShort='迷澤聽池'; TravelWay='霧澤棧橋'; ResourceMain='眠霧草、沼木、靜泊鹽與羽苔'; Pressure='霧澤封流與偽航道誘迷'; BeastMain='霧潟小龍'; Mission='讓迷澤仍有路，讓會吃掉記憶的霧不至於吞沒整個文明域。'
    Locations=@(
      @{Slug='jingbo-listenhall'; Name='靜泊聽廳'; Role='停泊裁定與霧訊聽判所'}
      @{Slug='zemu-mudyard'; Name='澤木泥場'; Role='泥堡補材與舟殼修補場'}
      @{Slug='luwu-hiddendock'; Name='蘆霧藏埠'; Role='盲沼外客藏泊與撤離點'}
    )
    Characters=@(
      @{Slug='tingji'; Name='聽汲'; Race='精靈'; Branch='米蘭羽族'; Role='聽池分流裁判官'}
      @{Slug='boye'; Name='泊夜'; Race='海人'; Branch='霧潟泊民'; Role='夜泊燈手'}
      @{Slug='menglu'; Name='霧櫓'; Race='精靈'; Branch='米蘭羽族'; Role='偽航道改寫記錄師'}
      @{Slug='yubo'; Name='羽泊'; Race='精靈'; Branch='米蘭羽族'; Role='眠羽回燼鳳補灰師'}
    )
  }
  [ordered]@{
    Id='shranolan'; Name='霜諾蘭眠霧寒穴'; File='shranolan-hollow.md'; ThemeShort='寒穴名墓'; TravelWay='冰橋與霧穴'; ResourceMain='冰紋鹽、霧花、寒脈石與霜藥'; Pressure='寒穴封結與失名眠霧'; BeastMain='霜紋幼龍'; Mission='守住寒穴名墓與冬井誓律，讓極寒不把名字和路都一併吞掉。'
    Locations=@(
      @{Slug='dongming-coldarchive'; Name='冬銘冰庫'; Role='冰紋典籍與寒材封錄庫'}
      @{Slug='yeyue-nightspan'; Name='夜月巡橋'; Role='夜哨輪換與寒脊觀風橋'}
      @{Slug='shuangqian-restvault'; Name='霜前歇穴'; Role='外客與修行者停留寒穴'}
    )
    Characters=@(
      @{Slug='hanming'; Name='寒銘'; Race='精靈'; Branch='霜諾蘭族'; Role='名墓封記官'}
      @{Slug='yesuo'; Name='夜索'; Race='極光徙裔'; Branch='霜客外枝'; Role='冰橋補索者'}
      @{Slug='binglan'; Name='冰瀾'; Race='精靈'; Branch='霜諾蘭族'; Role='霧穴藥眠師'}
      @{Slug='fengmiao'; Name='風渺'; Race='精靈'; Branch='霜諾蘭族'; Role='寒脊飛龍遙測官'}
    )
  }
)

foreach ($realm in $realms) {
  $locDir = Join-Path $isamelRoot ("locations\" + $realm.Id)
  foreach ($loc in $realm.Locations) {
    $baseRel = "content/world/02-continents/04-isamel/locations/$($realm.Id)/$($loc.Slug).md"
    $basePath = Join-Path $locDir ($loc.Slug + '.md')
    Write-Utf8Bom $basePath @"
# $($loc.Name)

## 概述
$($loc.Name) 是 $($realm.Name) 的 $($loc.Role)。這裡比主核聚落更貼近在地勞動、守域與傳承節奏，也最容易讓旅人看見 $($realm.ThemeShort) 如何落在日常生活裡。

## 方位與進出
- 所在文明域：$($realm.Name)
- 常見進入方式：$($realm.TravelWay)
- 主要壓力：$($realm.Pressure)

## 可學習與見習
- 地方可接觸：$($realm.ThemeShort)、$($realm.ResourceMain) 相關見習
- 常見導師來源：地方守枝者、工坊師、伴生照看者、導路人

## 組織與任務入口
- 可接任務類型：地方秩序、祭儀協助、資源護送、靈誓伴照護、探索前哨
- 對應區域包：$(Md-Link ($realm.Name + '區域包') ('content/scenarios/regions/' + $realm.Id + '/README.md'))

## 延伸資料
- $(Md-Link ($loc.Name + '人物明細') ($baseRel -replace '\.md$', '.people.md'))
- $(Md-Link ($loc.Name + '商店與服務') ($baseRel -replace '\.md$', '.shops.md'))
- $(Md-Link ($loc.Name + '關係網') ($baseRel -replace '\.md$', '.relations.md'))
- $(Md-Link ($loc.Name + '地方事件') ($baseRel -replace '\.md$', '.events.md'))
- $(Md-Link ($loc.Name + '貨物與素材') ($baseRel -replace '\.md$', '.wares.md'))
- $(Md-Link ($loc.Name + '在地支線') ($baseRel -replace '\.md$', '.sidequests.md'))
- $(Md-Link ($loc.Name + '重要建築') ($baseRel -replace '\.md$', '.buildings.md'))
- $(Md-Link ($loc.Name + '攤位與臨時販點') ($baseRel -replace '\.md$', '.stalls.md'))
"@

    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.people.md')) "# $($loc.Name)人物明細`r`n`r`n- 常見出現：守域者、學枝、照護人、旅隊窗口與地方長者。"
    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.shops.md')) "# $($loc.Name)商店與服務`r`n`r`n- 常見服務：路具補修、照護用品、地方素材換價與祭務見證。"
    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.relations.md')) "# $($loc.Name)關係網`r`n`r`n- 地方長者、工坊、守域者與外客窗口對 $($realm.ThemeShort) 的優先順序並不完全一致。"
    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.events.md')) "# $($loc.Name)地方事件`r`n`r`n- 常用祈詞：願 $($realm.BeastMain) 在此記住我們。`r`n- 小儀式：出發前會做一次點印、聽位或繫索。`r`n- 生活傳聞：最近與 $($realm.ResourceMain) 有關的配給與資格又吵起來了。`r`n- 禁忌與神職動向：不可跳過地方見證就擅自進行命名、取材或伴生照看。"
    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.wares.md')) "# $($loc.Name)貨物與素材`r`n`r`n- 常見貨物：$($realm.ResourceMain)"
    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.sidequests.md')) "# $($loc.Name)在地支線`r`n`r`n- 協助處理一件與 $($realm.ThemeShort) 有關、但又牽動地方秩序的小型異常。"
    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.buildings.md')) "# $($loc.Name)重要建築`r`n`r`n- 主廳、工坊、照護棚、補給屋與小型儀式所。"
    Write-Utf8Bom (Join-Path $locDir ($loc.Slug + '.stalls.md')) "# $($loc.Name)攤位與臨時販點`r`n`r`n- 臨時繫索攤、路具補修攤、素材封樣攤與季節性藥材攤。"
  }

  $realmDir = Join-Path $charRoot $realm.Id
  foreach ($char in $realm.Characters) {
    $homeLoc = $realm.Locations[0]
    Write-Utf8Bom (Join-Path $realmDir ($char.Slug + '.md')) @"
# $($char.Name)

## 身分
- 所屬文明域：$($realm.Name)
- 種族：$($char.Race)
- 種族-分支：$($char.Branch)
- 角色定位：$($char.Role)
- 常見出沒：$(Md-Link $homeLoc.Name ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $homeLoc.Slug + '.md'))

## 簡述
$($char.Name) 是 $($realm.Name) 中更貼近日常運作的人物，通常站在 $($realm.ThemeShort) 與 $($realm.ResourceMain) 交會的位置，因此特別容易把地方壓力與真實生活感直接帶到玩家面前。

## 互動方向
- 可作為導師、地方窗口、資格見證者或長線任務的在地連結點。
- 會要求玩家尊重地方路權、命名與伴生秩序。
- 若玩家能理解 $($realm.Mission) 背後的地方邏輯，會更願意給出深層協助。
"@
  }

  $realmFile = Join-Path $isamelRoot ("realms\" + $realm.File)
  $realmContent = Get-Content -Raw -Encoding UTF8 $realmFile
  $locBullets = Get-BaseLocationFiles $realm.Id | ForEach-Object {
    "- $(Md-Link (Get-TitleFromFile $_.FullName) ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $_.Name))"
  }
  $charBullets = Get-CharacterFiles $realm.Id | ForEach-Object {
    "- $(Md-Link (Get-TitleFromFile $_.FullName) ('content/world/07-characters/' + $realm.Id + '/' + $_.Name))｜$(Get-RoleFromCharacter $_.FullName)"
  }
  $realmContent = Replace-Section $realmContent '主要地方' ($locBullets -join "`r`n")
  $realmContent = Replace-Section $realmContent '核心角色' ($charBullets -join "`r`n")
  Write-Utf8Bom $realmFile $realmContent

  $charReadme = "# $($realm.Name)角色索引`r`n`r`n" + (($charBullets) -join "`r`n")
  Write-Utf8Bom (Join-Path $realmDir 'README.md') $charReadme

  $locCircuitBullets = Get-BaseLocationFiles $realm.Id | ForEach-Object {
    "- $(Md-Link (Get-TitleFromFile $_.FullName) ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $_.Name))｜$(Get-RoleFromLocation $_.FullName)"
  }
  Write-Utf8Bom (Join-Path $regionRoot ($realm.Id + '\location-circuit.md')) ("# $($realm.Name)地方迴路`r`n`r`n" + ($locCircuitBullets -join "`r`n"))
}

$locationSections = foreach ($realm in $realms) {
  $lines = Get-BaseLocationFiles $realm.Id | ForEach-Object {
    "- $(Md-Link (Get-TitleFromFile $_.FullName) ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $_.Name))"
  }
  "## $($realm.Name)`r`n" + ($lines -join "`r`n")
}
Write-Utf8Bom (Join-Path $isamelRoot 'isamel-location-index.md') ("# 伊莎梅爾地方包索引`r`n`r`n" + ($locationSections -join "`r`n`r`n"))

$characterSections = foreach ($realm in $realms) {
  $lines = Get-CharacterFiles $realm.Id | ForEach-Object {
    "- $(Md-Link (Get-TitleFromFile $_.FullName) ('content/world/07-characters/' + $realm.Id + '/' + $_.Name))｜$(Get-RoleFromCharacter $_.FullName)"
  }
  "## $($realm.Name)`r`n- $(Md-Link ($realm.Name + '角色索引') ('content/world/07-characters/' + $realm.Id + '/README.md'))`r`n" + ($lines -join "`r`n")
}
Write-Utf8Bom (Join-Path $isamelRoot 'isamel-character-index.md') ("# 伊莎梅爾角色索引`r`n`r`n" + ($characterSections -join "`r`n`r`n"))

$playBullets = foreach ($realm in $realms) {
  $locCount = (Get-BaseLocationFiles $realm.Id).Count
  $siteCount = (Get-ChildItem -Path (Join-Path $isamelRoot ("sites\" + $realm.Id)) -Filter '*.md').Count
  $charCount = (Get-CharacterFiles $realm.Id).Count
  "- $(Md-Link ($realm.Name + '區域包') ('content/scenarios/regions/' + $realm.Id + '/README.md'))｜${locCount}個主地方包、${siteCount}個探索點、${charCount}張核心角色卡、12條任務線"
}
Write-Utf8Bom (Join-Path $regionRoot 'isamel-playability-matrix.md') ("# 伊莎梅爾可玩層矩陣`r`n`r`n## 區域包入口`r`n" + ($playBullets -join "`r`n"))
