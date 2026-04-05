$utf8Bom = New-Object System.Text.UTF8Encoding($true)

function Write-Utf8Bom {
    param(
        [string]$Path,
        [string]$Content
    )
    $dir = [System.IO.Path]::GetDirectoryName($Path)
    if ($dir -and -not (Test-Path $dir)) {
        [System.IO.Directory]::CreateDirectory($dir) | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, $utf8Bom)
}

function Ensure-LineAfter {
    param(
        [string]$Path,
        [string]$Anchor,
        [string]$Line
    )
    $content = [System.IO.File]::ReadAllText($Path)
    if ($content.Contains($Line)) { return }
    if (-not $content.Contains($Anchor)) { return }
    $content = $content.Replace($Anchor, "$Anchor`r`n$Line")
    [System.IO.File]::WriteAllText($Path, $content, $utf8Bom)
}

function Ensure-RealmSections {
    param(
        [string]$Path,
        [string]$HouseholdSection,
        [string]$BeastSection
    )
    $content = [System.IO.File]::ReadAllText($Path)
    if ($content.Contains("## 家系與地方日常")) { return }
    $marker = "## 信仰與祭儀概況"
    if (-not $content.Contains($marker)) { return }
    $insert = $HouseholdSection + "`r`n`r`n" + $BeastSection + "`r`n`r`n" + $marker
    $content = $content.Replace($marker, $insert)
    [System.IO.File]::WriteAllText($Path, $content, $utf8Bom)
}

function Ensure-BeforeMarker {
    param(
        [string]$Path,
        [string]$Marker,
        [string]$Line
    )
    $content = [System.IO.File]::ReadAllText($Path)
    if ($content.Contains($Line)) { return }
    if (-not $content.Contains($Marker)) { return }
    $content = $content.Replace($Marker, "$Line`r`n$Marker")
    [System.IO.File]::WriteAllText($Path, $content, $utf8Bom)
}

$root = 'C:\Users\rabbi\OneDrive\Desktop\Elaris\content\world\02-continents\04-isamel'
$creRoot = 'C:\Users\rabbi\OneDrive\Desktop\Elaris\content\world\09-creatures\isamel'
$charRoot = 'C:\Users\rabbi\OneDrive\Desktop\Elaris\content\world\07-characters'

Write-Utf8Bom "$root\isamel-households-and-kin-structures.md" @'
# 伊莎梅爾家系、戶群與承責結構

伊莎梅爾的精靈文明雖然同屬 `葉脈命名諸傳`，但家系不是單純的血緣樹狀圖，而是 `命名、養護、路權、守林、育伴與送眠責任` 交織成的承責網。

## 共通原則
- 大多數文明域都同時承認 `血枝家系`、`誓責戶群` 與 `見習承戶`。
- 孩子不一定只由一對長親教養，常見是 `啟名者 + 日常照看者 + 技藝導師 + 伴生見證者` 共同承擔成長責任。
- 是否能被視為某一戶的正式成員，除了出生，還取決於 `啟名、守靜、見習、尋伴與首次承責` 是否被公開見證。
- 對多數精靈而言，真正可恥的不是血緣混亂，而是 `責任線不清`。

## 雲瑟與共生戶
- 雲瑟常見 `枝庭戶`、`穴廊戶` 與 `共息戶` 混編。
- 雲瑟皇族與巴布窟族共息穴民的共生，不是附屬，而是寫進正典的共同承責。
- 一個孩子可能在枝庭學記名，在穴廊學守靜，再於育羽庭完成尋伴見證。

## 瑟塔嶺與風脊戶
- 瑟塔嶺多以 `風望家`、`牧龍家`、`鞍工家`、`守脊家` 區分。
- 家系的重量來自誰能守住高脊、馭住風龍、保住路權，而不是誰擁有最多土地。
- 年輕成員若未通過高風承責，仍會被當作未真正成人。

## 菲露涅與照護戶
- 菲露涅多以 `護林戶`、`藥脂戶`、`照伴戶`、`橋守戶` 為主。
- 家系威望常由 `誰最能照看人與林` 決定，而非由武力或財富決定。
- 被羽鳳、花翎幼龍或病斑修復責任選中的年輕人，常會改變原本家戶分工。

## 維塔蕾與漂橋戶
- 維塔蕾以 `泊戶`、`橋戶`、`編索戶`、`低潮見證戶` 組成。
- 很多戶不是固定住在一個屋舍，而是跟著浮橋、泊位與水位移動。
- 誰替一條橋負責、誰替一批漂棚過冬，比誰是誰的直系後裔更重要。

## 雅席爾與澤錄戶
- 雅席爾的戶群多圍繞 `祭沼、眠礦、水脈與雨季表` 組成。
- 澤錄官、汛師、取樣者與調汛工常來自不同戶群，但會在雨季被編成同一責任戶。
- 一旦封沼期被破，常不是單一個人犯錯，而是整個戶群共同失責。

## 歐羅瑟與守崖戶
- 歐羅瑟常見 `聽崖戶`、`守訊戶`、`骨路戶`、`潮門戶`。
- 家系分量來自 `誰能正確地聽見、傳出、守住沿岸的真訊號`。
- 孩子最早學的往往不是文字，而是辨聲、複述與沉默。

## 奧里梵與試道路戶
- 奧里梵的戶群往往沿著一條晨火試道或火藤路建立。
- 常見的責任戶有 `試道路戶`、`切迷戶`、`火露戶`、`護徑戶`。
- 一個人若能把一條危路護成可承誓之路，就算真正為家系立名。

## 米蘭羽與靜泊戶
- 米蘭羽常見 `泊簿戶`、`聽池戶`、`盲沼引路戶`、`灰翎照看戶`。
- 很多戶群會刻意把休息、工作與守夜拆開，避免整戶被同一場迷霧拖垮。
- 誰能在迷澤裡保持不亂、不驚、不誤導，才算真正會過日子。

## 霜諾蘭與回名戶
- 霜諾蘭多由 `送眠戶`、`冬井戶`、`冰橋戶`、`名墓戶` 組成。
- 高寒環境讓他們的家系比其他文明域更仰賴共享庫與共同守橋。
- 有些孩子是在送眠隊、補橋隊與名錄隊輪替中長大的，成年感幾乎等於「終於能被信任去守別人的最後一程」。

## 與玩家的關係
- 玩家進到伊莎梅爾時，最常遇到的不是「這是哪個貴族家族」，而是「這人現在替哪一條責任線站著」。
- 若玩家能分清 `血枝家系`、`責任戶群` 與 `見習承戶` 的差異，會更容易理解地方關係。
'@

Write-Utf8Bom "$root\isamel-everyday-life-and-domestic-rhythms.md" @'
# 伊莎梅爾日常生活與居家節奏

伊莎梅爾的日常不是抽掉神聖後剩下的普通生活，而是 `神聖如何被安靜地編進每天做的事裡`。一餐、一橋、一盞霧燈、一段育伴靜期，往往同時是家務、技藝與信仰。

## 共通日常節奏
### 清晨
- 多數文明域會先確認節點是否安穩，再安排工作。
- 清晨常是聽鳴、讀霧、看水位、檢橋、翻簿與看伴生巢位的時間。

### 白日
- 白日是主要工藝、路務、照護與見習時段。
- 孩子通常不是被關在單一學屋，而是跟著戶群、導師、照看者一起在工作中學。

### 黃昏
- 黃昏常是回錄、補記、短祭、守橋換班與伴生回棲確認。
- 很多地方的晚餐會先等最晚一隊守路者或照護者回來才開。

### 夜間
- 夜間在伊莎梅爾不一定安靜，但一定講究節奏。
- 雲瑟和米蘭羽偏靜聽與守簿；瑟塔嶺與霜諾蘭則常留有高風與守橋夜班。

## 九域的生活感差異
### 雲瑟
- 早晨先聽母樹弱鳴與根鐘窟回聲。
- 家務最常和記名、育伴、祠井照看交纏。
- 一個家裡最被看重的，常是誰最穩，最不會讓名字出錯。

### 瑟塔嶺
- 日常高度受風窗與高脊通行條件支配。
- 飛龍、韁具、鞍索、路牌與測風器就像家常器具。
- 很多家庭的晚飯，是在守脊人全數回來後才真正開始。

### 菲露涅
- 藥脂、護林、看枝、安巢與照伴就是日常。
- 屋舍常和林橋、歇院、藥棚一體使用。
- 這裡的溫柔是勞動，不是裝飾。

### 維塔蕾
- 水位、泊位、橋索與浮棚決定一天節奏。
- 很多孩子從小就會幫忙看樁、收索、聽鈴。
- 他們的一天常是先保住會動的家，再談其他事。

### 雅席爾
- 雨季、汛期、取樣期和封沼期幾乎決定全部日常。
- 一頓飯能不能煮得成，往往也得看祭沼那天准不准取料。
- 這裡的安穩很少來自靜止，而是來自對節律的服從。

### 歐羅瑟
- 崖訊、潮聲、骨路維護、鹽霧木藝與沿岸聯防交織成日常。
- 很多家庭吃飯前會先復述一次今天的真訊與假訊。
- 他們過日子的方式，是盡量不讓錯誤聲音變成真正災難。

### 奧里梵
- 試道、守線、控火、切迷與工坊演訓是生活主軸。
- 火露、護具與藤材幾乎無處不在。
- 這裡連休息都帶著「下一次出路時能不能更穩」的訓練感。

### 米蘭羽
- 迷霧、泊簿、慢行與回述構成日常節奏。
- 他們的日常並不慢，而是非常節省錯誤。
- 許多家庭最重視的是誰能讓一整晚都不出錯。

### 霜諾蘭
- 補橋、存糧、送眠、回名、暖井與寒穴守視佔滿了日常。
- 霜諾蘭的家裡幾乎一定有和路、眠、名錄相關的工具。
- 他們的溫情常出現在很硬的事上，例如把人、名字和隊伍都帶回來。

## 與靈誓伴和神獸的日常
- 伊莎梅爾的伴生不是閒暇娛樂，而是戶群工作的一部分。
- 小型精靈龍的停棲位、飛龍的風脊棚、鳳裔的靜枝區，都會直接改變住屋佈局。
- 若伴生或神獸亞裔在日常節奏上出現明顯異常，通常會先被當作家庭與地方事件，而不是遠方奇觀。
'@

Write-Utf8Bom "$creRoot\great-dragons-and-high-skyriders.md" @'
# 伊莎梅爾大型飛龍與高空主權獸

伊莎梅爾的大型飛龍不是普遍家畜，而是 `高風責任、遠脊巡守、危路壓制與天空秩序` 的承擔者。它們常被視為一條文明域是否仍有資格為高空說話的證明。

## 共通特徵
- 體型遠大於小型精靈龍，且足以承擔長距離高空載運、風道巡守或高差搜救。
- 理解力高，但多數不接受頻繁更換承誓者。
- 對 `風、責任與路權` 極其敏感；如果覺得一條路不再被正確承擔，常會先拒飛。

## 主要譜線
### 天輝風龍
- 瑟塔嶺最具代表性的高風主龍。
- 專長：高風切面飛行、長距離風壓穩定、在雲壁間改道。
- 文化定位：高風誓望與飛龍認可的核心象徵。

### 冠脊飛龍
- 瑟塔嶺與霜諾蘭共通可辨的古老山脊飛龍支脈。
- 專長：高差盤旋、斷脊搜救、邊脊巡望。
- 文化定位：高脊責任不是口號，而是要真的飛得回來。

### 岸巡飛龍
- 歐羅瑟最常見的大型飛龍。
- 專長：海崖逆風巡守、沿岸訊號投遞、緊急撤離。
- 文化定位：岸路與崖訊能否被信任，很多時候看牠們是否還願意飛那條線。

### 蔓焰滑翼龍
- 奧里梵的高風滑翼龍支脈。
- 專長：穿越火霧、切入藤道上空、短距離高速俯掠。
- 文化定位：試道正統、責任先行與火路承誓的象徵。

### 寒脊飛龍
- 霜諾蘭最有名的高寒大型飛龍。
- 專長：低溫夜巡、雪霧識路、冰橋危段快速轉位。
- 文化定位：在寒裡還能把人與名字帶回來的最後保險。

## 較少見但被承認的跨域支脈
- `林冠長翼飛龍`
  - 菲露涅偶有記錄，多半只在林冠高風口短暫停駐，不形成主馭龍體系。
- `潮霧長頸風龍`
  - 維塔蕾與歐羅瑟交界偶有目擊，多被視為沿岸遠巡變支。
- `眠霧高穴飛龍`
  - 霜諾蘭寒穴深段偶有古老譜線記錄，現多半不主動接近聚落。

## 與精靈的關係
- 並非每個文明域都把大型飛龍當作可普遍馭使的存在。
- 伊莎梅爾對大型飛龍更接近 `承誓合作`，不是單向命令。
- 誰能接近、誰能坐上去、誰能在牠耳邊發出第一個命令，都屬於高位責任問題。

## 禁忌
- 不得用假誓、偽命名或強迫性術式逼龍就範。
- 不得把大型飛龍當成單純的運貨工具或軍械。
- 若一條飛龍公開拒絕某段路，通常先停路，而不是先責怪牠。
'@

Write-Utf8Bom "$creRoot\phoenix-and-immortal-bird-sublineages.md" @'
# 伊莎梅爾鳳裔與不死鳥亞種譜系

伊莎梅爾的鳳裔與不死鳥亞種，比大型飛龍更接近 `記憶、守靜、焚穢、回燼與再證`。牠們未必常現身，但一旦出現，往往代表某種秩序正在被看見。

## 共通特徵
- 高智慧、高記憶性，對儀式秩序與照護品質非常敏感。
- 不一定會長時間棲居在聚落中心，多以 `靜枝、祭樁、眠羽澤、寒井邊帶` 為主要活動範圍。
- 翎灰、落羽與回燼痕不是普通素材，幾乎都要經過見證才能取用。

## 主要支脈
### 雲瑟不死鳥
- 雲瑟皇族最重視的鳳裔支脈。
- 常和母樹高枝、回名、大祭與舊誓公開再見證相連。
- 對共生秩序的失衡尤其敏感。

### 翡翠羽鳳亞裔
- 菲露涅最具代表性的羽鳳譜線。
- 常在林冠靜枝期出現，擅長用停棲與離枝表明照護秩序是否正確。

### 低潮鐘羽鳳
- 維塔蕾的濕地鳳裔。
- 會以鐘羽拍動與低鳴回應橋泊誓序是否穩定。

### 睡霧羽鳳
- 雅席爾的沉雨鳳裔。
- 在封沼與祭沼失衡時特別容易離巢。

### 鹽霧火尾鳳
- 歐羅瑟的沿岸鳳裔。
- 對錯訊、假烽與骨路失序十分敏感。

### 曉燼羽鳳
- 奧里梵的火道鳳裔。
- 常出現在試道、封火期與責任重編之際。

### 眠羽回燼鳳
- 米蘭羽最神祕也最溫柔的一支。
- 與靜泊、回燼、聽池守唱與盲沼照看有深連結。

### 霧燼鳳亞裔
- 霜諾蘭的寒穴鳳裔。
- 常在送眠、封霜與名墓再記時出現。

## 鳳裔與死亡秩序
- 鳳裔不是死亡之神的替代，而更像 `記憶沒有被粗暴拋下` 的神聖保證。
- 在伊莎梅爾，若某場送眠、回名或大規模補錄中有鳳裔穩定停棲，會被視為一種近乎節點承認的安定訊號。

## 常見誤解
- 鳳裔不等於永遠不死；更準確地說，牠們擅長以回燼、再證與記憶續接來面對終止。
- 不是每一根羽毛都能當聖物。真正被承認的灰羽、落羽極少。
'@

Write-Utf8Bom "$creRoot\sacred-beast-care-and-aeries.md" @'
# 伊莎梅爾神獸照護、巢庭與育伴空間

伊莎梅爾的神獸亞裔不只是自然生物，也不是單純祭祀象徵。牠們的育養、安巢、巡棲與承誓，會直接改變各文明域的住居與工作安排。

## 三種常見照護空間
### 育巢庭
- 主要用於小型精靈龍與初次尋伴個體。
- 常見於雲瑟、菲露涅與維塔蕾。
- 強調靜、光、溫度與可退避枝位。

### 龍棚與風脊停位
- 主要用於大型飛龍。
- 常見於瑟塔嶺、奧里梵與霜諾蘭。
- 強調承風角度、進出坡度、韁具保養與夜間值守。

### 靜枝區與回燼場
- 主要用於鳳裔與不死鳥亞種。
- 常見於菲露涅、米蘭羽、霜諾蘭與雲瑟。
- 強調不可驚擾、不可強光、不可混亂圍觀。

## 照護者類型
- `育巢師`
  - 負責幼龍與初次尋伴個體的靜養、記錄與退避安排。
- `育契官`
  - 負責承誓、見證與照護責任分配。
- `棚守者`
  - 負責大型飛龍停位、韁具、風位與夜間巡視。
- `灰羽照看者`
  - 負責鳳裔棲枝、落羽、靜枝期與回燼場守序。

## 九域差異
### 雲瑟
- 最重視 `小型花翎龍与靈枝誓龍` 的育巢與停棲記錄。
- 育伴照護往往和命名見證綁在一起。

### 瑟塔嶺
- 最重視大型飛龍的風位、韁具與高脊承誓。
- 誰有資格碰第一條韁，屬於高位責任。

### 菲露涅
- 最重視照護節律與靜枝品質。
- 這裡的神獸照看很像長期看護，而不是馴養。

### 維塔蕾
- 最重視低潮與濕地條件下的巢位安全。
- 幼龍與橋泊節律會互相影響。

### 雅席爾
- 最重視節律與封區時機。
- 若祭沼節奏錯了，沼光幼龍會先表現出來。

### 歐羅瑟
- 最重視沿岸崖巢與訊號視野。
- 神獸照看常與守崖、守訊工作合一。

### 奧里梵
- 最重視試道安全與晨火幼龍的路感。
- 幼龍若拒路，整條試道都得重審。

### 米蘭羽
- 最重視不驚動與靜泊期。
- 鳳裔與小龍的異常安靜本身就是重要訊號。

### 霜諾蘭
- 最重視寒穴保暖、冰橋通行與寒脊飛龍夜巡秩序。
- 送眠期的神獸照看負擔通常最大。

## 禁忌
- 不得在未經見證下私換巢位、私取灰羽、私改停棲記錄。
- 不得以炫耀、旅演或貨運為目的逼迫神獸亞裔表演。
- 若幼龍、飛龍或鳳裔公開拒絕某人，通常先檢討人，不先壓生靈。
'@

$chars = @(
    @{
        Realm = 'yunselin'
        RealmTitle = '雲瑟靈雲冠域'
        Branch = '精靈 / 雲瑟皇族'
        File = 'zhimian.md'
        Name = '枝眠'
        Role = '母樹幼鱗育巢師'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/yunselin/chenghua-mothertree.md'
        LocLabel = '澄華母樹庭'
        Summary = '枝眠長年照看小型花翎龍與靈枝誓龍的初巢區，最擅長判斷一個孩子是單純緊張，還是真的還沒準備好承接靈誓伴的重量。她不屬於高位神職，卻深知一個文明若連育巢都急，就會把很多看似神聖的事做得很粗。'
        Ethics = '理解雲瑟的育伴不是寵養，而是讓名字、責任與另一個敏感生命一起長大'
        ReadmeTitle = '雲瑟靈雲冠域角色索引'
    },
    @{
        Realm = 'thertalyn'
        RealmTitle = '瑟塔嶺星墜臺原'
        Branch = '精靈 / 瑟塔嶺族'
        File = 'lanjiang.md'
        Name = '嵐韁'
        Role = '高脊育龍韁具師'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/thertalyn/baiji-springcourt.md'
        LocLabel = '白脊泉庭'
        Summary = '嵐韁專門替仍在高脊見習期的飛龍調整第一套正式韁具。他相信一副韁如果只為控制而做，最後一定會害死人與龍，所以他的工法總是比別人慢，卻也更被真正跑過高風的人信任。'
        Ethics = '理解瑟塔嶺把韁具視為責任契約，而不是單純馭龍器械'
        ReadmeTitle = '瑟塔嶺星墜臺原角色索引'
    },
    @{
        Realm = 'filune'
        RealmTitle = '菲露涅羽蔭林庭'
        Branch = '精靈 / 菲露涅族'
        File = 'lingtai.md'
        Name = '翎苔'
        Role = '羽鳳巢枝照護師'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/filune/bixi-restbay.md'
        LocLabel = '碧息歇灣'
        Summary = '翎苔負責記錄翡翠羽鳳靜枝期的落羽、巢枝與近域動線。他不算有權勢的人，但許多護林者都知道，只要翎苔一句「今天不能動」，最好就真的先別動。'
        Ethics = '理解菲露涅的照護不是溫柔姿態，而是需要節制與分配的勞動'
        ReadmeTitle = '菲露涅羽蔭林庭角色索引'
    },
    @{
        Realm = 'vithare'
        RealmTitle = '維塔蕾漂葦林灣'
        Branch = '精靈 / 維塔蕾族'
        File = 'luling.md'
        Name = '蘆鈴'
        Role = '漂棚幼鱗照看師'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/vithare/dianshui-lowdock.md'
        LocLabel = '點水低泊埠'
        Summary = '蘆鈴照看的是最容易被忽略的那些漂棚幼鱗：還不能穩定掠水、又開始對橋鈴與潮位太敏感的小型精靈龍。她最擅長在一片忙亂裡先把幼鱗和孩子都安靜下來。'
        Ethics = '理解維塔蕾的橋泊秩序其實是靠很多看似不起眼的日常照看撐住'
        ReadmeTitle = '維塔蕾漂葦林灣角色索引'
    },
    @{
        Realm = 'yathire'
        RealmTitle = '雅席爾沉雨澤境'
        Branch = '精靈 / 雅席爾族'
        File = 'nizhao.md'
        Name = '泥照'
        Role = '沼光幼龍標汛守'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/yathire/chenmu-bogrest.md'
        LocLabel = '沉木澤歇'
        Summary = '泥照負責替沼光幼龍標記安全汛線與回巢節點。很多人把他當成只會和泥水說話的怪人，但真正出過雨季的人都知道，若他說某段沼路今天不能再踩，就最好別逞強。'
        Ethics = '理解雅席爾把節律與生存綁在一起，很多慢其實是在替未來保命'
        ReadmeTitle = '雅席爾沉雨澤境角色索引'
    },
    @{
        Realm = 'olorase'
        RealmTitle = '歐羅瑟聽潮岸林'
        Branch = '精靈 / 歐羅瑟族'
        File = 'anling.md'
        Name = '岸翎'
        Role = '崖巢引羽人'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/olorase/chaogen-saltroost.md'
        LocLabel = '潮根鹽棲'
        Summary = '岸翎負責看顧岸巡飛龍與潮棘小龍在海岬上的崖巢。他對聲音極敏感，甚至能從幼龍半夜換棲的方向猜到第二天哪一段骨路最容易出事。'
        Ethics = '理解歐羅瑟的守望不只是看見海，而是看見哪些聲音值得被相信'
        ReadmeTitle = '歐羅瑟聽潮岸林角色索引'
    },
    @{
        Realm = 'aulifan'
        RealmTitle = '奧里梵晨火蔓叢'
        Branch = '精靈 / 奧里梵族'
        File = 'huoyou.md'
        Name = '火釉'
        Role = '晨火幼龍路訓師'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/aulifan/chenhua-court.md'
        LocLabel = '晨華庭'
        Summary = '火釉專門帶晨火幼龍熟悉試道路感與退避手勢。他總說真正的路訓不是把幼龍訓得勇敢，而是把牠們訓得知道什麼時候可以拒絕一條不該走的路。'
        Ethics = '理解奧里梵的責任感不是逞強，而是知道什麼時候該停'
        ReadmeTitle = '奧里梵晨火蔓叢角色索引'
    },
    @{
        Realm = 'milanyu'
        RealmTitle = '米蘭羽迷澤川'
        Branch = '精靈 / 米蘭羽族'
        File = 'borong.md'
        Name = '泊絨'
        Role = '眠羽回燼鳳灰翎護守'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/milanyu/ditide-roothold.md'
        LocLabel = '低潮根堡'
        Summary = '泊絨的工作是看顧眠羽回燼鳳在靜泊期遺下的灰翎與停枝序。他幾乎從不大聲說話，但只要他開口提醒某段霧路不能驚動，所有還想活著回來的人都會聽。'
        Ethics = '理解米蘭羽的安靜不是拖延，而是一種保命與保真的技藝'
        ReadmeTitle = '米蘭羽迷澤川角色索引'
    },
    @{
        Realm = 'shranolan'
        RealmTitle = '霜諾蘭眠霧寒穴'
        Branch = '精靈 / 霜諾蘭族'
        File = 'shuangsuo.md'
        Name = '霜索'
        Role = '寒脊龍棚守索者'
        LocPath = 'C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/shranolan/dongming-coldarchive.md'
        LocLabel = '冬銘寒庫'
        Summary = '霜索看的是寒脊飛龍的棚索、冰橋邊索與夜巡回位。他不是神職，也不是將領，但在真正的風雪夜裡，很多隊伍只相信他的索結和他點頭過的出發時機。'
        Ethics = '理解霜諾蘭的秩序之所以沉重，是因為很多索一鬆就會真的死人'
        ReadmeTitle = '霜諾蘭眠霧寒穴角色索引'
    }
)

foreach ($c in $chars) {
    $charPath = "$charRoot\$($c.Realm)\$($c.File)"
    $charContent = @"
# $($c.Name)

## 身分
- 所屬文明域：$($c.RealmTitle)
- 種族：精靈
- 種族-分支：$($c.Branch)
- 角色定位：$($c.Role)
- 常見出沒：[$($c.LocLabel)]($($c.LocPath))

## 簡述
$($c.Summary)

## 互動方向
- 可作為地方生活、育伴秩序、神獸照看與家系責任相關事件的第一層窗口。
- 不太會直接給出高位裁定，但很清楚一件事實際落到生活裡會怎麼壞掉。
- 若玩家能理解這套地方倫理，尤其是：$($c.Ethics)，會更願意給出深層協助。
"@
    Write-Utf8Bom $charPath $charContent
}

$realmSections = @{
    'yunselin-spiritcloud-canopy.md' = @{
        Household = @'
## 家系與地方日常
雲瑟的家系更像一種承責編制，而不是單純血統樹。皇族枝庭、穴民共息戶、育羽庭與見證工舍常會共同養大同一批孩子；誰替他守過第一次靜期、誰陪他熬過尋伴禮，往往比誰與誰同枝更重要。
'@
        Beast = @'
## 神獸照看與日常相處
雲瑟與小型花翎龍、靈枝誓龍的相處極日常化。幼龍會停在枝橋欄木、育羽庭架與祠井旁的靜棲位上，若某日牠們不肯停、或反覆換肩，整個枝庭通常會先查名字與責任線，而不是先怪生靈。
'@
        CharacterLine = '- [枝眠](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yunselin/zhimian.md)｜母樹幼鱗育巢師'
    }
    'thertalyn-starfall-plateau.md' = @{
        Household = @'
## 家系與地方日常
瑟塔嶺的家庭常沿風脊、牧群與鞍工責任分布。許多家戶不是圍著一間屋，而是圍著一段風脊、一座停龍臺與一套保養得當的韁具過日子；真正被敬重的家，不一定最富，而是最能讓人與龍都平安回來。
'@
        Beast = @'
## 神獸照看與日常相處
大型飛龍在這裡不是奢侈資源，而是天空秩序的一部分。孩子很早就會學測風、遞韁、辨翼膜磨損；若飛龍拒絕新路或新韁，瑟塔嶺人多半先懷疑自己是不是哪裡失了責。
'@
        CharacterLine = '- [嵐韁](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/thertalyn/lanjiang.md)｜高脊育龍韁具師'
    }
    'filune-grove.md' = @{
        Household = @'
## 家系與地方日常
菲露涅的家系很少把家務和護林切開。藥脂熬煮、橋面擦養、傷者照護、病斑巡看與幼伴靜養往往都發生在同一個院群裡，因此這裡的溫柔常帶著明確的分工與疲憊感。
'@
        Beast = @'
## 神獸照看與日常相處
花翎幼龍與羽鳳在菲露涅更像需要長期照護的鄰居，而不是高高在上的聖物。巢枝、靜枝區與藥脂棚會直接影響住屋佈局；若鳳裔提前離枝，地方人通常先重查照護流程與近路施工。
'@
        CharacterLine = '- [翎苔](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/filune/lingtai.md)｜羽鳳巢枝照護師'
    }
    'vithare-weald.md' = @{
        Household = @'
## 家系與地方日常
維塔蕾很多家不是固定住在地上，而是依著泊位、樁索、橋身與潮位移動。家戶的穩定來自誰能把橋泊秩序守好，而不是誰佔了最大的屋；低潮一到，很多日常決定都得跟著重新編排。
'@
        Beast = @'
## 神獸照看與日常相處
鈴葦小龍與濕地巢位和橋泊生活緊緊扣在一起。孩子會從看樁、聽鈴、辨小龍短鳴開始學日常責任；若幼鱗亂鳴，地方人常把那視為比橋索斷一根更早的警告。
'@
        CharacterLine = '- [蘆鈴](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/vithare/luling.md)｜漂棚幼鱗照看師'
    }
    'yathire-marshes.md' = @{
        Household = @'
## 家系與地方日常
雅席爾的家系和雨季、封沼期與眠礦取樣表綁得很緊。很多戶群平時分散在不同澤段，到了汛期又會被編成同一責任戶；真正的家感，往往來自誰願意在錯節律時一起承擔後果。
'@
        Beast = @'
## 神獸照看與日常相處
沼光幼龍在雅席爾更像活的水脈標記。牠們停飛、換巢或集體待在封沼邊線上，都會被當作節律崩口的訊號；因此照看牠們的人，也常同時負責祭沼與汛線判讀。
'@
        CharacterLine = '- [泥照](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yathire/nizhao.md)｜沼光幼龍標汛守'
    }
    'olorase-coastwood.md' = @{
        Household = @'
## 家系與地方日常
歐羅瑟的家戶多半把守崖、聽訊、沿岸工藝與骨路維護一起過。飯前先對一次今天的訊號、夜裡輪流聽風辨潮、哪條路該給誰先走，都是這裡比吃穿更像日常的東西。
'@
        Beast = @'
## 神獸照看與日常相處
岸巡飛龍、潮棘小龍與崖巢在歐羅瑟不屬於獨立馴養區，而是守崖系統的一部分。若幼龍改棲、飛龍逆潮巡線或崖巢反覆空置，通常代表某段岸路或某組訊號已不再可靠。
'@
        CharacterLine = '- [岸翎](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/olorase/anling.md)｜崖巢引羽人'
    }
    'aulifan-thickets.md' = @{
        Household = @'
## 家系與地方日常
奧里梵的家戶幾乎都沿著晨火試道或火藤路建立。試煉、工坊、護具修整、切迷與火露調和在這裡不是不同領域，而是同一條生活線上的不同班次；會過日子的人，也通常很會守路。
'@
        Beast = @'
## 神獸照看與日常相處
晨火幼龍與蔓焰滑翼龍在奧里梵的日常裡佔很重的位置。牠們不是吉祥物，而是試道路感的測試者；若幼龍拒路、滑翼龍偏航，地方人最常問的不是「怎麼把牠壓回去」，而是「哪裡把責任線做錯了」。
'@
        CharacterLine = '- [火釉](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/aulifan/huoyou.md)｜晨火幼龍路訓師'
    }
    'milanyu-reaches.md' = @{
        Household = @'
## 家系與地方日常
米蘭羽的家戶常以泊簿、引路、靜泊與照看輪班來維持。這裡很多家庭並不追求熱鬧，而追求「整夜都沒有哪一步出錯」；因此誰最穩、誰最會複述與確認，往往比誰最會說更被信任。
'@
        Beast = @'
## 神獸照看與日常相處
霧潟小龍與眠羽回燼鳳都很怕被驚動。靜泊屋舍、聽池旁棚與盲沼邊線常留有專屬退避位；只要牠們突然過靜、過慢或反覆回棲，地方人就會懷疑是不是有人急過了頭。
'@
        CharacterLine = '- [泊絨](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/milanyu/borong.md)｜眠羽回燼鳳灰翎護守'
    }
    'shranolan-hollow.md' = @{
        Household = @'
## 家系與地方日常
霜諾蘭的家庭高度依賴共享庫、橋索與輪值。很多人從小就在送眠隊、補橋隊與冬井守視之間長大；這裡的家感，常體現在誰願意在寒風裡替別人多守一班，而不是誰說得最柔軟。
'@
        Beast = @'
## 神獸照看與日常相處
寒脊飛龍與霜紋幼龍在霜諾蘭的日常裡更像保命系統。牠們的棚位、巢位與回巡點會直接決定冰橋是否可通、夜隊是否敢走；若飛龍夜裡不願回棚，地方人幾乎一定先重查橋索與寒井。
'@
        CharacterLine = '- [霜索](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/shranolan/shuangsuo.md)｜寒脊龍棚守索者'
    }
}

foreach ($kv in $realmSections.GetEnumerator()) {
    $realmPath = "$root\realms\$($kv.Key)"
    Ensure-RealmSections -Path $realmPath -HouseholdSection $kv.Value.Household -BeastSection $kv.Value.Beast
    Ensure-BeforeMarker -Path $realmPath -Marker '## 區域包入口' -Line $kv.Value.CharacterLine
}

foreach ($c in $chars) {
    $line = "- [$($c.Name)](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/$($c.Realm)/$($c.File))｜$($c.Role)"
    $realmReadme = "$charRoot\$($c.Realm)\README.md"
    $indexPath = "$root\isamel-character-index.md"
    $anchor = "- [$($c.ReadmeTitle)](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/$($c.Realm)/README.md)"
    Ensure-LineAfter -Path $indexPath -Anchor $anchor -Line $line
    Ensure-LineAfter -Path $realmReadme -Anchor "# $($c.ReadmeTitle)" -Line $line
}

$overview = "$root\overview.md"
$overviewContent = [System.IO.File]::ReadAllText($overview)
if (-not $overviewContent.Contains('伊莎梅爾家系、戶群與承責結構')) {
    $anchor = '- [伊莎梅爾天空神獸與遠系龍裔](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sky-beasts-and-sacred-lines.md)'
    $insert = $anchor + "`r`n- [伊莎梅爾家系、戶群與承責結構](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/isamel-households-and-kin-structures.md)`r`n- [伊莎梅爾日常生活與居家節奏](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/isamel-everyday-life-and-domestic-rhythms.md)"
    $overviewContent = $overviewContent.Replace($anchor, $insert)
    [System.IO.File]::WriteAllText($overview, $overviewContent, $utf8Bom)
}

$sky = "$root\sky-beasts-and-sacred-lines.md"
$skyContent = [System.IO.File]::ReadAllText($sky)
if (-not $skyContent.Contains('大型飛龍與高空主權獸')) {
    $skyContent += "`r`n`r`n## 延伸專章`r`n- [伊莎梅爾小型精靈龍譜系](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/small-elf-dragons.md)`r`n- [伊莎梅爾大型飛龍與高空主權獸](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/great-dragons-and-high-skyriders.md)`r`n- [伊莎梅爾鳳裔與不死鳥亞種譜系](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/phoenix-and-immortal-bird-sublineages.md)`r`n- [伊莎梅爾神獸照護、巢庭與育伴空間](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/sacred-beast-care-and-aeries.md)"
    [System.IO.File]::WriteAllText($sky, $skyContent, $utf8Bom)
}

$creReadme = "$creRoot\README.md"
$creContent = [System.IO.File]::ReadAllText($creReadme)
foreach ($line in @(
    '- [伊莎梅爾大型飛龍與高空主權獸](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/great-dragons-and-high-skyriders.md)',
    '- [伊莎梅爾鳳裔與不死鳥亞種譜系](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/phoenix-and-immortal-bird-sublineages.md)',
    '- [伊莎梅爾神獸照護、巢庭與育伴空間](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/sacred-beast-care-and-aeries.md)'
)) {
    if (-not $creContent.Contains($line)) {
        $creContent += "`r`n$line"
    }
}
[System.IO.File]::WriteAllText($creReadme, $creContent, $utf8Bom)

$smallDragons = "$creRoot\small-elf-dragons.md"
$smallContent = [System.IO.File]::ReadAllText($smallDragons)
if (-not $smallContent.Contains('神獸照護、巢庭與育伴空間')) {
    $smallContent += "`r`n`r`n## 延伸閱讀`r`n- [伊莎梅爾神獸照護、巢庭與育伴空間](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/09-creatures/isamel/sacred-beast-care-and-aeries.md)`r`n- [伊莎梅爾家系、戶群與承責結構](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/isamel-households-and-kin-structures.md)"
    [System.IO.File]::WriteAllText($smallDragons, $smallContent, $utf8Bom)
}

"done"
