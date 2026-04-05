$ErrorActionPreference = 'Stop'
$root = 'C:\Users\rabbi\OneDrive\Desktop\Elaris'
$base = Join-Path $root 'content\world\02-continents\04-isamel'
$faithDir = Join-Path $base 'faith'
New-Item -ItemType Directory -Force -Path $faithDir | Out-Null

function Write-Utf8BomFile {
    param([string]$Path,[string]$Content)
    $utf8Bom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText($Path, $Content.TrimStart("`r","`n") + [Environment]::NewLine, $utf8Bom)
}

function Get-MarkdownTitle {
    param([string]$Path)
    return ((Get-Content -Path $Path -Encoding utf8 -TotalCount 1) -replace '^#\s*', '').Trim()
}

$readme = @'
# 伊莎梅爾信仰與祭儀索引

伊莎梅爾不是由單一教團統治的大陸，而是由 `葉脈命名諸傳` 串起的精靈文明網。信仰在這裡不是獨立於生活之外的殿堂制度，而是命名、守林、伴生、育養、守路與送眠的總體秩序。

## 共通信仰總論
- [伊莎梅爾精靈共通信仰總論](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/leafvein-naming-tradition.md)

## 九大文明域信仰
- [雲瑟靈雲冠域信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/yunselin-faith-and-rites.md)
- [瑟塔嶺星墜臺原信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/thertalyn-faith-and-rites.md)
- [菲露涅羽蔭林庭信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/filune-faith-and-rites.md)
- [維塔蕾漂葦林灣信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/vithare-faith-and-rites.md)
- [雅席爾沉雨澤境信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/yathire-faith-and-rites.md)
- [歐羅瑟聽潮岸林信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/olorase-faith-and-rites.md)
- [奧里梵晨火蔓叢信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/aulifan-faith-and-rites.md)
- [米蘭羽迷澤川信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/milanyu-faith-and-rites.md)
- [霜諾蘭眠霧寒穴信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/shranolan-faith-and-rites.md)
'@
Write-Utf8BomFile -Path (Join-Path $faithDir 'README.md') -Content $readme

$doctrine = @'
# 伊莎梅爾精靈共通信仰總論

伊莎梅爾的精靈諸分支，並不把信仰理解成單一教團、唯一經典或中央聖座，而是理解成 `葉脈命名諸傳`。對精靈而言，真正神聖的不是誰宣稱自己最正統，而是名字是否被正確見證、靈誓伴是否被善待、道路與棲地是否被守住、死者是否得到適當的回名與送眠。

## 葉脈命名諸傳的核心觀念
- `名字不是標記，而是責任`：伊莎梅爾的名字代表一個生命如何被世界承認，也代表其後必須承擔的道路、伴生與共同體責任。
- `靈誓伴不是寵物，而是神聖同伴`：不論是小型花翎龍、星鬃小嶺龍、霧潟小龍或其他在地靈誓伴，牠們都被視為見證成年、照護倫理與環境秩序的活節點。
- `生態不是背景，而是祭儀空間`：母樹、域樹、井樹、寒穴根脈、潮岸聽崖、火藤試場與迷澤泊池，都同時是生活場景與神聖場域。
- `神明只透過回應顯現`：精靈承認創世主與高位神存在，但不期待神直接降臨；真正重要的是回鳴、夢示、靜聽、失序徵候與見證結果。

## 神系在精靈文化裡的主要轉寫
- `萬物母`：被理解為育養、修補、照護與讓棲地繼續生長的義務。
- `憶夢者`：被理解為命名記憶、名墓、古誓殘響、夢示與回名。
- `夜引者`：被理解為守夜、守路、引渡、迷域導引與不讓同行者失落。
- `鑄形者`：被理解為橋、鞍、浮棚、根室、冰橋、燈籠與各種維持文明的造作責任。
- `鑒誓者`：雖較少被明列為主祭中心，但深深滲入成年誓詞、守林誓與跨域見證程序中。
- `衡律者`：在伊莎梅爾不常被表述成嚴苛法神，而更像各域對節序、配額、輪值、巡線與學習責任的內在平衡。

## 信仰結構
伊莎梅爾沒有一套全大陸統一教階，但大致都有以下幾類神聖職責：
- `命名見證者`：負責啟名、改名、回名與成年見證。
- `育伴照看者`：負責靈誓伴、幼龍、幼鳳裔與伴生生靈的照護、選伴與安撫。
- `守林 / 守路 / 守水 / 守脊者`：依各域不同，負責維持神聖地形與文明動脈。
- `靜聽者 / 觀象者 / 夢示記錄者`：負責判讀弱鳴、夢示、風象、潮訊、失溫徵候與失序前兆。
- `送眠與回名者`：主要集中在偏寒穴與名墓傳統較重的文明域，但各域都有自己的死亡儀節維護者。

## 常見神聖節點
- `域樹與母樹類`：最常見於雲瑟與菲露涅，象徵命名、育養與共同體記憶。
- `井樹、寒井與深井類`：多與回名、封名、學習、眠守與精靈祖名存續相關。
- `橋、路、關、浮棚與崖聽點`：在精靈觀念裡，道路不只是實用設施，也是誓約被履行的證明。
- `試禮場與育伴場`：成年禮並非世俗考試，而是神聖責任正式落在個體身上的時刻。
- `名墓與回聲場`：死者的名字若被妥善安放，精靈相信記憶就不會腐壞成失序殘響。

## 一生中的信仰節奏
### 啟名
幼年啟名通常由地方見證者、家系長者與在地神聖節點共同完成。啟名重點不在名字多美，而在這個孩子未來會被什麼責任看見。

### 尋伴與成年
成年往往與 `靈誓伴`、路線試禮、守林責任、飛龍牧養、泊線守約或寒穴守眠綁在一起。能成年，不等於變強，而是被承認可以承擔共同體的一段責任。

### 共誓與共居
伊莎梅爾的伴侶、共居與共同抚養，不一定都做成同一個制度，但核心都圍繞 `共名`、`共守` 與 `共同承責`。

### 送眠與回名
精靈不把死亡理解為單純離去，而是名字與記憶如何安置的最後一段秩序。如果送眠錯誤、名墓失守或回名未竟，就容易留下失序回聲。

## 精靈普遍禁忌
- 未經見證擅改名字、私立名錄或偽造回名。
- 把靈誓伴視為財產、戰利品或裝飾。
- 在應守靜的節期刻意驚擾域樹、巢地、名墓或聽池。
- 未得許可切開、拆除或改寫高等神聖路權，例如母樹枝橋、寒穴橋、崖聽骨路、火藤試道等。
- 私藏幼龍、鳳裔灰羽、高位祭枝或核心巢材。

## 精靈宗教裡的異端與內部張力
伊莎梅爾也有內部張力，只是通常不以「邪教」的形式出現，而更像以下幾種歧路：
- `把名字當作權力工具`：將命名與回名變成控制手段，而非見證責任。
- `把靈誓伴當成可利用資產`：尤其在戰備、試禮與跨域交換時，容易被某些派別往工具化方向推。
- `過度封閉的守舊`：以守護之名否決一切新制，讓整個文明在表面穩定中逐漸僵死。
- `過度輕率的改革`：以效率之名忽略節序、照護與記憶保存，讓傳統斷裂成無法修復的空洞。

## 雲瑟母樹的特殊地位
雲瑟母樹是伊莎梅爾最古老的命名中樞之一，也是全大陸最受尊崇的神聖節點之一。
- 它可以沿葉脈網發出微弱共鳴。
- 它常被視為失序預警、尋伴季同步與高階祭儀共感的核心節點。
- 但它 `不直接統御整個大陸`，其餘文明域依然靠自身域樹、井樹、寒穴根脈、岸林聽崖或火藤場維持秩序。

## 與九大文明域的關係
葉脈命名諸傳不是同一套儀式在九地複製，而是共享一組神聖原理，再各自長成不同的環境信仰語感：
- 雲瑟偏 `命名、共息、母樹見證`
- 瑟塔嶺偏 `高風、牧龍、誓望`
- 菲露涅偏 `護林、藥脂、羽鳳守靜`
- 維塔蕾偏 `低潮守約、橋與泊的共同責任`
- 雅席爾偏 `沉雨、澤錄、季節服從`
- 歐羅瑟偏 `聽潮、崖訊、岸林守望`
- 奧里梵偏 `晨火試禮、火道與守誓`
- 米蘭羽偏 `靜泊、聽池、盲澤照看`
- 霜諾蘭偏 `守眠、名墓、冬井誓律`
'@
Write-Utf8BomFile -Path (Join-Path $faithDir 'leafvein-naming-tradition.md') -Content $doctrine

$realms = @(
    @{
        File='yunselin-faith-and-rites.md'; Name='雲瑟靈雲冠域信仰與祭儀'; Realm='雲瑟靈雲冠域';
        Axis='命名、共息、母樹見證與跨族共生';
        Gods='萬物母、憶夢者、夜引者與鑒誓者';
        Sites='母樹、祠井、深根穴廊、共息祠與名庫';
        Roles='母樹議序首唱者、命名見證者、祠井維護者、共息引導者、育伴照護師';
        Daily='晨起先靜聽母樹回鳴，再以枝橋滴露潔手，對自己的名字與今日要照看的生靈低聲復誦。入穴廊前會輕觸根壁，提醒自己進入的是共息秩序而不是私人空間。';
        Rites='啟名、共名、尋伴、回名與深根見證';
        Adult='成年禮通常結合尋伴期與責任見證。是否被小型花翎龍或其他靈誓伴選定，不代表地位更高，而代表往後要承擔更重的照護、紀錄與守約責任。';
        Death='雲瑟重視回名。死者的名字若沒有被妥當回存於名錄、祠井與見證環節中，就被視為留下了可能污染共息秩序的空缺。';
        Taboos='私改名字、未經見證奪取幼龍、破壞祠井與以共生之名掩護剝削';
        Tension='最深的宗教張力在於命名秩序應該維持多嚴。保守派想讓母樹體系更封閉，改革派則認為若不讓共名與共息更公開，雲瑟將逐漸失去與其他文明域對話的能力。';
        Prayer='「願名不失，願根不裂，願同行者皆被看見。」'
    },
    @{
        File='thertalyn-faith-and-rites.md'; Name='瑟塔嶺星墜臺原信仰與祭儀'; Realm='瑟塔嶺星墜臺原';
        Axis='高風誓望、飛龍秩序、星墜觀測與天空責任';
        Gods='夜引者、鑒誓者、萬物母與鑄形者';
        Sites='風脊觀象坪、龍壇、試飛階、星湖盆地與牧龍坡';
        Roles='誓望者、風場記官、龍壇守誓者、試飛誓證官、牧龍家系長';
        Daily='瑟塔嶺人晨間先看雲脊與風壓，再決定今日是否開脊。出發前會以手背觸鞍、輕叩風標，確認自己不是向天空索取，而是向天空借路。';
        Rites='隕星望祭、試飛誓階、初乘見證與風脊守望歌';
        Adult='成年不等於會飛，而是能在沒有高位者直接指揮下，守住一段高風、一頭飛龍或一次運送。真正被承認的，是對天空負責而不是征服天空的能力。';
        Death='死者多與星落、風向與高脊誓歌連在一起。若一名騎手死於失責，送眠儀式裡會特別強調未竟之誓如何被後人接續，而不是單純歌詠勇武。';
        Taboos='禁風日強飛、偽造風場記錄、失責仍自稱守脊者與將飛龍當成炫耀道具';
        Tension='最大張力在牧龍秩序是否該改革。傳統派強調誓望與古式鞍法不可被削薄，新派則認為若不調整訓練與運輸體系，整個高原會在更廣的葉脈交流中被淘汰。';
        Prayer='「願高風不因我而亂，願背上的生命信我所判。」'
    },
    @{
        File='filune-faith-and-rites.md'; Name='菲露涅羽蔭林庭信仰與祭儀'; Realm='菲露涅羽蔭林庭';
        Axis='護林、藥脂照護、羽鳳守靜與林冠責任';
        Gods='萬物母、憶夢者、鑄形者與夜引者';
        Sites='羽蔭樹海、藥溪、樹脂舍、林冠試場與鳳羽守靜枝';
        Roles='護林首席、藥脂師、羽鳳守靜者、幼龍試伴見證者、病斑記錄官';
        Daily='菲露涅人的日常從看枝色與聞藥溪開始。多人會在清晨替第一束藥脂點名，確認今天哪些病枝、幼龍與看護者應被優先照顧。';
        Rites='藥冠晨祈、羽脂封枝、鳳羽靜守與幼龍試伴禮';
        Adult='成年的標準之一，是是否已學會在不傷林母枝的前提下照護他者。有人以護林成年，有人以藥學成年，有人則以照護靈誓伴成年。';
        Death='菲露涅的送眠通常偏安靜，不以巨大的哭祭為重，而重視死者生前看護過哪些樹、哪條溪與哪些生命。';
        Taboos='污染藥溪、折傷母枝、把幼龍或鳳裔當作玩賞物與以效率名義犧牲護林節奏';
        Tension='當代衝突集中在新藥試方與護林舊律之間。有人主張若不試新方，病斑只會越拖越深；有人則堅持若太快把樹當成試驗體，文明最終會失去守靜之心。';
        Prayer='「願枝不白死，願藥不誤身，願所護者皆能安過今季。」'
    },
    @{
        File='vithare-faith-and-rites.md'; Name='維塔蕾漂葦林灣信仰與祭儀'; Realm='維塔蕾漂葦林灣';
        Axis='低潮守約、浮橋共同體、工藝即守護與橋泊誓序';
        Gods='鑄形者、夜引者、萬物母與衡律者';
        Sites='浮橋橋庭、漂工場、根織場、蘆棚命索柱與淺灣靜泊點';
        Roles='橋守、泊簽記官、漂工主理、潮窗唱名者與低潮見證者';
        Daily='維塔蕾的宗教從來不離工作。有人在橋樁旁完成清晨祈約，有人在退潮前替每一條索線再念一遍今日輪值。信仰的證據不是神像，而是橋今天還能不能承人走過。';
        Rites='落潮束橋、蘆棚命索、淺灣靜泊禮與新橋試承';
        Adult='成年的關鍵不是體力，而是能否在潮窗裡為一座橋、一段泊場或一批同行者扛下責任。';
        Death='維塔蕾不喜歡讓死者沉沒成無名事故。凡是死於潮窗、泊橋或補線的人，通常都會被記回橋簿與泊簽，讓整個共同體承認那一段斷裂。';
        Taboos='偽造低潮權、無告拆橋、在守灣期棄棚、明知索線有問題仍讓人過橋';
        Tension='宗教張力多出現在舊橋律與新工法之間。守潮舊約派相信慢與保守才能讓橋長久，新橋漂工派則認為若不改革，整個林灣只是把命一潮一潮補在木頭上。';
        Prayer='「願橋有名、泊有位、今潮不奪同路之人。」'
    },
    @{
        File='yathire-faith-and-rites.md'; Name='雅席爾沉雨澤境信仰與祭儀'; Realm='雅席爾沉雨澤境';
        Axis='沉雨、澤錄、眠礦與順季而行的服從';
        Gods='萬物母、憶夢者、衡律者與夜引者';
        Sites='祭沼、雨礦祭壇、澤錄所、汛口與眠礦水脈';
        Roles='汛師、雨印見證者、澤錄官、祭沼維持者與沉路引導者';
        Daily='雅席爾的信仰和季節綁得最緊。人們會先看泥位與初雨痕，再決定哪條路能走、哪片沼能入。違背季節，對雅席爾來說比違背命令更像褻瀆。';
        Rites='首雨沉名、泥燈祭、雨印封材、澤上名錄更新';
        Adult='成年人必須學會判讀沉雨是否可入、汛線是否能改，並為自己的判斷承擔後果。';
        Death='在雅席爾，送眠常和回泥、回水與名錄回收相連。死者被記回澤錄，不是為了保存所有細節，而是為了不讓其名字在泥與雨之間失序流散。';
        Taboos='雨季擅闖沉域、偷採未封眠礦、私改雨印、拔除祭沼標枝';
        Tension='最大的宗教爭論多半是舊式雨季守法是否還足夠應對新異象。守舊者害怕改法會引發整域失控，改革者則認為不改才是真正坐等災禍。';
        Prayer='「願我不逆季，願泥記我名，願雨過後仍有路可回。」'
    },
    @{
        File='olorase-faith-and-rites.md'; Name='歐羅瑟聽潮岸林信仰與祭儀'; Realm='歐羅瑟聽潮岸林';
        Axis='聽潮、讀崖、岸林守望與聲訊責任';
        Gods='夜引者、憶夢者、鑄形者與衡律者';
        Sites='聽崖、根港、潮影骨路、岸訊烽根與鹽霧木棚';
        Roles='聽崖者、岸訊主理、崖路維護者、潮讀者與根港唱記官';
        Daily='歐羅瑟的宗教每天都在聽。聽潮、聽崖、聽木牌、聽遠處船架與風壓。岸林居民相信只要有人願意正確聽取，海就不會完全欺騙人。';
        Rites='根港聽潮、鹽霧洗木、低聲渡礁、夜潮封光';
        Adult='能成年的人，不只是記熟路，而是能在聲音扭曲、霧壓翻轉時仍替別人帶出一條回路。';
        Death='若有人死於錯訊，歐羅瑟的送眠儀式會特別追究那條訊為何失真。哀悼與責任追索往往同時進行。';
        Taboos='偽報潮訊、破壞聽崖骨路、在禁潮夜外放火光、用假訊把貨或人導進錯路';
        Tension='舊唱派與新港路記派的爭執，是歐羅瑟最明顯的信仰裂口之一。前者害怕真正的聽潮本事被書記系統替代，後者則害怕知識繼續被少數人壟斷。';
        Prayer='「願我聽見的不只是海，也聽見那些還沒回來的人。」'
    },
    @{
        File='aulifan-faith-and-rites.md'; Name='奧里梵晨火蔓叢信仰與祭儀'; Realm='奧里梵晨火蔓叢';
        Axis='晨火試禮、火道記誓、蔓叢守線與燃霧演訓';
        Gods='鑒誓者、夜引者、鑄形者與萬物母';
        Sites='晨火試場、藤道關、蔓叢試林、火道刻誓壁與灰藤封庭';
        Roles='試道見證者、守火者、藤道主理、刻誓官與晨火演訓師';
        Daily='奧里梵信仰的日常很像反覆把誓言走在身上。清晨點火不是為了炫示，而是為了確認今天的道、火、霧與人是否還在彼此信任的範圍內。';
        Rites='晨火起誓、燃霧試行、灰藤封印、切谷記誓';
        Adult='在奧里梵，成年通常意味著你終於能在一次真正危險的火道或試道中，既不逞勇也不退逃，並替同行者保住出路。';
        Death='死者常以最後守住的是哪條道、哪一段火、哪群人來被記住。真正的恥辱不是死亡，而是讓道與誓同時斷掉。';
        Taboos='未得許可燒開試道、私用試藤火露、逃避試禮而仍自稱守道者、在封火期擅自開火';
        Tension='舊矩與新蔓試道的衝突，是奧里梵最常見的信仰裂口。舊派認為沒有敬火的慢就只剩危險的快，新派則認為過度守舊會把文明困死在禮的外殼裡。';
        Prayer='「願火照路而不吞路，願我記誓而不只記名。」'
    },
    @{
        File='milanyu-faith-and-rites.md'; Name='米蘭羽迷澤川信仰與祭儀'; Realm='米蘭羽迷澤川';
        Axis='靜泊、聽池、盲沼照看與不驚動水霧的守則';
        Gods='夜引者、萬物母、憶夢者與衡律者';
        Sites='聽池、泊簿亭、霧燈台、眠羽沼與盲澤水棚';
        Roles='泊記者、聽池守唱者、盲航引手、眠羽照看者與路簿繫存者';
        Daily='米蘭羽的宗教常從不做某些事開始：不大聲、不亂敲、不輕信熟路。人們透過靜泊、聽霧與整理泊記來表達自己願意和迷澤共活，而不是向它索取絕對安全。';
        Rites='霧池聽名、盲沼泊記、夜泊無鐘、眠羽照看';
        Adult='成年意味著你能帶人從迷澤回來，或至少知道什麼時候不應該帶人進去。';
        Death='死者若失於迷澤，最重的不是恐懼，而是無名與無返。米蘭羽特別在意把失落者重新記回泊簿，讓其不至於成為盲沼裡只剩傳聞的影子。';
        Taboos='在靜泊夜擾水、篡改迷澤路記、驚動眠羽巢地、用錯誤路簿把人引進盲區';
        Tension='舊泊派與新標記派的爭論，其實是「靠人身體記住迷澤」與「靠制度讓更多人能活」之間的衝突。';
        Prayer='「願霧不因我而亂，願同行者在我之後仍有水可回。」'
    },
    @{
        File='shranolan-faith-and-rites.md'; Name='霜諾蘭眠霧寒穴信仰與祭儀'; Realm='霜諾蘭眠霧寒穴';
        Axis='守眠、名墓、冬井誓律與在寒中維持有序的善意';
        Gods='憶夢者、夜引者、萬物母與鑒誓者';
        Sites='寒井、名墓、冰橋、冷藏所、眠霧穴群與回音隙';
        Roles='守眠者、送眠者、回名見證者、冬井學環師、寒橋換守者';
        Daily='霜諾蘭的宗教日常很安靜。記錄、看寒勢、換守、確認誰需要照護、誰需要送眠、誰的名字要先被穩住。這裡的敬虔常表現成對秩序與節制的耐心。';
        Rites='送眠唱、冰橋換守、寒井封名、回音復名';
        Adult='成年往往與能否承擔照護、守橋或守墓有關。霜諾蘭看重的不是你多勇，而是你能否在極冷與失序邊緣還維持對他者的照顧。';
        Death='霜諾蘭把送眠視為最重要的宗教責任之一。送眠不只是埋葬，而是讓名字在寒與霧之間被穩穩地安放，不至於裂成回聲。';
        Taboos='遺名失護、擅開名墓、在眠霧期呼喚禁名、拿守眠與送眠去做階級炫示';
        Tension='最大張力在守眠舊誓與新井學環之間。前者害怕知識被教薄，後者害怕知識只剩少數人掌握而導致更多人得不到照護。';
        Prayer='「願寒不奪名，願霧不裂心，願死者與生者都被穩穩放回其位。」'
    }
)

foreach($r in $realms){
    $content = @"
# $($r.Name)

## 信仰主軸
$($r.Realm) 的信仰核心是「$($r.Axis)」。這裡的精靈通常不把宗教理解成獨立於生活的殿堂制度，而是理解成一套滲入命名、道路、伴生、工作、成年與送眠的總秩序。若生活方式違背了這套秩序，對在地人而言，那不只是失禮，也是褻瀆。

## 最常被提及的高位權柄
- $($r.Gods)
- 在 $($r.Realm) 的語境裡，這些高位權柄通常不以單一神像或單一經典出現，而是被轉寫成在地的責任倫理、守護工作與祭儀節奏。

## 神聖節點與祭場
- $($r.Sites)
- 這些場域兼具生活用途與神聖地位。人們在其中工作、受教、照護、守望、送眠，也在其中被見證與記住。

## 常見神職與信仰職責
- $($r.Roles)
- 伊莎梅爾的精靈通常不把這些角色看成脫離日常生活的祭司階層，而更像在不同神聖責任上被共同體正式承認的人。

## 日常實踐
$($r.Daily)

## 祭儀與節律
- 常見大祭與地方節奏：$($r.Rites)
- 祭儀的重點不是召喚神蹟，而是讓人、地形、伴生生靈與共同體責任重新對齊。
- 許多祭儀同時也是公共校準：確認誰有資格走哪段路、守哪個池、帶哪頭龍、修哪座橋、照看哪一批幼裔。

## 成年禮與靈誓伴
$($r.Adult)

## 送眠、祖名與記憶
$($r.Death)

## 最重禁忌
- $($r.Taboos)
- 伊莎梅爾的禁忌大多不是抽象戒律，而是會直接危害共同體與棲地秩序的行為。

## 內部張力與異端感
$($r.Tension)

## 常見祈詞
> $($r.Prayer)

## 相關入口
- [伊莎梅爾精靈共通信仰總論](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/leafvein-naming-tradition.md)
- [伊莎梅爾宗教與信仰格局](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/isamel-faith-landscape.md)
- [伊莎梅爾九大葉脈文明域](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/isamel-leafvein-realms.md)
"@
    Write-Utf8BomFile -Path (Join-Path $faithDir $r.File) -Content $content
}

$landscape = @'
# 伊莎梅爾宗教與信仰格局

伊莎梅爾不以單一教團或神殿國教統治，而是由 `葉脈命名諸傳` 串起九大精靈文明域。對精靈而言，宗教不是從生活外部施加的律令，而是名字是否被妥善見證、靈誓伴是否被善待、路與棲地是否被守住、死者是否被恰當送眠的總體秩序。

## 入口
- [伊莎梅爾精靈共通信仰總論](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/leafvein-naming-tradition.md)
- [伊莎梅爾信仰與祭儀索引](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/README.md)

## 大陸共通信仰底色
- 最常被提及的高位權柄是 `萬物母`、`憶夢者`、`夜引者`、`鑒誓者` 與 `鑄形者`。
- 精靈通常不把信仰視為獨立於生活的殿堂體系，而是視為 `名字是否正確`、`伴生是否守約`、`道路是否被善待`、`死者是否被正確記住`。
- 靈誓伴、域樹、井樹、寒穴根脈、潮岸聽崖與祭火藤場，都可成為地方性的神聖節點。
- 雲瑟母樹是最古老的命名中樞之一，但它只會傳出微弱共鳴，不直接統御全大陸。

## 九域摘要
### 雲瑟靈雲冠域
- 主軸：命名、共息、母樹見證與跨族共生。
- 詳細內容：[雲瑟靈雲冠域信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/yunselin-faith-and-rites.md)

### 瑟塔嶺星墜臺原
- 主軸：高風誓望、飛龍秩序、星墜觀測與天空責任。
- 詳細內容：[瑟塔嶺星墜臺原信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/thertalyn-faith-and-rites.md)

### 菲露涅羽蔭林庭
- 主軸：護林、藥脂照護、羽鳳守靜與林冠責任。
- 詳細內容：[菲露涅羽蔭林庭信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/filune-faith-and-rites.md)

### 維塔蕾漂葦林灣
- 主軸：低潮守約、浮橋共同體、工藝即守護與橋泊誓序。
- 詳細內容：[維塔蕾漂葦林灣信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/vithare-faith-and-rites.md)

### 雅席爾沉雨澤境
- 主軸：沉雨、澤錄、眠礦與順季而行的服從。
- 詳細內容：[雅席爾沉雨澤境信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/yathire-faith-and-rites.md)

### 歐羅瑟聽潮岸林
- 主軸：聽潮、讀崖、岸林守望與聲訊責任。
- 詳細內容：[歐羅瑟聽潮岸林信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/olorase-faith-and-rites.md)

### 奧里梵晨火蔓叢
- 主軸：晨火試禮、火道記誓、蔓叢守線與燃霧演訓。
- 詳細內容：[奧里梵晨火蔓叢信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/aulifan-faith-and-rites.md)

### 米蘭羽迷澤川
- 主軸：靜泊、聽池、盲沼照看與不驚動水霧的守則。
- 詳細內容：[米蘭羽迷澤川信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/milanyu-faith-and-rites.md)

### 霜諾蘭眠霧寒穴
- 主軸：守眠、名墓、冬井誓律與在寒中維持有序的善意。
- 詳細內容：[霜諾蘭眠霧寒穴信仰與祭儀](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/shranolan-faith-and-rites.md)

## 跨域共通禁律
- 不得未經見證帶走幼龍、巢材、鳳裔灰羽或高階祭枝。
- 成年禮與尋伴禮失序，必須回報地方見證者，不可私自壓下。
- 外客若要接觸命名、伴生或祭儀核心內容，需有在地枝庭、守望庭、井師或同級見證者陪同。
- 將靈誓伴視為財貨、炫耀器或不具名字的資產，會被幾乎所有文明域視為深重褻瀆。
'@
Write-Utf8BomFile -Path (Join-Path $base 'isamel-faith-landscape.md') -Content $landscape

$overviewPath = Join-Path $base 'overview.md'
$overview = Get-Content -Path $overviewPath -Encoding utf8 -Raw
if($overview -notmatch '伊莎梅爾信仰與祭儀索引'){
    $overview = $overview -replace '(- \[伊莎梅爾節慶與儀式對照\]\(.+?\)\r?\n)', "$1- [伊莎梅爾宗教與信仰格局](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/isamel-faith-landscape.md)`r`n- [伊莎梅爾信仰與祭儀索引](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/README.md)`r`n"
    Write-Utf8BomFile -Path $overviewPath -Content $overview
}

$realmMap = @{
    'yunselin-spiritcloud-canopy.md'='yunselin-faith-and-rites.md'
    'thertalyn-starfall-plateau.md'='thertalyn-faith-and-rites.md'
    'filune-grove.md'='filune-faith-and-rites.md'
    'vithare-weald.md'='vithare-faith-and-rites.md'
    'yathire-marshes.md'='yathire-faith-and-rites.md'
    'olorase-coastwood.md'='olorase-faith-and-rites.md'
    'aulifan-thickets.md'='aulifan-faith-and-rites.md'
    'milanyu-reaches.md'='milanyu-faith-and-rites.md'
    'shranolan-hollow.md'='shranolan-faith-and-rites.md'
}
$realmsDir = Join-Path $base 'realms'
foreach($file in $realmMap.Keys){
    $path = Join-Path $realmsDir $file
    $content = Get-Content -Path $path -Encoding utf8 -Raw
    if($content -notmatch '## 信仰與祭儀概況'){
        $name = Get-MarkdownTitle -Path $path
        $link = "C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/$($realmMap[$file])"
        $insert = @"

## 信仰與祭儀概況
$name 的信仰並不是從日常外部施加的規條，而是深深嵌在命名、成年、道路、守護工作與送眠中的共同秩序。這一域的祭儀、禁忌、常用祈詞、神聖節點與內部宗教張力，已整理在下列專章：
- [$name信仰與祭儀]($link)
- [伊莎梅爾精靈共通信仰總論](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/leafvein-naming-tradition.md)
"@
        $content = $content -replace '(## 內部張力.*?)(\r?\n## 主要地方)', "$1$insert`r`n`r`n## 主要地方"
        Write-Utf8BomFile -Path $path -Content $content
    }
}
