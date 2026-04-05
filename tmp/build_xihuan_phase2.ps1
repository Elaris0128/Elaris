$root = 'C:\Users\rabbi\OneDrive\Desktop\Elaris'
$xihuan = Join-Path $root 'content\world\03-special-regions\05-xihuan-floating'
$locDir = Join-Path $xihuan 'locations'
$siteDir = Join-Path $xihuan 'sites'
$charDir = Join-Path $root 'content\world\07-characters\xihuan-floating'
$regionDir = Join-Path $root 'content\scenarios\regions\xihuan-floating'
$questDir = Join-Path $root 'content\scenarios\quests'
$playability = Join-Path $root 'content\scenarios\regions\xihuan-floating-playability-matrix.md'

function Write-Utf8File {
    param([string]$Path, [string]$Content)
    $dir = Split-Path -Parent $Path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    Set-Content -Path $Path -Value $Content -Encoding UTF8
}

$locations = @(
    [ordered]@{
        Name='幽璨懸谷'; Slug='youcan-hanging-vale';
        Overview='議羽殿、祖羽碑庭與環心傳送坪所在的環心主島，所有高空秩序的正名都要先經過這裡。';
        Zones='議羽殿圈、祖羽碑庭、雲谷居帶、環心傳送坪';
        Tone='這裡的人說話像在量風壓，能少一個字就不會多說；因為每一段模糊都可能變成跨島事故。';
        Hooks='刮名碑、失序輪值、舊誓爭議、潮牢退卷';
        People=@('曦衡：輪值總衡，寧可讓人怨，也不容主環失衡。','祈羽：祖羽碑庭司名者，專看那些被刻意寫得太乾淨的族譜。','雲簿娘：抄錄者，耳快嘴更快，總能先聽見哪個名字快被抹掉。');
        Shops=@('誓羽簿房：販售誓印紙、巡空簿冊與公開族譜副本。','環谷補纜間：修理橋纜、翼鉤與高空掛索。');
        Relations=@('議羽殿對鳴羽台有正式權威，但真正懂年輕翼人脾氣的是鳴羽台教律。','幽璨懸谷與螺環泊庭共享核名資料，卻彼此都懷疑對方留了第二套簿。');
        Events=@('祖羽碑庭最近多出幾塊被磨得過分平整的碑面，像有人提前替未來的抹名騰位置。','夜風轉硬時，雲谷居帶常聽見舊式傳令骨哨，明明那套哨律早就停用了。','議羽殿的副衡們最近比平常更頻繁地查閱潮牢往返核名，讓不少抄錄者開始低聲改口。');
        Wares=@('祖羽碑拓片、舊巡風圖、誓印石粉、議務專用折翼披扣');
        Sidequests=@('替一位被刻意漏記的見習守橋者補回試值紀錄。','查出誰在夜裡替潮牢退回的空白核名重蓋了議印。');
        Buildings=@('議羽殿：對外像議政廳，對內其實是整個曦環的責任分配機。','祖羽碑庭：名字、職責與抹名都會留下痕跡的冷石庭。','環心傳送坪：跨島調度最核心的空橋轉接坪。');
        Stalls=@('晨刻攤：代刻臨時通行羽片。','雲墨桌：替外來翼具寫短期停泊證。')
    },
    [ordered]@{
        Name='鳴羽台'; Slug='mingyu-platform';
        Overview='成翼、補律與高風試飛的核心訓場，高空責任感不是在這裡被教會，而是被撞進骨頭裡。';
        Zones='試風階、補律廊、逆風坪、舊師翼棚';
        Tone='這裡沒有真正的休息，只分還在受訓，或已經開始帶下一批人。';
        Hooks='逆風補考、教律偏袒、舊路重啟、試飛失序';
        People=@('鳴準：主訓官，對風向和人心都抓得太準。','嶺：資深巡風者，講話短得像斷橋邊的釘。','守橋稚：見習守橋者，總記得別人不想留下的補考紀錄。');
        Shops=@('試翼器棚：賣或借用訓練翼鉤、腕風片與護骨束帶。','補律藥桌：提供暈風、裂羽與肩骨回正藥。');
        Relations=@('鳴羽台表面服從幽璨議令，但很多訓官只承認真正懂風的人。','這裡與雲骨折橋的舊路守人保持沉默互信，因為兩邊都見過被制度遺落的人。');
        Events=@('近來補律廊流傳一種說法：有些補考根本不是重測，而是替某些家系洗掉失誤。','逆風坪夜裡常出現不在課表裡的加訓聲，卻沒人願意說是哪一組。','舊師翼棚最近有人重掛停用多年的折橋訓圖，像在等誰重新學那條路。');
        Wares=@('試風腕帶、舊橋測風羽、成翼紀錄銅片、補律藥丸');
        Sidequests=@('幫一位被惡意調風的學徒找到真實測值。','替舊師翼棚整理一批被藏起來的折橋通路記錄。');
        Buildings=@('試風階：以不同風壓層模擬外環巡守情境。','補律廊：專收那些還沒被准許正式回到主環的人。','逆風坪：高階試飛與責任測試用場。');
        Stalls=@('腕骨調帶鋪：調整翼具與護帶。','速記風牌桌：替見習羽抄錄每日風況。')
    },
    [ordered]@{
        Name='晨光垂岬'; Slug='chenguang-dropcape';
        Overview='主責晨露、雲蘚與靈禽牧養的低風島，曦環最溫柔的一面也最容易被灰線利用。';
        Zones='晨露棚坡、垂岬牧線、蘚庫屋列、低風療棚';
        Tone='這裡聞起來像濕羽、露水和新切雲蘚，大家說話輕，卻沒人真的天真。';
        Hooks='離群靈禽、露稅短缺、療養假名、牧線偷渡';
        People=@('晨岬：牧線主理人，看起來柔和，實際上最懂如何驅離外來翼具。','岬蘚婆：老採蘚人，認得每一種雲蘚的病相。','澈井醫：處理低風暈眩與病羽的療養師。');
        Shops=@('露繩工屋：出售收露囊、細纜與蘚棚掛索。','晨坡藥席：賣雲蘚藥、肩骨敷料與病羽湯。');
        Relations=@('晨光垂岬看似遠離議務，實際上凌宵潤澤一出問題，這裡最先感到水勢變化。','不少外務線會拿療養名義把人送進這裡，因此與螺環泊庭有一層不乾淨的默契。');
        Events=@('最近有幾群靈禽在日出前就提前離棚，像是在躲某種聞不見的味道。','低風療棚的病羽簿曾被換過頁，現在連照護序號都對不上。','有年輕採蘚手說夜裡在蘚庫屋後看見沒有登記的吊籃直落潮下。');
        Wares=@('晨露囊、雲蘚束、療翼香草、靈禽喚鈴');
        Sidequests=@('追查某批被偷偷賣去外島的高等蘚藥。','替一位不想回主環的病羽者找出被藏掉的療養判定。');
        Buildings=@('晨露棚坡：每天第一批曦露採集點。','垂岬牧線：靈禽巡放與回巢的主線。','低風療棚：收治暈風、折羽與病序者的療所。');
        Stalls=@('露囊掛架：臨時修補收露器。','岬邊暖湯桶：賣給夜班採蘚手的濃湯。')
    },
    [ordered]@{
        Name='環淵碎脈'; Slug='huanyuan-shardveins';
        Overview='浮境最危險的礦料與封脈禁區所在，所有人都知道這裡讓曦環浮著，卻沒人喜歡久留。';
        Zones='裂瓣礦棚、封脈碑洞、冷卻滴壁、斷索檢坡';
        Tone='每一口風都帶著碎礦與冷霜味，大家先看你的手套，再決定要不要和你說真話。';
        Hooks='假契運礦、禁脈外流、冷卻失衡、押工消失';
        People=@('脈琉：封脈官，講話像在記帳。','風釘匠：主環最穩的橋釘修匠之一，也懂哪批礦契有假。','裂監：斷索檢坡輪值官，只相信親眼看過的東西。');
        Shops=@('冷鐵釘庫：提供耐寒橋釘、封脈夾與礦燈罩。','裂壁補具間：修理檢礦鉤、滑索扣與碎礦面罩。');
        Relations=@('環淵碎脈表面歸議羽殿調度，實際上與螺環泊庭共享不少不便公開的貨運口徑。','礦線守人向來看不起把秩序掛嘴上的人，因為真正讓浮境不墜的冷卻料從不乾淨。');
        Events=@('最近幾批禁脈礦的印色都偏灰，像是從外環潮濕處重蓋過。','冷卻滴壁偶爾會出現與礦路無關的細小拖痕，像有人把不能見光的東西往下放。','封脈碑洞傳出有人在舊禁區試著重讀停用誓紋。');
        Wares=@('冷礦粉、封脈夾片、礦霜面罩、耐裂手套');
        Sidequests=@('找回一批被改簿的冷卻料紀錄。','查明一位押工是真失蹤還是被換成別的身分送走。');
        Buildings=@('裂瓣礦棚：分流礦料與勞務的主棚。','封脈碑洞：記錄哪些礦脈能用、哪些只能封。','冷卻滴壁：維持整體水氣與裂脈穩定的危地。');
        Stalls=@('碎脈護手攤：賣臨時護具。','灰印測色盤：替礦契驗印色。')
    },
    [ordered]@{
        Name='凌宵潤澤'; Slug='lingxiao-springveil';
        Overview='懸瀑、主泉與濕度調律核心所在，整個曦環最像恩賜的地方，其實背後全是細密計算。';
        Zones='主源瀑心、潤澤橋渠、調濕庭、泉記樓';
        Tone='到處都是水聲，但每一股水都是被指派過職責的。';
        Hooks='濁瀑、配水失衡、療養名冊、暗渠旁路';
        People=@('潤詞：主源調律者，說話溫，但只接受精準。','晚瀑師：瀑流調律副手，擅長緊急補流。','泉錄：泉記樓簿手，最怕有人把水的名字寫錯。');
        Shops=@('潤渠工棚：修水槽、潮簾與調濕葉扇。','泉藥樓角桌：販售水傷藥、淨羽鹽與濾滴囊。');
        Relations=@('凌宵潤澤與晨光垂岬之間像母管與末梢，一邊變濁，另一邊立刻病。','議羽殿會公開談水配額，私下真正有分量的是泉記樓怎麼寫。');
        Events=@('主源瀑心近來偶爾出現短暫濁白，卻只在無外客時被記入。','有人夜裡從調濕庭借走了不用在正規維護中的舊式旁路圖。','低浮療養島最近拿到比規定更多的淨羽鹽，引起泉錄者私下議論。');
        Wares=@('淨羽鹽、濾滴囊、泉痕玻片、調濕葉扇');
        Sidequests=@('替一位調律學徒追查被刪掉的水配額異常。','試著封住一條被灰線利用的舊旁渠。');
        Buildings=@('主源瀑心：整個浮境懸瀑系統的心口。','調濕庭：負責主環與低浮區濕度校正。','泉記樓：把水配額寫成秩序的人待的地方。');
        Stalls=@('瀑鹽盤：賣淨鹽與濾水片。','滴紋檢桌：驗水質與翼羽沾污。')
    },
    [ordered]@{
        Name='浮鷹棲巢'; Slug='skyraptor-aerie';
        Overview='巨鷹、靈鷲與伴飛生物的巢域，也是曦環真正能迅速把命令變成巡空力量的地方。';
        Zones='主巢環、幼羽洞群、飛爪台、守巢崖';
        Tone='這裡的安靜不是平靜，而是所有東西都在判斷你值不值得被載走。';
        Hooks='灰封條、巢域中轉、雛羽失序、守巢派與外務派';
        People=@('鷹眠：巢域總守，對人比對靈鷹還嚴。','巢鈴女：夜班守鈴者，能分辨哪種拍翼聲帶著謊。','羽墜：飛爪台裝具師，最討厭不報備的夜航。');
        Shops=@('巢爪工房：修理鷹具、爪扣與高空騎掛。','羽糧坡店：販售靈鷹飼料、雛羽藥與安巢布。');
        Relations=@('浮鷹棲巢與暮渦曦岑共享不少外務秘密，只是一邊靠泊牌，一邊靠活物。','巢域守人天然看不起只會蓋印的人，但又離不開議務給的供養序列。');
        Events=@('近來有幾頭巡空巨鷹帶回潮牢系統才會用的灰封條殘片。','幼羽洞群中開始流傳某些雛羽在半夜被陌生翼音安撫得過分順從。','守巢崖下發現被拆過的舊吊具，像有人想走一條不經暮渦的隱航線。');
        Wares=@('巢爪扣、安巢布、靈鷹飼料、飛爪台護肩');
        Sidequests=@('替一頭拒絕回巢的巡空巨鷹找出牠看見的東西。','追查一批被改成療養飼料名義的灰封條運補。');
        Buildings=@('主巢環：最資深巡空生物與守巢者所在。','幼羽洞群：雛羽與幼鷹養護區。','飛爪台：起飛、裝具與夜巡集結點。');
        Stalls=@('翼糧欄：供應短期巡空飼料。','安爪毯桌：賣雛羽保暖巢料。')
    },
    [ordered]@{
        Name='暮渦曦岑'; Slug='duskwhorl-dawncrag';
        Overview='外環靈潮匯流端與檢泊島，所有自外而來的飛具、隊伍與模糊身分，幾乎都會先在這裡被讀取。';
        Zones='外環泊架、暮渦檢坪、風報壁、灰候客棚';
        Tone='這裡白天很像合法港，夜裡很像沒人敢承認的門縫。';
        Hooks='重複泊牌、風報造假、候客棚失名、灰線作保';
        People=@('暮泊：檢泊總使，擅長用最平的語氣說最難反駁的話。','泊聲童：跑腿報聲童，總能先知道哪架翼具不該來。','循風佬：老巡風者，知道哪些風報是寫給上面看的。');
        Shops=@('泊牌簿亭：辦理停泊牌、檢修牌與外務短證。','候棚補具攤：補纜、掛燈、風罩與外務套件。');
        Relations=@('暮渦曦岑和螺環泊庭像一張嘴的兩排牙，誰先咬下去決定了外客怎麼被定義。','這裡和潮牢的灰封條問題始終若有若無，因此檢泊官彼此之間很少真正互信。');
        Events=@('最近有幾艘外來泊具拿著一模一樣的泊牌，卻都各有真簿影子。','風報壁上的高空流向被人改得更好看，害外環守人不得不在錯風裡硬飛。','灰候客棚裡常出現沒有停泊記錄卻能得到熱湯的人。');
        Wares=@('泊牌、風罩、外務套件、短證羽片');
        Sidequests=@('追查誰在替同編號泊牌背書。','幫一名被故意拖延檢泊的人找出真正的封鎖理由。');
        Buildings=@('外環泊架：大多數外來飛具的第一落點。','暮渦檢坪：身分、貨物與翼具檢查區。','風報壁：公告給全環與外務線看的高空風況。');
        Stalls=@('灰候茶棚：供外務者等候與買消息。','泊牌補印桌：替短期牌補刻。')
    },
    [ordered]@{
        Name='螺環泊庭'; Slug='spiral-harbor-court';
        Overview='不屬祖制七島的外務節點，負責對外停泊、貨運分流、外客收容與轉押前置核名。';
        Zones='貨簿樓、外務泊圈、轉押亭、纜庭客寮';
        Tone='這裡是曦環最會說「只是程序」的地方，而真正見不得光的多半都躲在程序後面。';
        Hooks='失蹤押卷、空白核名、貨簿重寫、潮牢回件';
        People=@('纜燈：外務泊圈主理人，擅長讓各方都以為自己還有選擇。','雲序：貨簿樓記錄官，能從一個錯字看出誰被改名。','霧棚婢：客寮內最會看破臨時謊言的人。');
        Shops=@('外務整備間：售外來者需要的暫留器具與繫纜配件。','泊庭灰貨桌：合法與不合法只差誰先蓋章的分流台。');
        Relations=@('螺環泊庭與暮渦曦岑共享外務工作，卻總在責任出事時把人往對方那邊推。','它與潮牢之間的文件往返，是整個曦環最不能被攤開的一條暗脈。');
        Events=@('貨簿樓最近丟過一份本該閉門封存的轉押卷宗，卻只在夜班裡被低聲提起。','轉押亭收到了幾批從潮牢退回的空白核名，連簿官都不願在白天碰。','纜庭客寮常住著一些明明該只待一夜，卻能拖到三週以上的外客。');
        Wares=@('暫留憑片、繫纜扣、外務證羽、分流貨簿副本');
        Sidequests=@('幫某位外客追回被改掉的核名順序。','查出為何有一批潮牢回件只剩封蠟沒有正文。');
        Buildings=@('貨簿樓：曦環對外貨物流與人流的真正胃袋。','轉押亭：不能公開提起的文件交會點。','纜庭客寮：外務人員、臨留者和灰線作保者混住之地。');
        Stalls=@('客寮補燈桌：賣夜泊燈與纜繩。','灰件代寄攤：代送不方便進入正式簿冊的包件。')
    }
)

foreach ($loc in $locations) {
    $basePath = Join-Path $locDir ($loc.Slug + '.md')
    $main = @"
# $($loc.Name)

## 概述
$($loc.Overview)

## 主要區塊
$($loc.Zones)

## 地方調性
- $($loc.Tone)
- 這裡的人先把自己視為 `環的一部分`，再把自己視為個人；因此很多衝突不是情緒，而是責任排序不同。

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
    Write-Utf8File $basePath $main.Trim() + "`r`n"

    $people = "# $($loc.Name)人物明細`r`n`r`n## 常駐人物`r`n- " + ($loc.People -join "`r`n- ") + "`r`n`r`n## 主持提示`r`n- 這裡適合讓玩家感受到翼人把職責看得比心情更先。`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.people.md')) $people

    $shops = "# $($loc.Name)商店與服務`r`n`r`n- " + ($loc.Shops -join "`r`n- ") + "`r`n- 多數服務都會先問 `你是誰的責任`，再問你要買什麼。`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.shops.md')) $shops

    $relations = "# $($loc.Name)關係網`r`n`r`n- " + ($loc.Relations -join "`r`n- ") + "`r`n- 如果有人說自己只是做事、沒有立場，那通常代表他正在替某條暗線遮擋。`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.relations.md')) $relations

    $events = "# $($loc.Name)地方事件`r`n`r`n- " + ($loc.Events -join "`r`n- ") + "`r`n- 小祭與風誓通常在換班前後進行，外人若在錯的時候打斷，會立刻被記成不懂秩序。`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.events.md')) $events

    $wares = "# $($loc.Name)地方貨品`r`n`r`n- " + ($loc.Wares -join "`r`n- ") + "`r`n- 真正稀缺的往往不是材料，而是蓋過哪一層簿印。`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.wares.md')) $wares

    $side = "# $($loc.Name)在地支線`r`n`r`n- " + ($loc.Sidequests -join "`r`n- ") + "`r`n- 很多支線最後都會逼玩家決定：要保住秩序，還是保住某個被秩序碾過的人。`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.sidequests.md')) $side

    $buildings = "# $($loc.Name)重要建築`r`n`r`n- " + ($loc.Buildings -join "`r`n- ") + "`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.buildings.md')) $buildings

    $stalls = "# $($loc.Name)攤位與小服務`r`n`r`n- " + ($loc.Stalls -join "`r`n- ") + "`r`n- 這些小攤最常賣的，其實是方便人低聲交換消息的理由。`r`n"
    Write-Utf8File (Join-Path $locDir ($loc.Slug + '.stalls.md')) $stalls
}

$locationsReadme = @"
# 曦環浮境主地方包索引

- [幽璨懸谷](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/youcan-hanging-vale.md)
- [鳴羽台](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/mingyu-platform.md)
- [晨光垂岬](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/chenguang-dropcape.md)
- [環淵碎脈](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/huanyuan-shardveins.md)
- [凌宵潤澤](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/lingxiao-springveil.md)
- [浮鷹棲巢](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/skyraptor-aerie.md)
- [暮渦曦岑](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/duskwhorl-dawncrag.md)
- [螺環泊庭](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/spiral-harbor-court.md)
"@
Write-Utf8File (Join-Path $locDir 'README.md') $locationsReadme.Trim() + "`r`n"

$xihuanLocationIndex = @"
# 曦環浮境地方包索引

## 七島與外務節點
- [幽璨懸谷](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/youcan-hanging-vale.md)
- [鳴羽台](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/mingyu-platform.md)
- [晨光垂岬](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/chenguang-dropcape.md)
- [環淵碎脈](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/huanyuan-shardveins.md)
- [凌宵潤澤](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/lingxiao-springveil.md)
- [浮鷹棲巢](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/skyraptor-aerie.md)
- [暮渦曦岑](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/duskwhorl-dawncrag.md)
- [螺環泊庭](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/locations/spiral-harbor-court.md)

## 延伸套件說明
- 每個主地點都已補齊 `people / shops / relations / events / wares / sidequests / buildings / stalls`。
- 曦環地點的衝突主軸多半不是「誰想作惡」，而是 `哪條責任鏈正在吃掉另一條責任鏈`。

## 探索點入口
- [探索點目錄](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/sites/README.md)
"@
Write-Utf8File (Join-Path $xihuan 'xihuan-location-index.md') $xihuanLocationIndex.Trim() + "`r`n"

$newSites = @(
    [ordered]@{Slug='hollowfeather-pit'; Name='空羽沉坑'; Summary='曾用來處理失序翼具與試飛殘件的沉坑，現在成了很多灰線交換的中轉暗口。'; Features='舊翼具殘架、回音風井、暗索孔洞'; Risks='假失物、潮牢回件、斷纜伏襲'; Hooks='有人在坑底找到仍帶核名印的舊翼骨。'},
    [ordered]@{Slug='glasswind-file-ledge'; Name='璃風檔崖'; Summary='外務風報與觀測殘頁曾在此暫存，近年被拿來藏不方便進正式檔樓的氣流證據。'; Features='觀風片牆、碎玻氣鏡、外環望架'; Risks='假風報、墜崖取頁、議務滅證'; Hooks='一組被撕去日期的風報和潮牢押解日竟然完全對得上。'},
    [ordered]@{Slug='nightferry-strand'; Name='夜渡縈坪'; Summary='低浮小島間只有極少數人承認存在的夜渡集結坪，常被拿來送人、送貨或送一段不該留下的記錄。'; Features='低浮繫坪、夜燈骨牌、靜風繩橋'; Risks='暗渡、掉包、無簿夜泊'; Hooks='有人在這裡看見本應被關進潮牢的人回頭望向主環。'}
)
foreach ($site in $newSites) {
    $content = @"
# $($site.Name)

## 概述
$($site.Summary)

## 場域特徵
- $($site.Features)

## 常見風險
- $($site.Risks)

## 可用切入
- $($site.Hooks)
"@
    Write-Utf8File (Join-Path $siteDir ($site.Slug + '.md')) $content.Trim() + "`r`n"
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
"@
Write-Utf8File (Join-Path $siteDir 'README.md') $sitesReadme.Trim() + "`r`n"

$newChars = @(
    [ordered]@{Slug='qiaolan'; Name='橋嵐'; Identity='主橋試風監'; Home='鳴羽台'; Summary='她不相信「一點小改動不會出事」這種話，因為她見過最小的風差如何把一整班學徒變成墜名。'; Hook='可作為試風、橋路安全與舊橋暗道的入口。'},
    [ordered]@{Slug='quanmu'; Name='泉暮'; Identity='夜班泉記官'; Home='凌宵潤澤'; Summary='泉暮擅長在別人只看見濁瀑時，看出那是哪一條責任鏈偷偷把髒東西沖進主源。'; Hook='可作為配水異常、療養名冊與旁渠調查入口。'},
    [ordered]@{Slug='suifeng'; Name='隨風'; Identity='灰候客棚收燈人'; Home='暮渦曦岑'; Summary='隨風表面只是收燈，實際上知道哪些外客該被留下、哪些人只是換了一套核名。'; Hook='可作為灰線接頭、重複泊牌與候棚消息入口。'},
    [ordered]@{Slug='yan'; Name='雁'; Identity='低浮夜渡守人'; Home='螺環泊庭'; Summary='雁很少說完整句子，但誰夜裡走過哪條低浮路，她比任何簿房都記得清楚。'; Hook='可作為夜渡縈坪、潮牢回件與暗送路線入口。'}
)
foreach ($char in $newChars) {
    $content = @"
# $($char.Name)

## 基本資料
- 種族：翼人
- 種族-分支：翼人 / 曦環羽裔
- 身分：$($char.Identity)
- 常駐地：$($char.Home)

## 人物概述
$($char.Summary)

## 可帶出的戲
- $($char.Hook)
"@
    Write-Utf8File (Join-Path $charDir ($char.Slug + '.md')) $content.Trim() + "`r`n"
}

$charReadme = @"
# 曦環浮境角色索引

## 核心角色卡
- [曦衡](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/xiheng.md)
- [祈羽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/qiyu.md)
- [鳴準](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/mingzhun.md)
- [晨岬](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/chenjia.md)
- [脈琉](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/mailiu.md)
- [潤詞](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/runci.md)
- [鷹眠](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/yingmian.md)
- [暮泊](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/mubo.md)
- [纜燈](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/landeng.md)
- [嶺](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/ling.md)
- [絮棠](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/xutang.md)
- [雲序](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/yunxu.md)
- [橋嵐](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/qiaolan.md)
- [泉暮](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/quanmu.md)
- [隨風](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/suifeng.md)
- [雁](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/yan.md)

## 支援角色名錄
- [支援角色名錄](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/supporting-cast.md)
"@
Write-Utf8File (Join-Path $charDir 'README.md') $charReadme.Trim() + "`r`n"

$supporting = @"
# 曦環浮境支援角色名錄

- 雲簿娘：碑庭抄錄者，嘴碎但不會抄錯。
- 懸階叔：常年修補折風橋階的老工。
- 岬蘚婆：晨光垂岬老採蘚人。
- 風釘匠：主環最穩的橋釘修匠之一。
- 澈井醫：懂低風暈眩與翼骨水傷的療養師。
- 守橋稚：年輕見習守橋者，記性驚人。
- 霧棚婢：低浮客棚裡最會判斷誰在說謊的人。
- 循風佬：外環老巡風者，懂許多不寫進正規教材的風路。
- 泊聲童：在暮渦曦岑跑腿的泊具報聲童。
- 巢鈴女：雛羽洞群的夜班守鈴者。
- 纜課使：負責見習羽的空纜安全課程。
- 晚瀑師：瀑流調律副手，擅長緊急補流。
- 裂監：斷索檢坡輪值官，只相信親眼看過的東西。
- 泉錄：泉記樓簿手，最怕有人把水的名字寫錯。
- 羽墜：飛爪台裝具師，最討厭不報備的夜航。
"@
Write-Utf8File (Join-Path $charDir 'supporting-cast.md') $supporting.Trim() + "`r`n"

$newQuests = @(
    [ordered]@{Num='13'; Title='空羽沉坑的舊翼骨'; Start='有人在空羽沉坑底部撈出一截仍帶核名印的舊翼骨。'; Places='空羽沉坑、鳴羽台、幽璨懸谷'; Risk='若證明曾有人被以事故名義抹去，鳴羽台與議羽殿會一起被拉進舊案。'; Result='找回真名、替人補錄，或讓那截骨頭再沉回去。'},
    [ordered]@{Num='14'; Title='璃風檔崖的撕頁風報'; Start='璃風檔崖出現一組被撕去日期的風報殘頁，剛好對上潮牢押解的空窗。'; Places='璃風檔崖、暮渦曦岑、螺環泊庭'; Risk='若風報曾被系統性修飾，外環許多事故都會被重新定義。'; Result='追回原頁、抓出改報者，或把整批殘頁換成更安全的說法。'},
    [ordered]@{Num='15'; Title='夜渡縈坪的回望者'; Start='夜渡縈坪有人看見本該被押去潮牢的人在低浮燈下回頭望向主環。'; Places='夜渡縈坪、螺環泊庭、潮牢暗線'; Risk='如果曦環正在偷偷召回某些人，整個高空秩序的正當性會變得很難說。'; Result='護送回來者、揭發召回線，或把那人重新送進無名路。'},
    [ordered]@{Num='16'; Title='環心傳送坪的第二份調度令'; Start='環心傳送坪同時出現兩份完全合法卻互相矛盾的調度令。'; Places='幽璨懸谷、環心傳送坪、凌宵潤澤'; Risk='一旦照錯命令分配巡守與水勢，整圈浮境會在同一天出現連鎖失衡。'; Result='辨明哪份是真的、找出誰在用合法格式製造假命令，或保住其中一條暗用秩序。'}
)
foreach ($quest in $newQuests) {
    $content = @"
# $($quest.Title)

## 起因
$($quest.Start)

## 推進節點
- 先核對值班簿、風報、核名或見證者。
- 再前往 $($quest.Places)。
- 最後在責任鏈、真相與高空秩序之間做選擇。

## 風險
$($quest.Risk)

## 可能結果
$($quest.Result)
"@
    Write-Utf8File (Join-Path $questDir ('xihuan-floating-quest-' + $quest.Num + '.md')) $content.Trim() + "`r`n"
}

$questlines = @"
# 曦環浮境任務線總表

- [任務 01：幽璨懸谷的刮名碑](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-01.md)
- [任務 02：鳴羽台的逆風補考](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-02.md)
- [任務 03：晨光垂岬的離群靈禽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-03.md)
- [任務 04：環淵碎脈的假契運礦](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-04.md)
- [任務 05：凌宵潤澤的濁瀑](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-05.md)
- [任務 06：浮鷹棲巢的灰封條](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-06.md)
- [任務 07：暮渦曦岑的重複泊牌](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-07.md)
- [任務 08：螺環泊庭的失蹤押卷](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-08.md)
- [任務 09：低浮潤塘的病羽簿](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-09.md)
- [任務 10：曦渦試風廊的錯判](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-10.md)
- [任務 11：雲骨折橋的第二條路](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-11.md)
- [任務 12：潮牢退回的空白核名](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-12.md)
- [任務 13：空羽沉坑的舊翼骨](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-13.md)
- [任務 14：璃風檔崖的撕頁風報](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-14.md)
- [任務 15：夜渡縈坪的回望者](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-15.md)
- [任務 16：環心傳送坪的第二份調度令](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/quests/xihuan-floating-quest-16.md)
"@
Write-Utf8File (Join-Path $regionDir 'questlines.md') $questlines.Trim() + "`r`n"

$questDetails = @"
# 曦環浮境任務細節

## 01 幽璨懸谷的刮名碑
- 起點：祖羽碑庭出現一行被硬刮去的族名。
- 涉及地點：幽璨懸谷、祖羽碑庭、螺環泊庭
- 主要風險：如果刮名者成功抹去前任守翼者，整個議務輪值會失去合法性。
- 可能結局：追回舊族名或讓它永遠留白。

## 02 鳴羽台的逆風補考
- 起點：一批成翼學徒聲稱自己在錯誤風向裡被迫補考。
- 涉及地點：鳴羽台、雲骨折橋
- 主要風險：若屬實，成翼禮將被質疑偏袒特定家系。
- 可能結局：揭露操縱者、重開試飛，或壓下醜聞保住秩序。

## 03 晨光垂岬的離群靈禽
- 起點：牧坡靈禽持續偏離晨線，像在避開某個看不見的路徑。
- 涉及地點：晨光垂岬、低浮潤塘
- 主要風險：若群禽大亂，晨露與雲蘚供應都會受損。
- 可能結局：修補牧線、追出偷獵者，或發現更深的外環灰路。

## 04 環淵碎脈的假契運礦
- 起點：封脈官發現一批礦契印色不對。
- 涉及地點：環淵碎脈、封脈碑洞、螺環泊庭
- 主要風險：禁脈礦若外流，潮牢和外海灰市都會出現新的買家。
- 可能結局：抓出假契線、反向放線釣魚，或協助某家系掩蓋。

## 05 凌宵潤澤的濁瀑
- 起點：飛瀑主源第一次出現難以解釋的短暫混濁。
- 涉及地點：凌宵潤澤、空瀑鏡井
- 主要風險：全浮境供水和祭儀都可能被拖進危機。
- 可能結局：找出污染源、調整水配額，或暴露上層長久隱瞞的缺口。

## 06 浮鷹棲巢的灰封條
- 起點：巡空巨鷹帶回一枚潮牢群島的灰色押解封條。
- 涉及地點：浮鷹棲巢、暮渦曦岑
- 主要風險：有人在用巢域航路幫潮牢或其灰線中轉。
- 可能結局：切斷灰路、秘密合作，或讓巢域守巢者接管調查。

## 07 暮渦曦岑的重複泊牌
- 起點：幾艘外來泊具使用了同樣編號的泊牌。
- 涉及地點：暮渦曦岑、螺環泊庭
- 主要風險：這意味著外環檢泊被人系統性地挖空。
- 可能結局：封鎖入境、放長線追內鬼，或交換情報保住更大的秘密。

## 08 螺環泊庭的失蹤押卷
- 起點：一份本該閉門處理的轉押卷宗從貨簿樓消失。
- 涉及地點：螺環泊庭、暮渦曦岑
- 主要風險：卷宗若外流，曦環與潮牢的暗面關係會被正式攤開。
- 可能結局：找回卷宗、改寫內容，或反查誰故意讓它丟。

## 09 低浮潤塘的病羽簿
- 起點：療養島上一批病羽的記錄被替換成陌生筆跡。
- 涉及地點：低浮潤塘、幽璨懸谷
- 主要風險：可能有人借療養名義轉移見不得光的人。
- 可能結局：追回病羽名冊、揭露偽裝療養者，或放走某位關鍵見證人。

## 10 曦渦試風廊的錯判
- 起點：資深巡風者嶺堅稱這次外環靈潮報告被人故意修飾。
- 涉及地點：曦渦試風廊、暮渦曦岑
- 主要風險：若風況被政治化，外環巡守與外務調度都會出事。
- 可能結局：修正風報、揭露議務干預，或保住脆弱的對外形象。

## 11 雲骨折橋的第二條路
- 起點：有人說折橋在逆風時會打開通往小浮島的舊路。
- 涉及地點：雲骨折橋、鳴羽台
- 主要風險：舊路一旦重開，將繞過多數官方檢核。
- 可能結局：封橋、重啟巡道，或讓某個被流放的人偷偷回來。

## 12 潮牢退回的空白核名
- 起點：絮棠收到一批從潮牢退回的空白核名記錄。
- 涉及地點：螺環泊庭、幽璨懸谷、潮牢暗線
- 主要風險：這代表有人在高空秩序裡故意製造不存在的人。
- 可能結局：追到潮牢、壓掉記錄，或把問題推回曦環議殿核心。

## 13 空羽沉坑的舊翼骨
- 起點：空羽沉坑底部撈出一截仍帶核名印的舊翼骨。
- 涉及地點：空羽沉坑、鳴羽台、幽璨懸谷
- 主要風險：如果證明有人被以事故名義抹去，成翼制度與議務核名都會被重翻。
- 可能結局：補回真名、釋放舊案，或讓那截骨頭重新沉下去。

## 14 璃風檔崖的撕頁風報
- 起點：璃風檔崖出現與潮牢押解日對得上的風報殘頁。
- 涉及地點：璃風檔崖、暮渦曦岑、螺環泊庭
- 主要風險：一旦證明風報曾被系統性修飾，外環事故的責任鏈會全部鬆動。
- 可能結局：找回原頁、抓出改報者，或重寫一版更安全的官方說法。

## 15 夜渡縈坪的回望者
- 起點：夜渡縈坪有人看見本應被押往潮牢的人回頭望向主環。
- 涉及地點：夜渡縈坪、螺環泊庭、潮牢暗線
- 主要風險：若曦環正在秘密召回某些人，整個高空正統的說法都會裂開。
- 可能結局：護送回來者、揭露召回線，或把人重新送回無名路。

## 16 環心傳送坪的第二份調度令
- 起點：環心傳送坪同時出現兩份完全合法卻互相矛盾的調度令。
- 涉及地點：幽璨懸谷、環心傳送坪、凌宵潤澤
- 主要風險：一旦照錯命令分配巡守與水勢，整圈浮境會出現連鎖失衡。
- 可能結局：辨明真令、抓出合法格式下的假命令，或保住其中一條暗用秩序。
"@
Write-Utf8File (Join-Path $regionDir 'quest-details.md') $questDetails.Trim() + "`r`n"

$play = @"
# 曦環浮境可玩層矩陣

## 區域入口
- [曦環浮境區域包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/README.md)
- [曦環浮境總覽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/overview.md)

## 地方與探索
- [曦環浮境地方包索引](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/xihuan-location-index.md)
- [相對距離與島際路線](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/routes-and-distance.md)
- [雲域生態與高空伴生物](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/ecology-and-cloudlife.md)

## 人物與制度
- [曦環浮境角色索引](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/xihuan-floating/README.md)
- [治理、巡空與外務秩序](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/governance-and-aerial-orders.md)
- [律令、誓印與高空裁斷](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/03-special-regions/05-xihuan-floating/laws-and-oath-judgment.md)

## 任務入口
- [任務線總表](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/questlines.md)
- [任務細節](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/quest-details.md)

## 目前覆蓋
- 主地方包：`8`
- 探索點：`8`
- 核心角色卡：`16`
- 獨立任務檔：`16`
"@
Write-Utf8File $playability $play.Trim() + "`r`n"

$regionReadme = @"
# 曦環浮境區域包

- [開局導覽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/starter-overview.md)
- [開局任務](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/starter-quests.md)
- [地方迴路](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/location-circuit.md)
- [商店與服務](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/shops-and-services.md)
- [遭遇表](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/encounters.md)
- [任務線總表](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/questlines.md)
- [任務細節](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/quest-details.md)
- [任務分支](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/quest-branches.md)
- [任務後果](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/quest-consequences.md)
- [學習入口](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/learning-entrypoints.md)
- [玩法補充](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/scenarios/regions/xihuan-floating/play-expansion.md)
"@
Write-Utf8File (Join-Path $regionDir 'README.md') $regionReadme.Trim() + "`r`n"
