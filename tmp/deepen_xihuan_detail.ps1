$root = 'C:\Users\rabbi\OneDrive\Desktop\Elaris'
$x = Join-Path $root 'content\world\03-special-regions\05-xihuan-floating'
$locDir = Join-Path $x 'locations'
$siteDir = Join-Path $x 'sites'
$charDir = Join-Path $root 'content\world\07-characters\xihuan-floating'
$regionDir = Join-Path $root 'content\scenarios\regions\xihuan-floating'
$questDir = Join-Path $root 'content\scenarios\quests'
$play = Join-Path $root 'content\scenarios\regions\xihuan-floating-playability-matrix.md'

function Write-BomFile([string]$Path, [string]$Text) {
  $enc = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText($Path, $Text, $enc)
}

$locs = @(
  [ordered]@{Slug='youcan-hanging-vale'; Name='幽璨懸谷'; Overview='議羽殿、祖羽碑庭與環心傳送坪所在的環心主島，所有高空秩序的正名都要先經過這裡。'; Zones='議羽殿圈、祖羽碑庭、雲谷居帶、環心傳送坪'; Tone='這裡的人說話像在量風壓，能少一個字就不會多說；因為每一段模糊都可能變成跨島事故。'; Day='白天的幽璨像一座會自己記帳的石谷，抄錄、見證、傳令與改判幾乎不停。'; Night='夜裡真正有分量的不是聲音，而是哪一盞燈還亮著；很多決定都在夜裡先被悄悄排好。'; Duty='主責族譜、誓務、議令與跨島輪值分派。'; Season='迎商季時主打核名與外務簿核；鎖風季時則轉為事故裁斷與封線總調度。'; Hooks='刮名碑、失序輪值、舊誓爭議、潮牢退卷'},
  [ordered]@{Slug='mingyu-platform'; Name='鳴羽台'; Overview='成翼、補律與高風試飛的核心訓場，高空責任感不是在這裡被教會，而是被撞進骨頭裡。'; Zones='試風階、補律廊、逆風坪、舊師翼棚'; Tone='這裡沒有真正的休息，只分還在受訓，或已經開始帶下一批人。'; Day='白天滿是訓練聲、風片碰撞聲與教律口令。'; Night='夜裡仍有補考、單獨加訓和被藏起來的舊橋課。'; Duty='主責成翼禮、補律、試風、事故預演與緊急巡救培訓。'; Season='轉陸季偏重中繼與邊線應用訓練；鎖風季則是整個浮境最忙的教律時段。'; Hooks='逆風補考、教律偏袒、舊路重啟、試飛失序'},
  [ordered]@{Slug='chenguang-dropcape'; Name='晨光垂岬'; Overview='主責晨露、雲蘚與靈禽牧養的低風島，曦環最溫柔的一面也最容易被灰線利用。'; Zones='晨露棚坡、垂岬牧線、蘚庫屋列、低風療棚'; Tone='這裡聞起來像濕羽、露水和新切雲蘚，大家說話輕，卻沒人真的天真。'; Day='白天是收露、剪蘚、餵養與療羽的節奏，很多孩子也是在這裡第一次學會認風。'; Night='夜裡棚燈低、步聲輕，但灰線最愛借療養與補給名義靠近這裡。'; Duty='主責晨露採集、雲蘚藥材、靈禽牧養、低風療養與病羽照護。'; Season='守脈季與病羽潮來時最忙；迎商季則常得替外務與陪航準備藥與補給。'; Hooks='離群靈禽、露稅短缺、療養假名、牧線偷渡'},
  [ordered]@{Slug='huanyuan-shardveins'; Name='環淵碎脈'; Overview='浮境最危險的礦料與封脈禁區所在，所有人都知道這裡讓曦環浮著，卻沒人喜歡久留。'; Zones='裂瓣礦棚、封脈碑洞、冷卻滴壁、斷索檢坡'; Tone='每一口風都帶著碎礦與冷霜味，大家先看你的手套，再決定要不要和你說真話。'; Day='白天是檢礦、封脈、冷卻與搬料，所有工序都帶著受傷風險。'; Night='夜裡礦光低伏，最容易有人偷重印契、換掉料，或從斷索檢坡往下放東西。'; Duty='主責礦脈維護、封脈禁制、冷卻資源與結構穩定。'; Season='守脈季與鎖風季最重要，因為那時主環穩定和應急結構都壓在這裡。'; Hooks='假契運礦、禁脈外流、冷卻失衡、押工消失'},
  [ordered]@{Slug='lingxiao-springveil'; Name='凌宵潤澤'; Overview='懸瀑、主泉與濕度調律核心所在，整個曦環最像恩賜的地方，其實背後全是細密計算。'; Zones='主源瀑心、潤澤橋渠、調濕庭、泉記樓'; Tone='到處都是水聲，但每一股水都是被指派過職責的。'; Day='白天人人都在算水勢、配額和霧潮，從來沒有真正的閒看懸瀑。'; Night='夜裡會進行更多不對外公開的旁渠調整和補流試驗。'; Duty='主責懸瀑循環、供水、濕度控制、療養水序與主環浮力調節。'; Season='守脈季是核心；迎商季與轉陸季則要兼顧外務供水和低浮補給。'; Hooks='濁瀑、配水失衡、療養名冊、暗渠旁路'},
  [ordered]@{Slug='skyraptor-aerie'; Name='浮鷹棲巢'; Overview='巨鷹、靈鷲與伴飛生物的巢域，也是曦環真正能迅速把命令變成巡空力量的地方。'; Zones='主巢環、幼羽洞群、飛爪台、守巢崖'; Tone='這裡的安靜不是平靜，而是所有東西都在判斷你值不值得被載走。'; Day='白天是照巢、配飛、餵養和巡空輪替。'; Night='夜裡真正重要的是誰被准許起飛、誰被要求留巢，以及哪條夜線被靈鷹記住。'; Duty='主責伴飛生物照護、巡空力量集結、急件送遞與遠段巡救。'; Season='鎖風季與轉陸季最重，前者重巡救，後者重接應與長程陪航。'; Hooks='灰封條、巢域中轉、雛羽失序、守巢派與外務派'},
  [ordered]@{Slug='duskwhorl-dawncrag'; Name='暮渦曦岑'; Overview='外環靈潮匯流端與檢泊島，所有自外而來的飛具、隊伍與模糊身分，幾乎都會先在這裡被讀取。'; Zones='外環泊架、暮渦檢坪、風報壁、灰候客棚'; Tone='這裡白天很像合法港，夜裡很像沒人敢承認的門縫。'; Day='白天是外客、泊牌、陪航、糾紛和風報發布；這裡是曦環最像港口的地方。'; Night='夜裡多的是灰候棚交易、遲到的飛具、說不清該不該放行的人。'; Duty='主責外環檢泊、風報發布、陪航前核驗與外來飛具管制。'; Season='迎商季最熱，鎖風季最危；前者滿載外客，後者滿載推責與封線。'; Hooks='重複泊牌、風報造假、候客棚失名、灰線作保'},
  [ordered]@{Slug='spiral-harbor-court'; Name='螺環泊庭'; Overview='不屬祖制七島、也不是正式第八主島的附屬外務節點。它本質上是掛在暮渦曦岑外側的一串外環泊庭浮台群，負責對外停泊、貨運分流、外客收容與轉押前置核名。'; Zones='貨簿樓、外務泊圈、轉押亭、纜庭客寮'; Tone='這裡是曦環最會說「只是程序」的地方，而真正見不得光的多半都躲在程序後面。'; Day='白天的泊庭像一組合法外港，把人、貨和名字分類成可以被接受的樣子。'; Night='夜裡它更像緩衝胃袋，把不適合進主環的責任、文件和人暫時含住。'; Duty='主責外務分流、灰壓緩衝、轉押前置核名與泊圈貨簿整理。'; Season='迎商季忙貨，鎖風季忙人；南段暗潮期時更會承受曦環最不想公開的負擔。'; Hooks='失蹤押卷、空白核名、貨簿重寫、潮牢回件'}
)

foreach ($loc in $locs) {
  $path = Join-Path $locDir ($loc.Slug + '.md')
  $extraPos = ''
  if ($loc.Slug -eq 'spiral-harbor-court') {
    $extraPos = @"
## 相對位置
- 位於 `暮渦曦岑外環檢泊線之外`，像主環與外來航線之間的一層緩衝牙。
- 白天看起來像合法外港浮台群，夜裡則常被拿來消化不適合直接進主環的文件、人和貨。

"@
  }
  $text = @"
# $($loc.Name)

## 概述
$($loc.Overview)

## 主要區塊
$($loc.Zones)

$extraPos## 地方調性
- $($loc.Tone)
- 這裡的人先把自己視為 `環的一部分`，再把自己視為個人；因此很多衝突不是情緒，而是責任排序不同。

## 白日節奏
- $($loc.Day)

## 夜間節奏
- $($loc.Night)

## 主要輪值
- $($loc.Duty)

## 與盤旋季節的關係
- $($loc.Season)

## 常見鉤子
- $($loc.Hooks)

## 延伸資料
- [人物明細](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).people.md)
- [商店與服務](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).shops.md)
- [關係網](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).relations.md)
- [地方事件](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).events.md)
- [地方貨品](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).wares.md)
- [地方支線](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).sidequests.md)
- [重要建築](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).buildings.md)
- [攤位與小服務](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/$($loc.Slug).stalls.md)
"@
  $enc = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText($path, $text, $enc)
}

$docs = @{
  'seven-island-flavors-and-duty-cycles.md' = @"
# 曦環七島風情與輪值節奏

## 讀法
曦環的七島不是七座功能建物，而是七種不同的高空生活方式。翼人雖共享同一套守望使命，但在不同主島長大，對責任、失敗、外務與羞恥的理解會有很明顯的差異。

## 七島風情
### 幽璨懸谷
- 語氣最冷，最重名錄、見證與可追溯性。
- 這裡的人很少直接說「我相信你」，更常說「我把你記上去了」。

### 鳴羽台
- 最重紀律與技術，欣賞能撐住錯風的人。
- 對失敗的態度不是羞辱，而是先看你有沒有把失敗寫進下一次訓練。

### 晨光垂岬
- 最像溫柔家園，但也最敏感。
- 這裡的人很會照顧，也最早察覺秩序開始生病。

### 環淵碎脈
- 最硬，也最不信只會蓋印不會冒險的人。
- 他們尊重能把危險做乾淨的人，而不是說話漂亮的人。

### 凌宵潤澤
- 最安靜，但不是最鬆。
- 這裡的人會把每一滴水看成輪值的一部分，因此格外重視細節與延誤成本。

### 浮鷹棲巢
- 最接近野性與命令共存的地方。
- 守巢者通常比議務官更快判斷一個人值不值得托命。

### 暮渦曦岑
- 最懂外面，也最會把危險講得像程序。
- 這裡的成熟不只在飛行，更在看穿誰帶著第二份身分來。

## 輪值節奏差異
- 幽璨：以簿、碑、令、核為節奏。
- 鳴羽：以風、考、補律、再上為節奏。
- 晨光：以露、蘚、養、療為節奏。
- 環淵：以礦、冷、封、檢為節奏。
- 凌宵：以泉、瀑、配額、補流為節奏。
- 浮鷹：以巢、喚、起飛、回落為節奏。
- 暮渦：以泊、檢、候、報為節奏。

## 對失序的不同反應
- 幽璨先查名錄。
- 鳴羽先重做流程。
- 晨光先看誰受傷。
- 環淵先封危險源。
- 凌宵先穩主循環。
- 浮鷹先保活物與航線。
- 暮渦先判要不要讓消息出去。
"@;
  'lowfloat-islets-and-outer-watchposts.md' = @"
# 曦環低浮小島群與外環哨點

## Core Idea
曦環真正讓人覺得龐大的，不只在七島，而在七島之外那一整片 `低浮小島、外環泊坪、補給棚、短棲哨點與臨時風台`。這些地方多半不進神話，但沒有它們，七島根本維持不住。

## 常見類型
### 補給坪
- 用來接短線貨、轉掛纜具、換裝和收露。
- 多半不住完整家戶，只住輪值隊與守坪者。

### 低浮客棚
- 收臨時外客、病羽、等候陪航者與不方便進主環的人。
- 是消息最容易變形的地方。

### 外環哨點
- 用來讀風、觀潮、預警高壓亂流或灰線接近。
- 守哨者地位不高，但很多大事都靠他們第一眼發現。

### 暗夜渡坪
- 正式記錄裡不存在，卻常被必要地使用。
- 最常和潮牢退件、灰件分流、悄悄召回線有關。

## 代表節點
- `夜渡縈坪`：低浮夜路與不該留下的回望。
- `低浮潤塘`：療養、補水與邊緣人短留。
- `雲骨折橋`：舊路與新秩序咬合最緊的地方。
- `璃風檔崖`：被故意放到正式檔樓外的風報證據點。

## 文化上的位置
- 主環會說自己代表曦環。
- 但很多低浮守點的人心裡都很清楚：真正讓曦環不墜的，是那些不被歌唱的小地方。
"@;
  'failure-shame-and-restoration.md' = @"
# 曦環失序、羞恥與修復文化

## Nonhuman Difference
對翼人而言，最可怕的不是單純失敗，而是 `讓自己變成他人的墜落風險`。所以曦環的羞恥感不是面子問題，而是責任失衡問題。

## Common Forms Of Shame
- 在該封線時沒封線。
- 在該報告時把風況寫得更好看。
- 把不能承擔的任務接下來，最後害整條鏈替你收拾。
- 明知某人已不適任，卻為了家系或情面讓他繼續飛。

## Social Consequences
- 被暫停輪值比被責罵更重。
- 被改到低浮補線或邊哨守風，不一定是處罰，但一定是公開降格訊號。
- 名冊裡多一行 `補律中`，比口頭羞辱更讓人難受。

## Restoration Logic
- 曦環不是完全不給人回來的路。
- 但修復不是說歉就算，而是 `重做、補值、見證、再被交付一次責任`。
- 所以真正的寬恕在曦環常表現為：有人願意再次把一段橋、一組學徒、一條夜線交到你手上。

## Why This Matters In Play
- 曦環的衝突往往不是善惡，而是 `誰還值得被再交付一次責任`。
- 這也是為什麼這裡的人不太像一般人類會先談情緒，他們先談的是：你還能不能被放回風裡。
"@
}

foreach ($name in $docs.Keys) {
  $enc = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText((Join-Path $x $name), $docs[$name], $enc)
}

$newSites = @{
  'featherdry-sunyard.md' = @"
# 曬羽垂場

## 概述
專門曬整飛披、修補訓練翼布與檢查濕損束帶的外環曬場，也是很多低階輪值最先學會互相幫忙的地方。

## 場域特徵
- 長索曬架、滴風棚、舊披修補木台

## 常見風險
- 束帶被換、濕損造假、夜間偷取外務披

## 可用切入
- 某批要送去雲裂哨站的披具被人偷偷換成舊料。
"@;
  'windward-ledger-perch.md' = @"
# 迎風簿棲

## 概述
掛在暮渦外環更外側的小觀風棲棚，專門暫存短時風記與陪航改道通知。

## 場域特徵
- 高掛小棚、繩牌夾、易碎風鏡

## 常見風險
- 短報被改、牌夾遺失、故意延後通知

## 可用切入
- 一張改道通知比正式風報早半天被送到不該先知道的人手裡。
"@;
  'restwing-shelf.md' = @"
# 歇翼台層

## 概述
給補律中、病羽或長程陪航後回來的翼人短暫停翼的外側台層，是曦環少數承認疲憊存在的地方。

## 場域特徵
- 低風欄、安肩繩、暖羽棚、小祈風牌

## 常見風險
- 病羽簿被換、療養身份被借用、有人在這裡失蹤

## 可用切入
- 某位本該在台層休養的守翼者，卻被記成已隨夜渡離環。
"@
}
foreach ($name in $newSites.Keys) {
  $enc = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText((Join-Path $siteDir $name), $newSites[$name], $enc)
}
$sitesReadme = @"
# 曦環浮境探索點目錄

- [雲骨折橋](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/cloudbone-broken-bridge.md)
- [空瀑鏡井](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/skyfall-mirror-well.md)
- [封脈碑洞](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/sealed-vein-stelae-cavern.md)
- [曦渦試風廊](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/dawnwhorl-wind-gallery.md)
- [低浮潤塘](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/lowfloat-spring-basin.md)
- [空羽沉坑](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/hollowfeather-pit.md)
- [璃風檔崖](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/glasswind-file-ledge.md)
- [夜渡縈坪](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/nightferry-strand.md)
- [曬羽垂場](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/featherdry-sunyard.md)
- [迎風簿棲](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/windward-ledger-perch.md)
- [歇翼台層](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/restwing-shelf.md)
"@
Write-BomFile = $null
$enc = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText((Join-Path $siteDir 'README.md'), $sitesReadme, $enc)

$newChars = @{
  'guolan.md' = @"
# 谷嵐

## 基本資料
- 種族：翼人
- 種族-分支：翼人 / 曦環羽裔
- 身分：雲谷居帶夜議引導者
- 常駐地：幽璨懸谷

## 人物概述
谷嵐擅長讓議殿裡快要撞上的聲音稍微錯開，但她也知道很多被她錯開的矛盾，最後只是往夜裡更深處沉。

## 可帶出的戲
- 可作為夜議、家系讓步與責任改寫入口。
"@;
  'xiyu.md' = @"
# 汐羽

## 基本資料
- 種族：翼人
- 種族-分支：翼人 / 曦環羽裔
- 身分：南段暗潮季陪航使
- 常駐地：暮渦曦岑

## 人物概述
汐羽很懂外海船隊怕什麼，也很懂哪些人會把害怕寫成價碼。她笑得比多數守翼者鬆，但每次接單前都會先看潮牢那邊有沒有新封條。

## 可帶出的戲
- 可作為迎商季陪航、暗潮帶灰件與潮牢影線入口。
"@;
  'qi.md' = @"
# 霁

## 基本資料
- 種族：翼人
- 種族-分支：翼人 / 曦環羽裔
- 身分：歇翼台層守簿人
- 常駐地：晨光垂岬

## 人物概述
霁是少數會直接承認「有些人就是累了」的曦環人。她不浪漫，但很知道一個人是在補律，還是在快被秩序壓扁。

## 可帶出的戲
- 可作為病羽、補律、低風療養與失序修復入口。
"@;
  'suocen.md' = @"
# 索岑

## 基本資料
- 種族：翼人
- 種族-分支：翼人 / 曦環羽裔
- 身分：螺環外纜總驗官
- 常駐地：螺環泊庭

## 人物概述
索岑不相信巧合。他看一根纜的磨痕，就能猜到這條線最近拉過貨、拉過人，還是拉過不該留下名字的東西。

## 可帶出的戲
- 可作為外務纜線、轉押前置、夜渡暗路與外港漏洞入口。
"@
}
foreach ($name in $newChars.Keys) {
  [System.IO.File]::WriteAllText((Join-Path $charDir $name), $newChars[$name], $enc)
}
$charReadme = Get-Content (Join-Path $charDir 'README.md') -Raw
if ($charReadme -notmatch '谷嵐') {
  $charReadme = $charReadme -replace '## 支援角色名錄', "- [谷嵐](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/guolan.md)`r`n- [汐羽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/xiyu.md)`r`n- [霁](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/qi.md)`r`n- [索岑](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/suocen.md)`r`n`r`n## 支援角色名錄"
  [System.IO.File]::WriteAllText((Join-Path $charDir 'README.md'), $charReadme, $enc)
}
$support = Get-Content (Join-Path $charDir 'supporting-cast.md') -Raw
if ($support -notmatch '潮喙匠') {
  $support += "`r`n- 潮喙匠：專修長程陪航鳥喙護具的老匠。`r`n- 峽鐘姐：在雲谷居帶替人記夜議先後順序。`r`n- 泊灰叔：知道哪批貨該進簿、哪批貨該只進記憶。`r`n- 引雛：教幼羽辨認低浮島安全風口的年輕教帶者。`r`n"
  [System.IO.File]::WriteAllText((Join-Path $charDir 'supporting-cast.md'), $support, $enc)
}

$newQuestMap = @{
  'xihuan-floating-quest-17.md' = @"
# 迎商季的雙重陪航契

## 起因
一支外海商隊同時拿出兩份都帶有合法陪航印的契紙，要求曦環照較便宜的那份履約。

## 推進節點
- 先核對暮渦曦岑的陪航簿與汐羽手上的潮段記錄。
- 再前往螺環泊庭、迎風簿棲與外環泊圈比對印式差異。
- 最後決定要保哪一份契、要斷哪一條灰線。

## 風險
若假契被當成真契履行，整條迎商季陪航信用都會被拖進價格戰。

## 可能結果
保住官方信用、默許一筆灰利，或放出更大的內鬼名單。
"@;
  'xihuan-floating-quest-18.md' = @"
# 守脈季的缺水順序

## 起因
守脈季初期的配水表把一批低浮療養戶排到最後，引發晨光垂岬與凌宵潤澤之間的冷戰。

## 推進節點
- 查泉記樓的改表痕跡。
- 走訪低浮潤塘、晨光垂岬與主源瀑心。
- 判斷這是技術誤差、家系偏袒，還是有人故意讓病羽群體先消失。

## 風險
若低浮療養戶先被切斷水序，曦環會用秩序名義親手放棄自己最脆弱的人。

## 可能結果
重排水序、找出改表者，或揭開一條長期被合理化的犧牲線。
"@;
  'xihuan-floating-quest-19.md' = @"
# 轉陸季的失聯哨羽

## 起因
雲裂哨站回報少了一組本該來接替的翼人，最後的風牌卻出現在曬羽垂場。

## 推進節點
- 檢查鳴羽台訓名、曬羽垂場裝具與迎風簿棲短報。
- 追查那組哨羽究竟是迷航、被調走，還是根本沒被打算送出主環。
- 最後在邊線穩定與內部遮掩之間取捨。

## 風險
若轉陸季的接應線是假的，曦環對陸地哨站的整體承諾都會變成空話。

## 可能結果
補上接應、揭露調度造假，或讓某條邊線自己撐過一次沉默失職。
"@;
  'xihuan-floating-quest-20.md' = @"
# 鎖風季的提前封橋令

## 起因
鎖風季尚未正式進入最高風級，卻已有人提前封掉通往外環的數段橋路。

## 推進節點
- 比對鳴羽台試風紀錄、幽璨議令與索岑掌握的外纜報告。
- 查明這是高風預警，還是為了掩蓋某批人與貨的移動而故意提前封線。
- 決定是否強行重開其中一橋。

## 風險
錯封會害外環出事，錯開又可能放走真正該被堵住的人。

## 可能結果
保住封線正當性、揭發假封橋，或讓曦環必須公開承認自己也會把程序當遮羞布。
"@
}
foreach ($name in $newQuestMap.Keys) {
  [System.IO.File]::WriteAllText((Join-Path $questDir $name), $newQuestMap[$name], $enc)
}
$questlines = Get-Content (Join-Path $regionDir 'questlines.md') -Raw
if ($questlines -notmatch '任務 17') {
  $questlines += "`r`n- [任務 17：迎商季的雙重陪航契](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-17.md)`r`n- [任務 18：守脈季的缺水順序](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-18.md)`r`n- [任務 19：轉陸季的失聯哨羽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-19.md)`r`n- [任務 20：鎖風季的提前封橋令](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-20.md)`r`n"
  [System.IO.File]::WriteAllText((Join-Path $regionDir 'questlines.md'), $questlines, $enc)
}
$details = Get-Content (Join-Path $regionDir 'quest-details.md') -Raw
if ($details -notmatch '## 17 迎商季的雙重陪航契') {
  $details += @"

## 17 迎商季的雙重陪航契
- 起點：外海商隊拿出兩份都帶合法印的陪航契。
- 涉及地點：暮渦曦岑、螺環泊庭、迎風簿棲
- 主要風險：曦環迎商季的陪航信用可能被拖進價格戰與內鬼問題。
- 可能結局：保住官方信用、放出內鬼，或默許某條灰利線繼續活著。

## 18 守脈季的缺水順序
- 起點：配水表把低浮療養戶排到最後。
- 涉及地點：凌宵潤澤、晨光垂岬、低浮潤塘
- 主要風險：曦環可能用秩序名義親手放棄自己最脆弱的人。
- 可能結局：重排水序、找出改表者，或揭開長期被合理化的犧牲線。

## 19 轉陸季的失聯哨羽
- 起點：雲裂哨站少了一組本該到位的接替翼人。
- 涉及地點：鳴羽台、曬羽垂場、迎風簿棲
- 主要風險：若接應線是假的，曦環對陸地哨站的承諾會失去可信度。
- 可能結局：補上接應、揭露調度造假，或讓邊線自己承受一次沉默失職。

## 20 鎖風季的提前封橋令
- 起點：正式進入最高風級前，多段橋路已被提前封掉。
- 涉及地點：幽璨懸谷、鳴羽台、螺環泊庭
- 主要風險：錯封會害外環出事，錯開又可能放走真正該堵住的人。
- 可能結局：保住封線正當性、揭發假封橋，或迫使曦環承認程序也會被拿來遮醜。
"@
  [System.IO.File]::WriteAllText((Join-Path $regionDir 'quest-details.md'), $details, $enc)
}

$readme = Get-Content (Join-Path $x 'README.md') -Raw
foreach ($entry in @('seven-island-flavors-and-duty-cycles.md','lowfloat-islets-and-outer-watchposts.md','failure-shame-and-restoration.md')) {
  if ($readme -notmatch [regex]::Escape($entry)) {
    $insert = ''
    switch ($entry) {
      'seven-island-flavors-and-duty-cycles.md' { $insert = "- [七島風情與輪值節奏](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/seven-island-flavors-and-duty-cycles.md)`r`n" }
      'lowfloat-islets-and-outer-watchposts.md' { $insert = "- [低浮小島群與外環哨點](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/lowfloat-islets-and-outer-watchposts.md)`r`n" }
      'failure-shame-and-restoration.md' { $insert = "- [失序、羞恥與修復文化](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/failure-shame-and-restoration.md)`r`n" }
    }
    $readme = $readme -replace '## 地方與探索', ($insert + "`r`n## 地方與探索")
  }
}
[System.IO.File]::WriteAllText((Join-Path $x 'README.md'), $readme, $enc)

$playText = @"
# 曦環浮境可玩層矩陣

## 區域入口
- [曦環浮境區域包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/README.md)
- [曦環浮境總覽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/overview.md)

## 地方與探索
- [曦環浮境地方包索引](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/xihuan-location-index.md)
- [相對距離與島際路線](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/routes-and-distance.md)
- [雲域生態與高空伴生物](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/ecology-and-cloudlife.md)
- [低浮小島群與外環哨點](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/lowfloat-islets-and-outer-watchposts.md)

## 人物與制度
- [曦環浮境角色索引](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/README.md)
- [治理、巡空與外務秩序](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/governance-and-aerial-orders.md)
- [律令、誓印與高空裁斷](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/laws-and-oath-judgment.md)
- [失序、羞恥與修復文化](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/failure-shame-and-restoration.md)

## 任務入口
- [任務線總表](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/questlines.md)
- [任務細節](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/quest-details.md)

## 目前覆蓋
- 主地方包：`8`
- 探索點：`11`
- 核心角色卡：`20`
- 獨立任務檔：`20`
"@
[System.IO.File]::WriteAllText($play, $playText, $enc)
