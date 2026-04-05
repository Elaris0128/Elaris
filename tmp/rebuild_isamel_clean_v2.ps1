$ErrorActionPreference = 'Stop'

$root = 'C:\Users\rabbi\OneDrive\Desktop\Elaris'
$isamelRoot = Join-Path $root 'content\world\02-continents\04-isamel'
$creatureRoot = Join-Path $root 'content\world\09-creatures\isamel'
$characterRoot = Join-Path $root 'content\world\07-characters'
$regionRoot = Join-Path $root 'content\scenarios\regions'
$questRoot = Join-Path $root 'content\scenarios\quests'
$utf8Bom = New-Object System.Text.UTF8Encoding($true)

function Ensure-Dir {
  param([string]$Path)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
}

function Write-Utf8Bom {
  param([string]$Path, [string]$Content)
  Ensure-Dir -Path $Path
  [System.IO.File]::WriteAllText($Path, $Content.Trim() + "`r`n", $utf8Bom)
}

function Abs-Path {
  param([string]$Relative)
  return ((Join-Path $root $Relative) -replace '\\', '/')
}

function Md-Link {
  param([string]$Label, [string]$Relative)
  return "[$Label]($(Abs-Path $Relative))"
}

$realms = @(
  [ordered]@{
    Id='yunselin'; File='yunselin-spiritcloud-canopy.md'; Name='雲瑟靈雲冠域'; Short='雲瑟';
    Branch='精靈 / 雲瑟皇族'; Secondary='巴布窟族 / 共息穴民'; SecondaryNote='雲瑟皇族與巴布窟族以深根共息為核心，兩族共享穴廊、祠井與命名責任。'
    Theme='母樹、共生、命名與靈誓伴'; ThemeShort='命名與共息'; Ecology='高冠母樹、雲幕谷與深根穴廊';
    TravelWay='枝橋與穴廊'; ResourceMain='樹脂、共生菌絲與花粉鹽'; Pressure='命名失序與禁域開裂'; CoreNode='澄華母樹庭'; SacredPlace='橋光名庫';
    BeastMain='靈枝誓龍'; BeastKinds='靈枝誓龍、小型花翎龍、雲瑟不死鳥'; Counterpart='瑟塔嶺星墜臺原';
    Mission='維護母樹的命名秩序，並守住皇族與穴民之間的共息契約。'
    Locations=@(
      @{Slug='chenghua-mothertree'; Name='澄華母樹庭'; Role='母樹中樞聚落'},
      @{Slug='genrui-rootgrotto'; Name='根蕊深穴'; Role='深根穴民與共息儀庫'},
      @{Slug='lingqiao-mending-court'; Name='靈橋補枝院'; Role='橋路維修與靈誓伴照護所'},
      @{Slug='wurui-steps'; Name='霧蕊階庭'; Role='雲階學枝與使節迎接台地'},
      @{Slug='yunyin-trial-grove'; Name='雲引試林'; Role='成年禮、試林與尋伴起點'}
    )
    Sites=@(
      @{Slug='deeproot-symbiosis-shrine'; Name='深根共息祠'; Role='皇族與穴民共證的古祠'},
      @{Slug='lianguang-flowerlake'; Name='煉光花湖'; Role='會反照命名紋線的高冠湖泊'},
      @{Slug='qiaoguang-namevault'; Name='橋光名庫'; Role='封存古名與禁名的名庫'},
      @{Slug='yuying-forbidden-domain'; Name='語影禁域'; Role='失名者與古龍紋殘響交會的封禁帶'}
    )
    Characters=@(
      @{Slug='yunse-jiaming'; Name='雲瑟．嘉銘'; Race='精靈'; Branch='雲瑟皇族'; Role='母樹議序首唱者'},
      @{Slug='yuheng'; Name='語衡'; Race='巴布窟族'; Branch='共息穴民'; Role='深根共息引導者'},
      @{Slug='luzhu'; Name='露竹'; Race='精靈'; Branch='雲瑟皇族'; Role='花翎幼龍照護師'},
      @{Slug='genwei'; Name='根蔚'; Race='巴布窟族'; Branch='共息穴民'; Role='穴廊命名刻記者'},
      @{Slug='qiaoyun'; Name='橋雲'; Race='精靈'; Branch='雲瑟皇族'; Role='靈橋維繕官'},
      @{Slug='yinshi'; Name='音石'; Race='巴布窟族'; Branch='共息穴民'; Role='祠院靜聽者'},
      @{Slug='jianluo'; Name='見絡'; Race='精靈'; Branch='雲瑟皇族'; Role='禁域巡枝使'},
      @{Slug='wupo'; Name='霧珀'; Race='巴布窟族'; Branch='共息穴民'; Role='雲階外客司'}
    )
  },
  [ordered]@{
    Id='thertalyn'; File='thertalyn-starfall-plateau.md'; Name='瑟塔嶺星墜臺原'; Short='瑟塔嶺';
    Branch='精靈 / 瑟塔嶺族'; Secondary='高原行牧民 / 憩龍牧戶'; SecondaryNote='高原行牧民不屬於皇族枝系，但與瑟塔嶺族共同維持高脊風道與飛龍牧場。'
    Theme='高原風道、飛龍牧養、隕星祭與誓望'; ThemeShort='高脊牧龍'; Ecology='高原風場、星墜臺地與龍風裂階';
    TravelWay='高脊風道'; ResourceMain='風晶、牧脊鹽與龍鞍纖維'; Pressure='高脊風暴與龍群躁動'; CoreNode='白脊泉庭'; SacredPlace='雲脊龍壇';
    BeastMain='冠脊飛龍'; BeastKinds='冠脊飛龍、天輝風龍、星鬃小嶺龍'; Counterpart='菲露涅羽蔭林庭';
    Mission='守住高原風道與星墜臺原的飛龍秩序，避免龍風與風暴失衡。'
    Locations=@(
      @{Slug='baiji-springcourt'; Name='白脊泉庭'; Role='高原議庭與泉眼中樞'},
      @{Slug='liefeng-ridgecamp'; Name='裂風脊營'; Role='飛龍斥候與風道宿營地'},
      @{Slug='suixing-windfield'; Name='隨星風場'; Role='行牧民交換牧群與風晶的草場'},
      @{Slug='xinglu-oathwatch'; Name='星麓誓望台'; Role='隕星觀測與誓望哨塔'},
      @{Slug='yunjiling-herdwatch'; Name='雲脊馭群所'; Role='大飛龍馭養與試飛高地'}
    )
    Sites=@(
      @{Slug='starlake-echo-basin'; Name='星湖回響盆地'; Role='會記錄龍鳴頻譜的盆地湖'},
      @{Slug='tianhui-drakewind-step'; Name='天輝龍風階'; Role='飛龍群經常盤旋的險階'},
      @{Slug='xingquan-riftsteps'; Name='星泉裂階'; Role='風晶與冷泉交錯的危險高階'},
      @{Slug='yunji-drakealtar'; Name='雲脊龍壇'; Role='飛龍誓契與成年試飛之壇'}
    )
    Characters=@(
      @{Slug='selian'; Name='瑟蓮'; Race='精靈'; Branch='瑟塔嶺族'; Role='星墜議庭總望者'},
      @{Slug='lanhui'; Name='嵐輝'; Race='精靈'; Branch='瑟塔嶺族'; Role='高脊風路統帶'},
      @{Slug='hanzhen'; Name='寒震'; Race='人類'; Branch='高原行牧民'; Role='憩龍牧群首領'},
      @{Slug='jingshan'; Name='景杉'; Race='精靈'; Branch='瑟塔嶺族'; Role='隕星書錄官'},
      @{Slug='lingji'; Name='凌脊'; Race='精靈'; Branch='瑟塔嶺族'; Role='試飛場監教'},
      @{Slug='qianling'; Name='千翎'; Race='人類'; Branch='高原行牧民'; Role='龍鞍工師'},
      @{Slug='weitan'; Name='緯壇'; Race='精靈'; Branch='瑟塔嶺族'; Role='龍壇守誓者'},
      @{Slug='jingcan'; Name='晶燦'; Race='精靈'; Branch='瑟塔嶺族'; Role='風晶鑑算師'}
    )
  },
  [ordered]@{
    Id='filune'; File='filune-grove.md'; Name='菲露涅羽蔭林庭'; Short='菲露涅';
    Branch='精靈 / 菲露涅族'; Secondary='森馳裔 / 林冠行群'; SecondaryNote='森馳裔是菲露涅最重要的林冠協作族群，負責林間奔行、育林與巡獸。'
    Theme='羽蔭樹海、花脂藥學、林冠試禮與鳳羽護林'; ThemeShort='羽蔭護林'; Ecology='巨木樹冠、藥脂溪澗與羽蔭藤圈';
    TravelWay='冠樹索橋'; ResourceMain='藥脂、羽樹纖維與露香粉'; Pressure='羽獸驚竄與樹冠疫斑'; CoreNode='羽冠林庭'; SacredPlace='心木井';
    BeastMain='花翎幼龍'; BeastKinds='花翎幼龍、林冠長尾飛蜥、翡翠羽鳳亞裔'; Counterpart='維塔蕾漂葦林灣';
    Mission='守住羽蔭樹海的藥學、冠層路網與鳳羽護林誓律。'
    Locations=@(
      @{Slug='feathercrest-canopycourt'; Name='羽冠林庭'; Role='樹冠議庭與主幹棲層'},
      @{Slug='fengzhi-roost'; Name='風枝棲所'; Role='飛蜥、幼龍與林冠馴護棲場'},
      @{Slug='gaoguan-restcourt'; Name='高冠歇院'; Role='旅人與學枝歇息的高冠層院'},
      @{Slug='taijing-creek'; Name='苔鏡溪灣'; Role='藥脂採集與溪澗診治點'},
      @{Slug='yulu-herbal-canopy'; Name='雨露藥冠'; Role='雨露藥園與育林試場'}
    )
    Sites=@(
      @{Slug='crownbridge-ruins'; Name='冠橋遺垣'; Role='古林橋殘段與鳳羽紋路遺址'},
      @{Slug='emerald-canopy-fall'; Name='翡翠冠瀑'; Role='冠層瀑幕與羽獸棲流'},
      @{Slug='featherresin-hollow'; Name='羽脂空穴'; Role='濃脂積蓄的封閉樹腔'},
      @{Slug='heartwood-well'; Name='心木井'; Role='林庭最古老的護林井與改名祀所'}
    )
    Characters=@(
      @{Slug='yuke'; Name='羽柯'; Race='精靈'; Branch='菲露涅族'; Role='護林首席'},
      @{Slug='falu'; Name='法露'; Race='精靈'; Branch='菲露涅族'; Role='藥脂工坊總記'},
      @{Slug='lujin'; Name='露槿'; Race='森馳裔'; Branch='林冠行群'; Role='溪灣採脂巡手'},
      @{Slug='mianjin'; Name='眠槿'; Race='精靈'; Branch='菲露涅族'; Role='鳳羽儀式執唱'},
      @{Slug='qiying'; Name='棲瑩'; Race='精靈'; Branch='菲露涅族'; Role='幼龍試伴官'},
      @{Slug='tenglan'; Name='藤嵐'; Race='森馳裔'; Branch='林冠行群'; Role='冠橋奔行教習'},
      @{Slug='tingzhi'; Name='庭枝'; Race='精靈'; Branch='菲露涅族'; Role='高冠歇院主理'},
      @{Slug='yulve'; Name='雨略'; Race='精靈'; Branch='菲露涅族'; Role='疫斑偵巡師'}
    )
  },
  [ordered]@{
    Id='vithare'; File='vithare-weald.md'; Name='維塔蕾漂葦林灣'; Short='維塔蕾';
    Branch='精靈 / 維塔蕾族'; Secondary='森馳裔 / 漂葦行群'; SecondaryNote='漂葦行群是維塔蕾最靈活的工藝與舟路輔助者，負責葦橋、浮棚與濕地導行。'
    Theme='漂葦工藝、浮橋聚落、濕地手作與低潮守約'; ThemeShort='漂葦工藝'; Ecology='葦灣、浮棚林帶與低潮根場';
    TravelWay='漂葦浮橋'; ResourceMain='蘆纖、浮木膠與鈴葦工材'; Pressure='沼汐變道與浮棚漂失'; CoreNode='浮蔓橋庭'; SacredPlace='沉鈴蔓井';
    BeastMain='鈴葦小龍'; BeastKinds='鈴葦小龍、沼頸飛蜥、低潮鐘羽鳳'; Counterpart='雅席爾沉雨澤境';
    Mission='維持低潮與漂棚的秩序，守住濕地工藝不被水位與外來商路吞沒。'
    Locations=@(
      @{Slug='fuman-bridgecourt'; Name='浮蔓橋庭'; Role='漂橋議庭與主舟結點'},
      @{Slug='genwan-atelier'; Name='根灣工坊'; Role='葦編、木膠與橋具製作所'},
      @{Slug='jinghu-field'; Name='靜葫田洲'; Role='低水農洲與葦藥田帶'},
      @{Slug='manfu-craftmooring'; Name='蔓浮作泊'; Role='浮棚作坊與停泊工帶'},
      @{Slug='taiqiao-driftdock'; Name='苔橋漂埠'; Role='外客停泊與試工換貨埠口'}
    )
    Sites=@(
      @{Slug='floating-bell-reedmaze'; Name='浮鈴蘆迷陣'; Role='會因水位改道的蘆陣迷帶'},
      @{Slug='lowmarsh-splicetower'; Name='低沼接枝塔'; Role='監測水位與浮橋張力的塔場'},
      @{Slug='lowtide-rootloom'; Name='退潮根織場'; Role='根纖工藝與古織紋保存地'},
      @{Slug='sunken-bellvine'; Name='沉鈴蔓井'; Role='鐘羽鳳亞裔會停留的半沉蔓井'}
    )
    Characters=@(
      @{Slug='taogen'; Name='苔根'; Race='精靈'; Branch='維塔蕾族'; Role='浮橋議庭主算'},
      @{Slug='tailian'; Name='苔漣'; Race='精靈'; Branch='維塔蕾族'; Role='漂橋設計師'},
      @{Slug='duji'; Name='渡汲'; Race='森馳裔'; Branch='漂葦行群'; Role='低汀導路者'},
      @{Slug='hezhen'; Name='荷箴'; Race='精靈'; Branch='維塔蕾族'; Role='工坊契記官'},
      @{Slug='manjie'; Name='蔓節'; Race='森馳裔'; Branch='漂葦行群'; Role='浮棚補繕頭手'},
      @{Slug='manqi'; Name='蔓琦'; Race='精靈'; Branch='維塔蕾族'; Role='濕地藥師'},
      @{Slug='shenglu'; Name='聲露'; Race='精靈'; Branch='維塔蕾族'; Role='鐘羽鳳照看人'},
      @{Slug='weiluo'; Name='葦洛'; Race='精靈'; Branch='維塔蕾族'; Role='漂埠換貨司'}
    )
  },
  [ordered]@{
    Id='yathire'; File='yathire-marshes.md'; Name='雅席爾沉雨澤境'; Short='雅席爾';
    Branch='精靈 / 雅席爾族'; Secondary='海人 / 澤息行民'; SecondaryNote='澤息行民熟悉沉雨期與水脈病災，是雅席爾與外界渡沼往來的必要同盟。'
    Theme='沉雨祭沼、眠礦水脈、澤上名錄與雨季儀式'; ThemeShort='沉雨祭沼'; Ecology='沉雨沼群、礦花泥層與藤穴雨灣';
    TravelWay='雨沼舟道'; ResourceMain='雨礦、水藻礦鹽與沉泥藥花'; Pressure='沉雨季失道與礦層下陷'; CoreNode='玉汀渡口'; SacredPlace='眠礦水脈';
    BeastMain='沼光幼龍'; BeastKinds='沼光幼龍、沉雨長尾飛蜥、睡霧羽鳳'; Counterpart='歐羅瑟聽潮岸林';
    Mission='看守雨季沼道與眠礦水脈，避免濁雨時期讓整域失去通行與祭儀秩序。'
    Locations=@(
      @{Slug='jadeisle-crossing'; Name='玉汀渡口'; Role='主渡沼道與祭旅換舟點'},
      @{Slug='qinglu-rest'; Name='青露歇塘'; Role='歇腳、烘具與除泥病所'},
      @{Slug='rainore-altar'; Name='雨礦祭壇'; Role='礦雨祭儀與眠礦試讀台'},
      @{Slug='yukuang-floatisle'; Name='玉礦浮汀'; Role='浮汀採礦與暫居棚地'},
      @{Slug='yumian-vinehollow'; Name='雨綿藤穴'; Role='雨期穴居與育藥藤場'}
    )
    Sites=@(
      @{Slug='jaderain-sinkgrove'; Name='玉雨沉林'; Role='雨落時會沉入泥下半日的林帶'},
      @{Slug='orebloom-siltcrypt'; Name='礦花泥藏窟'; Role='礦花層與沉泥祀骨並存的洞藏'},
      @{Slug='sinking-step-bog'; Name='沉階沼'; Role='古祭階沉沒後留下的危沼'},
      @{Slug='sleepore-watervein'; Name='眠礦水脈'; Role='整個澤境最重要的眠礦主脈'}
    )
    Characters=@(
      @{Slug='moyu'; Name='沫雨'; Race='精靈'; Branch='雅席爾族'; Role='祭沼主錄官'},
      @{Slug='qingsu'; Name='青溯'; Race='海人'; Branch='澤息行民'; Role='雨道領舟者'},
      @{Slug='shenyu'; Name='深羽'; Race='精靈'; Branch='雅席爾族'; Role='睡霧羽鳳照看者'},
      @{Slug='tingsha'; Name='汀紗'; Race='精靈'; Branch='雅席爾族'; Role='浮汀礦務主理'},
      @{Slug='yayan'; Name='雅淹'; Race='精靈'; Branch='雅席爾族'; Role='沉林測汛師'},
      @{Slug='yupo'; Name='雨珀'; Race='海人'; Branch='澤息行民'; Role='泥病治療師'},
      @{Slug='zaoqin'; Name='藻芹'; Race='精靈'; Branch='雅席爾族'; Role='藻鹽配調師'},
      @{Slug='zhaoli'; Name='沼璃'; Race='精靈'; Branch='雅席爾族'; Role='浮洞外客司'}
    )
  },
  [ordered]@{
    Id='olorase'; File='olorase-coastwood.md'; Name='歐羅瑟聽潮岸林'; Short='歐羅瑟';
    Branch='精靈 / 歐羅瑟族'; Secondary='海人 / 岸歌航民'; SecondaryNote='岸歌航民是歐羅瑟的航訊夥伴，負責礁窗辨流、崖下補給與遠潮警示。'
    Theme='岸林聽潮、崖訊守望、鹽霧木藝與根港航歌'; ThemeShort='岸林聽潮'; Ecology='海岬根港、鹽霧岸林與聽崖骨路';
    TravelWay='崖根聽道'; ResourceMain='鹽霧木脂、礁骨鹽與聽潮索材'; Pressure='岸霧誤訊與礁窗斷流'; CoreNode='聽潮根港'; SacredPlace='靜影聽崖';
    BeastMain='潮棘小龍'; BeastKinds='潮棘小龍、岸巡飛龍、鹽霧火尾鳳'; Counterpart='奧里梵晨火蔓叢';
    Mission='守住岸林聽潮系統，讓整個西南岸線仍能被讀懂、被警示與被接回。'
    Locations=@(
      @{Slug='chaogen-saltroost'; Name='潮根鹽棲台'; Role='鹽棲與潮龍照看台'},
      @{Slug='haiwu-shelf'; Name='海霧層架'; Role='霧架儲物與崖下補給層'},
      @{Slug='jingchao-rootport'; Name='聽潮根港'; Role='岸林航訊主港'},
      @{Slug='jingting-listencape'; Name='靜汀聽岬'; Role='聽潮祭與崖訊輪值點'},
      @{Slug='yingchao-court'; Name='迎潮庭'; Role='旅客接引、訊歌與護航換誓庭'}
    )
    Sites=@(
      @{Slug='chaoying-rootgate'; Name='潮影根門'; Role='根港古門與潮影殘訊地'},
      @{Slug='clifflisten-bonearch'; Name='聽崖骨拱'; Role='會放大潮音與風誤訊的骨拱'},
      @{Slug='saltmist-beaconroots'; Name='鹽霧烽根'; Role='古烽根系與遠岸燈訊聯絡點'},
      @{Slug='stillshade-clifflisten'; Name='靜影聽崖'; Role='最古老的聽潮聖崖'}
    )
    Characters=@(
      @{Slug='chaowen'; Name='潮聞'; Race='精靈'; Branch='歐羅瑟族'; Role='根港聽訊總司'},
      @{Slug='genyin'; Name='根音'; Race='海人'; Branch='岸歌航民'; Role='礁窗辨流者'},
      @{Slug='hailan'; Name='海瀾'; Race='海人'; Branch='岸歌航民'; Role='崖下補給長'},
      @{Slug='jiayin'; Name='岬音'; Race='精靈'; Branch='歐羅瑟族'; Role='靜汀祭唱師'},
      @{Slug='jingtai'; Name='靜苔'; Race='精靈'; Branch='歐羅瑟族'; Role='鹽霧木藝師'},
      @{Slug='ouluo'; Name='歐洛'; Race='精靈'; Branch='歐羅瑟族'; Role='迎潮庭主事'},
      @{Slug='wanruo'; Name='晚若'; Race='精靈'; Branch='歐羅瑟族'; Role='火尾鳳記譜者'},
      @{Slug='yanluo'; Name='岩洛'; Race='海人'; Branch='岸歌航民'; Role='岸巡飛龍馭者'}
    )
  },
  [ordered]@{
    Id='aulifan'; File='aulifan-thickets.md'; Name='奧里梵晨火蔓叢'; Short='奧里梵';
    Branch='精靈 / 奧里梵族'; Secondary='森馳裔 / 晨藤試行群'; SecondaryNote='晨藤試行群是奧里梵最重要的試路與火線夥伴，負責藤索試行與危帶開路。'
    Theme='晨火藤道、蔓叢試禮、燃霧演訓與焰藤工藝'; ThemeShort='晨火藤道'; Ecology='焰藤迷叢、試道切谷與霧火坡地';
    TravelWay='藤索火徑'; ResourceMain='晨火藤絲、燼皮、熱露樹膠'; Pressure='晨火外溢與切迷路徑改寫'; CoreNode='晨華庭'; SacredPlace='晨火試庫';
    BeastMain='晨火幼龍'; BeastKinds='晨火幼龍、蔓焰滑翼龍、曉燼羽鳳'; Counterpart='米蘭羽迷澤川';
    Mission='讓晨火成為秩序，而不是焚盡整片蔓叢的災禍。'
    Locations=@(
      @{Slug='chenhua-court'; Name='晨華庭'; Role='蔓叢議庭與工坊中樞'},
      @{Slug='chenhuo-vinepost'; Name='晨火藤哨'; Role='火線巡哨與藤索張線地'},
      @{Slug='tenghuo-pass'; Name='藤火隘'; Role='穿谷火徑與旅隊匯流點'},
      @{Slug='xiaolu-cablecourt'; Name='曉露索庭'; Role='索橋維繫與露火採集場'},
      @{Slug='xiaoteng-trialway'; Name='曉藤試道'; Role='成年試行與滑翼試場'}
    )
    Sites=@(
      @{Slug='dawnfire-trial-vault'; Name='晨火試庫'; Role='封存古試卷與火誓器物的石庫'},
      @{Slug='denseoath-grove'; Name='密誓林'; Role='試行者結誓後會穿越的密林'},
      @{Slug='firevine-mistvale'; Name='焰藤霧谷'; Role='火霧共生的危谷'},
      @{Slug='vinewhisper-cutmaze'; Name='藤語切迷陣'; Role='道路會自行重編的切谷迷陣'}
    )
    Characters=@(
      @{Slug='aofan'; Name='奧梵'; Race='精靈'; Branch='奧里梵族'; Role='晨華庭總督工'},
      @{Slug='chenxi'; Name='晨曦'; Race='精靈'; Branch='奧里梵族'; Role='火線巡督'},
      @{Slug='guangci'; Name='光茨'; Race='森馳裔'; Branch='晨藤試行群'; Role='切谷導路師'},
      @{Slug='huoteng'; Name='火藤'; Race='精靈'; Branch='奧里梵族'; Role='藤絲兵裝匠'},
      @{Slug='luqi'; Name='露棲'; Race='精靈'; Branch='奧里梵族'; Role='晨露採集與藥露調和者'},
      @{Slug='qieman'; Name='切蔓'; Race='森馳裔'; Branch='晨藤試行群'; Role='滑翼龍試場教官'},
      @{Slug='tengyou'; Name='藤悠'; Race='精靈'; Branch='奧里梵族'; Role='曉燼羽鳳記錄者'},
      @{Slug='xiaojing'; Name='曉徑'; Race='精靈'; Branch='奧里梵族'; Role='試道評定官'}
    )
  },
  [ordered]@{
    Id='milanyu'; File='milanyu-reaches.md'; Name='米蘭羽迷澤川'; Short='米蘭羽';
    Branch='精靈 / 米蘭羽族'; Secondary='海人 / 霧潟泊民'; SecondaryNote='霧潟泊民熟悉迷澤川的逆流、靜泊與偽航道，是米蘭羽不可或缺的水路同伴。'
    Theme='迷澤聽池、霧航泊民、眠羽照看與盲沼避路'; ThemeShort='迷澤聽池'; Ecology='迷澤水網、蘆幕暗灣與盲霧泥棚';
    TravelWay='霧澤棧橋'; ResourceMain='眠霧草、沼木、靜泊鹽與羽苔'; Pressure='霧澤封流與偽航道誘迷'; CoreNode='低潮根堡'; SacredPlace='霧眠石冢';
    BeastMain='霧潟小龍'; BeastKinds='霧潟小龍、眠沼飛蜥、眠羽回燼鳳'; Counterpart='霜諾蘭眠霧寒穴';
    Mission='讓迷澤仍有路，讓會吃掉記憶的霧不至於吞沒整個文明域。'
    Locations=@(
      @{Slug='ditide-roothold'; Name='低潮根堡'; Role='主堡與泊民保線站'},
      @{Slug='mianyu-marshpost'; Name='眠雨澤哨'; Role='盲沼警戒與試泊監哨'},
      @{Slug='wulu-reach'; Name='霧路川灣'; Role='可逆舟道與導路換泊點'},
      @{Slug='xianmu-mirehold'; Name='纖沐泥堡'; Role='泥堡型農作與防潮倉帶'},
      @{Slug='yinzhao-listenpool'; Name='隱沼聽池'; Role='聽水紋與判斷偽航道的池區'}
    )
    Sites=@(
      @{Slug='mistsleep-cairn'; Name='霧眠石冢'; Role='會使行人忘記回路的古冢'},
      @{Slug='mistwall-blindzone'; Name='霧牆盲域'; Role='視線與聲音都會被錯置的盲域'},
      @{Slug='reedveil-sunken-shelf'; Name='蘆幕沉棚'; Role='半沉浮棚與古泊民遺棚'},
      @{Slug='sleepfeather-marsh'; Name='眠羽澤'; Role='回燼鳳與霧潟小龍會同現的危澤'}
    )
    Characters=@(
      @{Slug='milan'; Name='米蘭'; Race='精靈'; Branch='米蘭羽族'; Role='低潮根堡主議'},
      @{Slug='lugen'; Name='蘆根'; Race='海人'; Branch='霧潟泊民'; Role='主泊長'},
      @{Slug='weixu'; Name='微絮'; Race='精靈'; Branch='米蘭羽族'; Role='霧紋記錄者'},
      @{Slug='wuyu'; Name='霧羽'; Race='精靈'; Branch='米蘭羽族'; Role='眠羽回燼鳳照看人'},
      @{Slug='xianzhou'; Name='纖舟'; Race='海人'; Branch='霧潟泊民'; Role='盲沼導航者'},
      @{Slug='yinsu'; Name='隱粟'; Race='精靈'; Branch='米蘭羽族'; Role='泥堡農師'},
      @{Slug='zewen'; Name='澤聞'; Race='精靈'; Branch='米蘭羽族'; Role='聽池主聽'},
      @{Slug='zhaomian'; Name='沼眠'; Race='精靈'; Branch='米蘭羽族'; Role='偽航道辨識官'}
    )
  },
  [ordered]@{
    Id='shranolan'; File='shranolan-hollow.md'; Name='霜諾蘭眠霧寒穴'; Short='霜諾蘭';
    Branch='精靈 / 霜諾蘭族'; Secondary='極光徙裔 / 霜客外枝'; SecondaryNote='霜客外枝長於寒穴補給、冰橋巡夜與遺名搬送，是霜諾蘭對外行路的重要夥伴。'
    Theme='寒穴名墓、眠霧冰橋、冬井誓律與霜龍守眠'; ThemeShort='寒穴名墓'; Ecology='寒穴群、霜湖裂井與眠霧冰橋';
    TravelWay='冰橋與霧穴'; ResourceMain='冰紋鹽、霧花、寒脈石與霜藥'; Pressure='寒穴封結與失名眠霧'; CoreNode='風霧誓井'; SacredPlace='霧霜名墓';
    BeastMain='霜紋幼龍'; BeastKinds='霜紋幼龍、寒脊飛龍、霧燼鳳亞裔'; Counterpart='雲瑟靈雲冠域';
    Mission='守住寒穴名墓與冬井誓律，讓極寒不把名字和路都一併吞掉。'
    Locations=@(
      @{Slug='fengwu-oathwell'; Name='風霧誓井'; Role='主井、議庭與送眠誓場'},
      @{Slug='frostveil-lakecourt'; Name='霜幕湖庭'; Role='湖庭補給與冰橋判路點'},
      @{Slug='iceglyph-hall'; Name='冰紋廳'; Role='名紋刻錄與寒脈鑑定所'},
      @{Slug='shuanglian-sleepbridge'; Name='霜蓮眠橋'; Role='冬季主橋與送眠橋段'},
      @{Slug='snowdream-pass'; Name='雪夢隘'; Role='寒穴外客、修行者與試眠通隘'}
    )
    Sites=@(
      @{Slug='frozenbreath-riftlake'; Name='凍息裂湖'; Role='湖面呼息會凍成紋路的裂湖'},
      @{Slug='iceflower-echochasm'; Name='冰花回聲裂谷'; Role='回聲會唸出舊名的寒谷'},
      @{Slug='mistcave-cluster'; Name='眠霧穴群'; Role='整體會移動的霧穴群'},
      @{Slug='mistfrost-namecrypt'; Name='霧霜名墓'; Role='寒穴最古老的名墓與守眠場'}
    )
    Characters=@(
      @{Slug='bingsi'; Name='冰巳'; Race='精靈'; Branch='霜諾蘭族'; Role='冬井守誓官'},
      @{Slug='bingsu'; Name='冰素'; Race='精靈'; Branch='霜諾蘭族'; Role='送眠唱者'},
      @{Slug='gumian'; Name='骨眠'; Race='極光徙裔'; Branch='霜客外枝'; Role='遺名搬送人'},
      @{Slug='menghan'; Name='夢寒'; Race='精靈'; Branch='霜諾蘭族'; Role='霧穴測路師'},
      @{Slug='shuangyu'; Name='霜羽'; Race='精靈'; Branch='霜諾蘭族'; Role='霜紋幼龍照看者'},
      @{Slug='shunuo'; Name='霜諾'; Race='精靈'; Branch='霜諾蘭族'; Role='冰紋典籍官'},
      @{Slug='yexun'; Name='夜巡'; Race='極光徙裔'; Branch='霜客外枝'; Role='寒脊飛龍夜哨'},
      @{Slug='yuxiu'; Name='語鏽'; Race='精靈'; Branch='霜諾蘭族'; Role='失名修復師'}
    )
  }
)
for ($i = 0; $i -lt $realms.Count; $i++) {
  $realms[$i].CounterpartRel = "content/world/02-continents/04-isamel/realms/" + (($realms | Where-Object Name -eq $realms[$i].Counterpart).File)
}

function Quest-Title {
  param($Realm, [int]$Index)
  switch ($Index) {
    1 { "$($Realm.CoreNode) 的名錄缺頁" }
    2 { "$($Realm.BeastMain) 的幼裔失蹤" }
    3 { "$($Realm.SacredPlace) 傳出禁入告示" }
    4 { "$($Realm.TravelWay) 上的路引錯置" }
    5 { "$($Realm.ResourceMain) 的分配失衡" }
    6 { '學枝與守枝的分歧' }
    7 { '祭儀前夜的換名風波' }
    8 { '巡境者帶回的危帶徵兆' }
    9 { '邊境商路與護送委託' }
    10 { '內查令下達的靜默調查' }
    11 { '舊誓與新生代的衝突' }
    12 { "通往 $($Realm.Counterpart) 的交界任務" }
  }
}

$realmBullets = $realms | ForEach-Object { "- $(Md-Link $_.Name ('content/world/02-continents/04-isamel/realms/' + $_.File))：以 $($_.ThemeShort) 為核心的葉脈文明域。" }
Write-Utf8Bom -Path (Join-Path $isamelRoot 'overview.md') -Content @"
# 伊莎梅爾大陸總覽

## 概述
伊莎梅爾不是以王國邊界切割的大陸，而是以母樹、臺原、濕地、岸林與寒穴形成的葉脈文明網。九大文明域之間共享一套精靈主導的命名文化、靈誓伴制度與守林倫理，但每一域都有自己的生活技藝、交通方式、祭儀語感與神獸亞種。

這塊大陸的核心氣質是高智慧生態共同體。精靈是主導者，卻不是唯一住民；森馳裔、海人、巴布窟族、極光徙裔與行牧民都在不同地帶成為必不可少的同盟。特別是雲瑟皇族與巴布窟族的深根共息，被視為伊莎梅爾最古老、也最具正典意義的跨種族契約。

## 大陸特色
- 精靈文明不靠單一皇城維繫，而是靠九大葉脈文明域彼此唱和。
- 靈誓伴文化盛行，常見的是小型精靈龍、林冠飛蜥與鳳裔；高臺原與寒穴地帶則會出現大型飛龍亞種。
- 多數文明域將命名、成年禮、學習與環境管理綁在一起，違背生態秩序會同時觸犯社會秩序。
- 大陸內部可先視為完成範圍；外島、洋域與外海暫不展開。

## 九大葉脈文明域
$(($realmBullets -join "`r`n"))

## 延伸入口
- $(Md-Link '伊莎梅爾九大葉脈文明域' 'content/world/02-continents/04-isamel/isamel-leafvein-realms.md')
- $(Md-Link '伊莎梅爾地方包索引' 'content/world/02-continents/04-isamel/isamel-location-index.md')
- $(Md-Link '伊莎梅爾探索索引' 'content/world/02-continents/04-isamel/isamel-exploration-index.md')
- $(Md-Link '伊莎梅爾角色索引' 'content/world/02-continents/04-isamel/isamel-character-index.md')
- $(Md-Link '伊莎梅爾天空神獸與遠系龍裔' 'content/world/02-continents/04-isamel/sky-beasts-and-sacred-lines.md')
"@

$realmSections = $realms | ForEach-Object { "## $($_.Name)`r`n- 主體分支：$($_.Branch)`r`n- 次要族群：$($_.Secondary)`r`n- 生態骨架：$($_.Ecology)`r`n- 代表神獸亞種：$($_.BeastKinds)`r`n- 主題：$($_.Theme)`r`n- 入口：$(Md-Link $_.Name ('content/world/02-continents/04-isamel/realms/' + $_.File))" }
Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-leafvein-realms.md') -Content ("# 伊莎梅爾九大葉脈文明域`r`n`r`n伊莎梅爾的大陸內部以九大文明域互相咬合。它們共享精靈主導的命名秩序，但各自擁有不同的生活方式、神獸亞種與道路技術。`r`n`r`n" + ($realmSections -join "`r`n`r`n"))

$locSections = foreach ($realm in $realms) { $links = $realm.Locations | ForEach-Object { "- $(Md-Link $_.Name ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $_.Slug + '.md'))" }; "## $($realm.Name)`r`n$(($links -join "`r`n"))" }
Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-location-index.md') -Content ("# 伊莎梅爾地方包索引`r`n`r`n" + ($locSections -join "`r`n`r`n"))

$siteSections = foreach ($realm in $realms) { $links = $realm.Sites | ForEach-Object { "- $(Md-Link $_.Name ('content/world/02-continents/04-isamel/sites/' + $realm.Id + '/' + $_.Slug + '.md'))" }; "## $($realm.Name)`r`n$(($links -join "`r`n"))" }
Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-exploration-index.md') -Content ("# 伊莎梅爾探索索引`r`n`r`n" + ($siteSections -join "`r`n`r`n"))

$charSections = foreach ($realm in $realms) { $links = $realm.Characters | ForEach-Object { "- $(Md-Link $_.Name ('content/world/07-characters/' + $realm.Id + '/' + $_.Slug + '.md'))｜$($_.Role)" }; "## $($realm.Name)`r`n- $(Md-Link ($realm.Name + '角色索引') ('content/world/07-characters/' + $realm.Id + '/README.md'))`r`n$(($links -join "`r`n"))" }
Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-character-index.md') -Content ("# 伊莎梅爾角色索引`r`n`r`n" + ($charSections -join "`r`n`r`n"))

Write-Utf8Bom -Path (Join-Path $isamelRoot 'civilizations-and-lineages.md') -Content (("# 伊莎梅爾的文明、分支與共生網`r`n`r`n伊莎梅爾以精靈諸分支為主體，但從來不是單一種族的封閉大陸。" + "`r`n`r`n") + (($realms | ForEach-Object { "## $($_.Name)`r`n- 主體分支：$($_.Branch)`r`n- 次要族群：$($_.Secondary)`r`n- 文明核心：$($_.Theme)`r`n- 共生／協作：$($_.SecondaryNote)" }) -join "`r`n`r`n"))

Write-Utf8Bom -Path (Join-Path $isamelRoot 'natural-environments.md') -Content @"
# 伊莎梅爾自然環境總覽

- 冠域母樹帶：高冠層、垂橋、深根穴廊與命名祠井密集分布。
- 星墜臺原帶：高風、斷臺、馭龍場與隕星裂階主導生態。
- 羽蔭林海帶：多層樹冠、藥脂溪谷與鳳羽護林地。
- 漂葦濕地帶：浮棚、蘆橋、低潮根場與舟作工藝帶。
- 沉雨澤境帶：會下陷的祭沼、眠礦水脈與泥藏窟。
- 聽潮岸林帶：海岬、鹽霧木群、聽崖骨路與根港構成沿岸生活。
- 晨火蔓叢帶：藤索、火霧、焰谷與試道密集。
- 迷澤川網帶：霧牆、盲沼、半沉棚與靜泊水道交錯。
- 寒穴名墓帶：冰橋、霧穴、凍湖與名墓群構成極寒生態。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'hazard-zones.md') -Content @"
# 伊莎梅爾危險地帶

- 語影禁域
- 龍風裂階
- 羽脂空穴
- 沉階沼
- 聽崖骨拱
- 藤語切迷陣
- 眠羽澤
- 霧霜名墓
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'waterways-and-lakes.md') -Content @"
# 伊莎梅爾水系與湖澤

伊莎梅爾沒有單一超大型大河，而是以湖、汀、濕地水脈、岸林根港與寒穴裂湖構成複合水系。代表水域包括煉光花湖、星湖回響盆地、苔鏡溪灣、玉汀渡口水網、聽潮根港潮脈、眠礦水脈與凍息裂湖。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'special-sites-and-anomalies.md') -Content @"
# 伊莎梅爾特殊地點與異常帶

橋光名庫、雲脊龍壇、心木井、沉鈴蔓井、眠礦水脈、靜影聽崖、晨火試庫與霧霜名墓，構成大陸內部最重要的一批核心異常帶與儀式地。
"@
Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-faith-landscape.md') -Content @"
# 伊莎梅爾宗教與信仰格局

伊莎梅爾不以單一教團統治，而是把高位神的權柄理解為環境、命名與伴生義務的一部分。萬物母、憶夢者、夜引者與鑄形者的詮釋最常見，並會被轉寫成護林、守眠、聽潮、馭龍與共息等地方儀式。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-knowledge-systems.md') -Content @"
# 伊莎梅爾知識與教育體系對照

- 冠域學枝：命名、共息、祠井與靈誓伴照看。
- 臺原風學：氣流、飛龍、風晶與高脊行路術。
- 林海藥學：羽脂、溪灣植材、鳳羽醫照與育林。
- 濕地工藝學：葦橋、浮棚、泥堡與低潮織作。
- 岸林聽潮學：潮訊、礁窗、信號、根港與聽崖讀法。
- 晨火試行學：藤索、兵裝、火露與試道策略。
- 迷澤辨路學：偽航道、霧牆、沉棚與靜泊規則。
- 寒穴守眠學：冰橋、名墓、失名修復與霧穴測路。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-learning-pathways.md') -Content @"
# 伊莎梅爾學習與傳承入口

伊莎梅爾常見的學習路線包括家系傳承、成年禮、師徒工坊、守域見習與伴生照看系統。雲瑟承認與龍族亞種締結靈誓伴，但視為極少數重誓，必須經過追加祭儀。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-cultural-professions.md') -Content @"
# 伊莎梅爾文化職業與流派

常見文化職業包括名錄護枝者、靈誓伴照看師、高脊馭龍手、葦橋工師、聽潮號讀者、晨火試行者、霧路導泊人與守眠修名師。流派大致可分為伴生系、路權系、工藝系與守域系。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-resource-index.md') -Content @"
# 伊莎梅爾資源總覽

伊莎梅爾大陸內部的重要資源包括藥脂、露香粉、眠霧草、風晶、礁骨鹽、雨礦、冰紋鹽、橋索纖維、龍鞍革、鳳羽灰與共生菌絲。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-route-matrix.md') -Content @"
# 伊莎梅爾主幹線與路線矩陣

雲瑟、菲露涅與維塔蕾之間靠高冠橋路與濕地浮橋互通；瑟塔嶺以高脊風道接入冠域；歐羅瑟與奧里梵靠崖路與藤火切谷互補；米蘭羽與霜諾蘭則多仰賴季節性霧澤外路與冰橋。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-travel-and-survival.md') -Content @"
# 伊莎梅爾旅行、生存與導行

在伊莎梅爾旅行，最重要的不是直線距離，而是你是否懂得地方命名禁忌、伴生禮節與環境路權。橋索、舟具、風布、冰爪與導路者比任何通用坐騎都重要。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'isamel-distance-reference.md') -Content @"
# 伊莎梅爾距離參考表

- 雲瑟到瑟塔嶺：約 3 至 4 日高脊風道。
- 雲瑟到菲露涅：約 4 日冠橋與溪谷路。
- 菲露涅到維塔蕾：約 3 日。
- 維塔蕾到雅席爾：約 2 至 3 日順流沼道。
- 歐羅瑟到奧里梵：約 3 日崖路與藤索火徑。
- 米蘭羽到霜諾蘭：約 4 至 6 日，視霧與冰橋而定。
"@

Write-Utf8Bom -Path (Join-Path $isamelRoot 'sky-beasts-and-sacred-lines.md') -Content @"
# 伊莎梅爾天空神獸與遠系龍裔

伊莎梅爾大陸內部明確存在三條大型神獸亞裔譜線：小型精靈龍、大型飛龍與鳳裔／不死鳥亞種。雲瑟皇族與巴布窟族的共息關係，讓小型精靈龍與深穴住民的照看系統比其他文明域更成熟。
"@

$realmLinks = $realms | ForEach-Object { "- $(Md-Link $_.Name ('content/world/02-continents/04-isamel/realms/' + $_.File))" }
Write-Utf8Bom -Path (Join-Path $isamelRoot 'realms\README.md') -Content ("# 伊莎梅爾文明域索引`r`n`r`n" + ($realmLinks -join "`r`n"))
foreach ($realm in $realms) {
  Write-Utf8Bom -Path (Join-Path $isamelRoot ('realms\' + $realm.File)) -Content @"
# $($realm.Name)

## Metadata
- id: isamel-$($realm.Id)
- type: realm
- region: 伊莎梅爾大陸 / $($realm.Name)
- status: active

## 概述
$($realm.Name) 是伊莎梅爾九大葉脈文明域之一，以 $($realm.Theme) 為文明重心。這裡的主體分支是 $($realm.Branch)，但真正支撐地方運作的，往往還包括 $($realm.Secondary) 這類固定共居或協作族群。

## 核心資料
- 生態骨架：$($realm.Ecology)
- 交通方式：$($realm.TravelWay)
- 主要資源：$($realm.ResourceMain)
- 主要壓力：$($realm.Pressure)
- 守護使命：$($realm.Mission)
- 代表神獸亞種：$($realm.BeastKinds)

## 主要地方
$(($realm.Locations | ForEach-Object { "- $(Md-Link $_.Name ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $_.Slug + '.md'))" }) -join "`r`n")

## 主要探索點
$(($realm.Sites | ForEach-Object { "- $(Md-Link $_.Name ('content/world/02-continents/04-isamel/sites/' + $realm.Id + '/' + $_.Slug + '.md'))" }) -join "`r`n")

## 核心角色
$(($realm.Characters | ForEach-Object { "- $(Md-Link $_.Name ('content/world/07-characters/' + $realm.Id + '/' + $_.Slug + '.md'))｜$($_.Role)" }) -join "`r`n")

## 區域包入口
- $(Md-Link ($realm.Name + '區域包') ('content/scenarios/regions/' + $realm.Id + '/README.md'))
"@

  foreach ($loc in $realm.Locations) {
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).md")) -Content @"
# $($loc.Name)

## 概述
$($loc.Name) 是 $($realm.Name) 的 $($loc.Role)。它直接承接 $($realm.ThemeShort) 的地方任務，也是旅人最容易感受到伊莎梅爾生活細節的地方。

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
- $(Md-Link ($loc.Name + '人物明細') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.people.md'))
- $(Md-Link ($loc.Name + '商店與服務') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.shops.md'))
- $(Md-Link ($loc.Name + '關係網') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.relations.md'))
- $(Md-Link ($loc.Name + '地方事件') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.events.md'))
- $(Md-Link ($loc.Name + '貨物與素材') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.wares.md'))
- $(Md-Link ($loc.Name + '在地支線') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.sidequests.md'))
- $(Md-Link ($loc.Name + '重要建築') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.buildings.md'))
- $(Md-Link ($loc.Name + '攤位與臨時販點') ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $loc.Slug + '.stalls.md'))
"@

    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).people.md")) -Content "# $($loc.Name)人物明細`r`n`r`n- 地方主理、伴生照看人、導路者與外客窗口都會常駐於此。"
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).shops.md")) -Content "# $($loc.Name)商店與服務`r`n`r`n- 工坊類、路具類、照護類與祭務類服務都能在此找到對應窗口。"
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).relations.md")) -Content "# $($loc.Name)關係網`r`n`r`n- 長者、學枝、巡境者與外來使節對 $($realm.ThemeShort) 的理解常有差異。"
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).events.md")) -Content "# $($loc.Name)地方事件`r`n`r`n- 常用祈詞：願 $($realm.BeastMain) 記住我們的名字。`r`n- 小儀式：出發前點印、靜聽或繫索。`r`n- 生活傳聞：最近和 $($realm.ResourceMain) 有關的分配爭議又被翻出。`r`n- 禁忌與神職動向：不可隨意替他人、靈誓伴或守域點命名。"
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).wares.md")) -Content "# $($loc.Name)貨物與素材`r`n`r`n- 常見貨物：$($realm.ResourceMain)"
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).sidequests.md")) -Content "# $($loc.Name)在地支線`r`n`r`n- 協助處理一件與 $($realm.ThemeShort) 有關的小型異常。"
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).buildings.md")) -Content "# $($loc.Name)重要建築`r`n`r`n- 議庭、工坊、照護棚、儀式屋、補給棚。"
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("locations\$($realm.Id)\$($loc.Slug).stalls.md")) -Content "# $($loc.Name)攤位與臨時販點`r`n`r`n- 路具補修攤、素材換價攤、印索攤與季節性照護攤。"
  }

  foreach ($site in $realm.Sites) {
    Write-Utf8Bom -Path (Join-Path $isamelRoot ("sites\$($realm.Id)\$($site.Slug).md")) -Content "# $($site.Name)`r`n`r`n$($site.Name) 是 $($realm.Name) 的 $($site.Role)，通常只會在祭儀、試煉、修復或高風險探索時開放。"
  }
}
foreach ($realm in $realms) {
  $charDir = Join-Path $characterRoot $realm.Id
  $charLinks = $realm.Characters | ForEach-Object { "- $(Md-Link $_.Name ('content/world/07-characters/' + $realm.Id + '/' + $_.Slug + '.md'))｜$($_.Role)" }
  Write-Utf8Bom -Path (Join-Path $charDir 'README.md') -Content ("# $($realm.Name)角色索引`r`n`r`n" + ($charLinks -join "`r`n"))
  Write-Utf8Bom -Path (Join-Path $charDir 'supporting-cast.md') -Content "# $($realm.Name)支援角色名錄`r`n`r`n- 宗教與儀式副手`r`n- 見習教席`r`n- 工坊教手`r`n- 邊路巡守`r`n- 外客檢誓官`r`n- 流動修行者"

  for ($i = 0; $i -lt $realm.Characters.Count; $i++) {
    $char = $realm.Characters[$i]
    $homeLoc = $realm.Locations[$i % $realm.Locations.Count]
    Write-Utf8Bom -Path (Join-Path $charDir ($char.Slug + '.md')) -Content @"
# $($char.Name)

## 身分
- 所屬文明域：$($realm.Name)
- 種族：$($char.Race)
- 種族-分支：$($char.Branch)
- 角色定位：$($char.Role)
- 常見出沒：$(Md-Link $homeLoc.Name ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $homeLoc.Slug + '.md'))

## 簡述
$($char.Name) 是 $($realm.Name) 中與 $($realm.ThemeShort) 密切相關的人物，平常的工作就是把環境、儀式與社會秩序綁在一起，不讓它們分裂成彼此獨立的部件。

## 互動方向
- 可作為導師、任務引路人或地方權限的授予者。
- 會要求玩家尊重地方命名、伴生與路權秩序。
- 若玩家表現出對 $($realm.Mission) 的理解，會提供更深的知識或進階任務。
"@
  }

  $regionDir = Join-Path $regionRoot $realm.Id
  Write-Utf8Bom -Path (Join-Path $regionDir 'README.md') -Content ("# $($realm.Name)區域包`r`n`r`n- $(Md-Link '開局導覽' ('content/scenarios/regions/' + $realm.Id + '/starter-overview.md'))`r`n- $(Md-Link '任務線總表' ('content/scenarios/regions/' + $realm.Id + '/questlines.md'))`r`n- $(Md-Link '地方迴路' ('content/scenarios/regions/' + $realm.Id + '/location-circuit.md'))")
  Write-Utf8Bom -Path (Join-Path $regionDir 'starter-overview.md') -Content "# $($realm.Name)開局導覽`r`n`r`n最適合的開局：見習者、護送者、導路者、靈誓伴照看者。"
  Write-Utf8Bom -Path (Join-Path $regionDir 'starter-quests.md') -Content "# $($realm.Name)開局任務`r`n`r`n- 初見：協助地方完成一件與 $($realm.ThemeShort) 有關的小型儀式。`r`n- 第二步：處理因 $($realm.Pressure) 引發的失序問題。"
  Write-Utf8Bom -Path (Join-Path $regionDir 'shops-and-services.md') -Content "# $($realm.Name)商店與服務`r`n`r`n- 路具補修、伴生照護、地方素材與祭務見證。"
  Write-Utf8Bom -Path (Join-Path $regionDir 'encounters.md') -Content "# $($realm.Name)遭遇表`r`n`r`n- 伴生亞種靠近觀察。`r`n- 道路被改寫或水位改變。`r`n- 守域者封路，要求說明來意。"
  Write-Utf8Bom -Path (Join-Path $regionDir 'location-circuit.md') -Content ("# $($realm.Name)地方迴路`r`n`r`n" + (($realm.Locations | ForEach-Object { "- $(Md-Link $_.Name ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $_.Slug + '.md'))｜$($_.Role)" }) -join "`r`n"))

  $questLinks = @()
  for ($qi = 1; $qi -le 12; $qi++) {
    $title = Quest-Title -Realm $realm -Index $qi
    $questLinks += "- $(Md-Link $title ('content/scenarios/quests/isamel-' + $realm.Id + '-quest-' + ('{0:d2}' -f $qi) + '.md'))"
    $startLoc = $realm.Locations[($qi - 1) % $realm.Locations.Count]
    $focusSite = $realm.Sites[($qi - 1) % $realm.Sites.Count]
    Write-Utf8Bom -Path (Join-Path $questRoot ('isamel-' + $realm.Id + '-quest-' + ('{0:d2}' -f $qi) + '.md')) -Content @"
# $title

## 任務定位
- 區域：伊莎梅爾大陸 / $($realm.Name)
- 起點：$(Md-Link $startLoc.Name ('content/world/02-continents/04-isamel/locations/' + $realm.Id + '/' + $startLoc.Slug + '.md'))
- 關聯探索點：$(Md-Link $focusSite.Name ('content/world/02-continents/04-isamel/sites/' + $realm.Id + '/' + $focusSite.Slug + '.md'))

## 概述
這條任務圍繞 $($realm.ThemeShort) 展開，玩家需要在地方秩序、伴生亞種與環境風險之間做平衡，而不是單純打倒某個敵人。
"@
  }
  Write-Utf8Bom -Path (Join-Path $regionDir 'questlines.md') -Content ("# $($realm.Name)任務線總表`r`n`r`n" + ($questLinks -join "`r`n"))
  Write-Utf8Bom -Path (Join-Path $regionDir 'quest-details.md') -Content "# $($realm.Name)任務細節`r`n`r`n這一域的任務普遍不是單次清怪，而是要理解 $($realm.ThemeShort) 如何嵌在地方秩序裡。"
  Write-Utf8Bom -Path (Join-Path $regionDir 'quest-branches.md') -Content "# $($realm.Name)任務分支導引`r`n`r`n- 保守派`r`n- 改良派`r`n- 探索派"
  Write-Utf8Bom -Path (Join-Path $regionDir 'quest-consequences.md') -Content "# $($realm.Name)任務後果總覽`r`n`r`n- 影響學習入口、地方信任與探索點開放。"
  Write-Utf8Bom -Path (Join-Path $regionDir 'learning-entrypoints.md') -Content "# $($realm.Name)學習入口`r`n`r`n完成對應任務後，玩家才會被允許進入更深的見習。"
  Write-Utf8Bom -Path (Join-Path $regionDir 'play-expansion.md') -Content "# $($realm.Name)玩法擴張`r`n`r`n很適合加入更多伴生亞種互動、儀式型衝突與跨域使節戲。"
}

Write-Utf8Bom -Path (Join-Path $creatureRoot 'README.md') -Content ("# 伊莎梅爾魔物與生態索引`r`n`r`n- $(Md-Link '伊莎梅爾魔物生態總索引' 'content/world/09-creatures/isamel/isamel-monster-index.md')`r`n- $(Md-Link '伊莎梅爾跨環境生態鏈' 'content/world/09-creatures/isamel/isamel-ecological-webs.md')")
Write-Utf8Bom -Path (Join-Path $creatureRoot 'isamel-monster-index.md') -Content "# 伊莎梅爾魔物生態總索引`r`n`r`n- 小型精靈龍`r`n- 大型飛龍與高脊巡空龍`r`n- 鳳裔與回燼鳳亞種`r`n- 濕地飛蜥、岸林翼獸與寒穴霧獸"
Write-Utf8Bom -Path (Join-Path $creatureRoot 'isamel-ecological-webs.md') -Content "# 伊莎梅爾跨環境生態鏈`r`n`r`n母樹花粉、露香粉與羽苔構成廣域基礎，小型精靈龍與飛蜥是常見中上層掠食者，鳳裔多與修復與災變循環綁定。"
Write-Utf8Bom -Path (Join-Path $creatureRoot 'canopy-and-mothergrove-ecology.md') -Content "# 冠域與母樹帶生態`r`n`r`n- 生產者：花粉樹、露香蕈、共息菌絲`r`n- 上層：靈枝誓龍、護林鳳亞裔"
Write-Utf8Bom -Path (Join-Path $creatureRoot 'plateau-and-skyridge-ecology.md') -Content "# 臺原與高脊帶生態`r`n`r`n- 上層：冠脊飛龍、天輝風龍"
Write-Utf8Bom -Path (Join-Path $creatureRoot 'marsh-and-reedwater-ecology.md') -Content "# 濕地與葦水帶生態`r`n`r`n- 上層：睡霧羽鳳、沉雨長尾飛蜥"
Write-Utf8Bom -Path (Join-Path $creatureRoot 'coastwood-and-clifflisten-ecology.md') -Content "# 岸林與聽崖帶生態`r`n`r`n- 上層：岸巡飛龍、鹽霧火尾鳳"
Write-Utf8Bom -Path (Join-Path $creatureRoot 'thicket-and-dawnfire-ecology.md') -Content "# 晨火蔓叢帶生態`r`n`r`n- 上層：曉燼羽鳳與熱翼重掠種"
Write-Utf8Bom -Path (Join-Path $creatureRoot 'frost-hollow-and-namecrypt-ecology.md') -Content "# 寒穴與名墓帶生態`r`n`r`n- 上層：寒脊飛龍、霧燼鳳亞裔"

$playMatrixBullets = $realms | ForEach-Object { "- $(Md-Link ($_.Name + '區域包') ('content/scenarios/regions/' + $_.Id + '/README.md'))｜5個主地方包、4個探索點、8張核心角色卡、12條任務線" }
Write-Utf8Bom -Path (Join-Path $regionRoot 'isamel-playability-matrix.md') -Content ("# 伊莎梅爾可玩層矩陣`r`n`r`n## 區域包入口`r`n" + ($playMatrixBullets -join "`r`n"))
