$ErrorActionPreference = 'Stop'

$enc = New-Object System.Text.UTF8Encoding($true)
$root = 'C:\Users\rabbi\OneDrive\Desktop\Elaris'

$realms = @(
  [pscustomobject]@{
    Key='yunselin';
    Label='雲瑟靈雲冠域';
    Faith='yunselin-faith-and-rites.md';
    CharDir='yunselin';
    CharFile='qingming.md';
    CharName='清銘';
    Branch='精靈 / 雲瑟皇族';
    Role='回名庭監誓者';
    Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/yunselin/mingzhi-archive.md';
    Summary='清銘長年負責回名、補名與名錄裂縫的公開再見證，對任何把名字當作權力工具的人都極為敏感。她在母樹體系中不是最顯眼的聲音，卻是最讓人不敢含糊帶過的一位監誓者。';
    Logic='確保共息秩序出現裂縫時，名字仍能被共同體正確看見並重新承責。';
    FaithSection=@(
      '## 宗教核心人物與節點事件',
      '- 核心人物：[清銘](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yunselin/qingming.md)｜回名庭監誓者',
      '- 事件包：[雲瑟神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/yunselin-sacred-node-events.md)'
    );
    EventFile='yunselin-sacred-node-events.md';
    EventBody=@(
      '# 雲瑟神聖節點事件包','',
      '## 事件主調',
      '雲瑟的宗教事件多半表面安靜，真正危險的是 `名字被悄悄改動、責任被悄悄轉移、共息裂縫被悄悄壓下`。主持時宜讓玩家感受到沉默本身就是壓力。','',
      '## 核心牽涉人物',
      '- [清銘](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yunselin/qingming.md)｜回名庭監誓者',
      '- [雲瑟．嘉銘](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yunselin/yunse-jiaming.md)｜母樹議序首唱者',
      '- [語衡](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yunselin/yuheng.md)｜深根共息引導者',
      '- [露竹](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yunselin/luzhu.md)｜花翎幼龍照護師','',
      '## 事件種子',
      '### 雙版本回名簿',
      '- 命枝典藏所出現兩份彼此矛盾的回名簿，兩邊都帶著完整見證痕跡。',
      '- 玩家要查的不是誰抄錯，而是誰把一段應由共息穴民承擔的勞務偷偷挪成皇族榮譽。','',
      '### 花翎龍錯肩',
      '- 小型花翎龍在尋伴季反覆停在一名被暫時剝奪啟名資格的孩子肩上。',
      '- 若硬壓下去，整個枝庭可能接受一個更大的失序；若放任，保守派會認為見證體系失效。','',
      '### 深根祠的舊條件',
      '- 深根共息祠要求重新見證一段舊共生條件，卻有人主張那只是早已失效的古式負擔。',
      '- 玩家可能要帶回被故意拆散的祠井記錄，讓交換條件重新被公開承認。','',
      '## 可用節點',
      '- [深根共息祠](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/yunselin/deeproot-symbiosis-shrine.md)',
      '- [橋光名庫](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/yunselin/qiaoguang-namevault.md)','',
      '## 主持提示',
      '- 雲瑟的危機很少先爆炸，通常先從記錄、停棲、沉默與誰不願簽名開始。',
      '- 真正的難點常是：把錯誤公開，會不會比暫時掩下造成更大動盪。'
    )
  },
  [pscustomobject]@{Key='thertalyn';Label='瑟塔嶺星墜臺原';Faith='thertalyn-faith-and-rites.md';CharDir='thertalyn';CharFile='wangling.md';CharName='望翎';Branch='精靈 / 瑟塔嶺族';Role='高風誓望主判';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/thertalyn/xinglu-oathwatch.md';Summary='望翎專管高風誓望、禁風裁定與試飛責任的最後覆核。他不反對革新，但極討厭任何拿飛龍或風道去賭群體安全的冒進。';Logic='在風與飛龍都可能奪命的地方，維持試禮與路權裁定的可信度。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[望翎](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/thertalyn/wangling.md)｜高風誓望主判','- 事件包：[瑟塔嶺神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/thertalyn-sacred-node-events.md)');EventFile='thertalyn-sacred-node-events.md';EventBody=@('# 瑟塔嶺神聖節點事件包','','## 事件主調','瑟塔嶺的宗教事件通常發生在 `風路、試飛、飛龍認可與星望裁定` 上。看起來像交通或演訓糾紛，但底層其實是誰有資格替天空說話。','','## 核心牽涉人物','- [望翎](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/thertalyn/wangling.md)｜高風誓望主判','- [瑟蓮](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/thertalyn/selian.md)｜星墜議庭總望者','- [緯壇](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/thertalyn/weitan.md)｜龍壇守誓者','- [風誓](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/thertalyn/fengshi.md)｜高脊試飛誓證官','','## 事件種子','### 無風封路日','- 明明風勢平穩，高脊風道卻被發布禁行。','- 玩家要查清楚這是偽訊、保守派拖延，還是真的有大型飛龍在更高處失序。','','### 不認新的天輝風龍','- 一頭天輝風龍拒絕接受新一輪試飛者靠近，只對舊式誓望語有回應。','- 問題不只是禮儀，而是整套新式訓練是不是把誓責砍得太快。','','### 被遮蔽的古星望路','- 年輕守路者發現一條舊觀測路被刻意從地圖上拿掉。','- 若重新公開，將動搖現在幾個家系對高風裁定的壟斷。','','## 可用節點','- [天輝龍風階](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/thertalyn/tianhui-drakewind-step.md)','- [雲脊龍壇](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/thertalyn/yunji-drakealtar.md)','','## 主持提示','- 讓風、坡差和高空噪音一直存在，宗教判準會更有重量。','- 瑟塔嶺的神聖性很少溫柔，它更像「承責後仍能活著回來」。')},
  [pscustomobject]@{Key='filune';Label='菲露涅羽蔭林庭';Faith='filune-faith-and-rites.md';CharDir='filune';CharFile='yuzhu.md';CharName='羽祝';Branch='精靈 / 菲露涅族';Role='林冠靜枝司祝';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/filune/feathercanopy-court.md';Summary='羽祝負責林冠靜枝、羽鳳停棲與鳳裔禁靜期的總體節律。她擅長安撫，也很懂得在照護被神聖化過頭時，替實務照看者爭一口氣。';Logic='維持護林、鳳裔靜期與幼龍試伴之間的平衡，不讓神聖感壓垮照護本身。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[羽祝](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/filune/yuzhu.md)｜林冠靜枝司祝','- 事件包：[菲露涅神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/filune-sacred-node-events.md)');EventFile='filune-sacred-node-events.md';EventBody=@('# 菲露涅神聖節點事件包','','## 事件主調','菲露涅的宗教危機常從 `照護失衡、林庭過度安靜、幼龍拒伴或羽鳳離枝` 開始。這裡最尖銳的衝突通常不是戰鬥，而是誰有資格說自己真正懂得照護。','','## 核心牽涉人物','- [羽祝](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/filune/yuzhu.md)｜林冠靜枝司祝','- [棲瑩](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/filune/qiying.md)｜幼龍試伴官','- [羽柯](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/filune/yuke.md)｜護林首席','- [眠槿](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/filune/mianjin.md)｜鳳羽儀式執唱','','## 事件種子','### 兩次拒伴','- 花翎幼龍連續拒絕兩位被看好的守林候選人。','- 玩家可能會發現問題不在孩子，而在某段被過度簡化的護林試禮。','','### 羽脂先給誰','- 林斑病蔓延與鳳裔靜枝期撞在一起，羽脂不足。','- 若優先救林，照護者會背上褻瀆之名；若優先護鳳，整片林庭可能惡化。','','### 靜枝被驚動','- 一處羽鳳靜枝在禁靜期被驚飛，但現場沒有外敵痕跡。','- 最後查到的可能是某位高位見證者默許了不該發生的近路施工。','','## 可用節點','- [心木井](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/filune/heartwood-well.md)','- [羽冠墜橋遺址](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/filune/crownbridge-ruins.md)','','## 主持提示','- 菲露涅適合用「照護是否被當成理所當然」來做情緒壓力。','- 讓玩家看到溫柔也需要分配、需要制度，這一域會更立體。')},
  [pscustomobject]@{Key='vithare';Label='維塔蕾漂葦林灣';Faith='vithare-faith-and-rites.md';CharDir='vithare';CharFile='tingzhu.md';CharName='汀祝';Branch='精靈 / 維塔蕾族';Role='低潮泊誓見證者';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/vithare/lowtide-pledgehall.md';Summary='汀祝專門主持低潮守約、泊橋輪值與浮橋誓錄。她最擅長的不是發號施令，而是把每個人都想逃掉的橋泊責任一條條拉回來。';Logic='守住維塔蕾最核心的低潮誓序，避免橋泊權被家系或商利悄悄吞掉。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[汀祝](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/vithare/tingzhu.md)｜低潮泊誓見證者','- 事件包：[維塔蕾神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/vithare-sacred-node-events.md)');EventFile='vithare-sacred-node-events.md';EventBody=@('# 維塔蕾神聖節點事件包','','## 事件主調','維塔蕾的宗教危機多半圍繞 `橋泊誓約、低潮窗口、漂棚命索與濕地靈誓伴照看`。這裡看起來像生活規矩，實際上每一條都關乎共同體能不能活過下一輪潮期。','','## 核心牽涉人物','- [汀祝](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/vithare/tingzhu.md)｜低潮泊誓見證者','- [橋頌](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/vithare/qiaosong.md)｜漂橋誓見者','- [蘆真](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/vithare/luzhen.md)｜根織橋樣師','- [聲露](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/vithare/shenglu.md)｜鐘羽鳳照看人','','## 事件種子','### 漂橋名索錯位','- 一條低潮開放名單被人悄悄調換，導致該渡的人反而過不去。','- 玩家要查的是誰改了索，還是誰讓這種改動看起來合法。','','### 鈴葦小龍成了族徽','- 某橋族把靈誓伴公開展示成家系榮耀，引起強烈反彈。','- 汀祝會要求玩家處理得很乾淨，因為這已踩到整個維塔蕾的宗教底線。','','### 巡禮路快斷了','- 一條漂葦巡禮路因泊位糾紛即將被封。','- 若不及時修補，不只信仰受損，後續整條濕地物資路也會跟著崩。','','## 可用節點','- [退潮根織場](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/vithare/lowtide-rootloom.md)','- [沉鈴蔓井](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/vithare/sinkingbell-vinewell.md)','','## 主持提示','- 維塔蕾的宗教感來自「每一次低潮都得有人真的守約」。','- 讓小錯累積成集體危機，這一域會很有重量。')},
  [pscustomobject]@{Key='yathire';Label='雅席爾沉雨澤境';Faith='yathire-faith-and-rites.md';CharDir='yathire';CharFile='yinzhao.md';CharName='印沼';Branch='精靈 / 雅席爾族';Role='雨印封沼見證者';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/yathire/rainseal-marshcourt.md';Summary='印沼擅長處理封沼、開汛與雨印失序。他對季節節律極為敏銳，也因此最反感把祭沼當成只服務資源開採的工具。';Logic='讓雅席爾的季節服從仍被共同體信任，而不被效率與礦務吞沒。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[印沼](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yathire/yinzhao.md)｜雨印封沼見證者','- 事件包：[雅席爾神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/yathire-sacred-node-events.md)');EventFile='yathire-sacred-node-events.md';EventBody=@('# 雅席爾神聖節點事件包','','## 事件主調','雅席爾的宗教危機多來自 `沉雨時序被打亂、祭沼邊界被動、澤錄與開採權互相污染`。這一域最怕的不是災，而是有人假借祭儀之名讓災變成可計價的工具。','','## 核心牽涉人物','- [印沼](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yathire/yinzhao.md)｜雨印封沼見證者','- [沫雨](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yathire/moyu.md)｜祭沼主錄官','- [雨潭](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yathire/yutan.md)｜祭沼水脈判讀師','- [深羽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/yathire/shenyu.md)｜睡霧羽鳳照看者','','## 事件種子','### 水色不對','- 祭沼顏色在還未到雨印翻轉日之前就開始變深。','- 玩家要判斷這是自然預警，還是有人利用祭儀遮掩眠礦外流。','','### 澤錄與礦錄對不上','- 開採紀錄和澤錄互相矛盾，卻都掛著合法見證。','- 這意味著至少有一條見證線被污染了。','','### 沼光幼龍離巢','- 幼龍一批批離開原巢，停在封沼邊界上不肯回去。','- 這通常代表某段被忽視的節律早已崩壞。','','## 可用節點','- [沉雨祭沼](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/yathire/deeprain-ritual-marsh.md)','- [眠礦泥脈井](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/yathire/sleepore-mudwell.md)','','## 主持提示','- 雅席爾適合把宗教和資源壓力直接捆在一起。','- 玩家越想快，越容易踩進錯誤的節律。')},
  [pscustomobject]@{Key='olorase';Label='歐羅瑟聽潮岸林';Faith='olorase-faith-and-rites.md';CharDir='olorase';CharFile='tingcha.md';CharName='聽岔';Branch='精靈 / 歐羅瑟族';Role='聽崖誓訊裁定者';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/olorase/listencliff-hall.md';Summary='聽岔專門處理聽崖回訊、岸路爭議與錯訊裁定。他的長處在於願意承認自己也可能誤聽，因此比許多高位聽崖者更可信。';Logic='維持海崖訊路的可信度，不讓任何一條錯訊毀掉整片岸林的守望秩序。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[聽岔](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/olorase/tingcha.md)｜聽崖誓訊裁定者','- 事件包：[歐羅瑟神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/olorase-sacred-node-events.md)');EventFile='olorase-sacred-node-events.md';EventBody=@('# 歐羅瑟神聖節點事件包','','## 事件主調','歐羅瑟的宗教危機常從 `錯訊、潮訊、岸路與聽崖權威` 爆開。這裡的神聖感來自守望是否可靠，一旦誰都不敢相信訊號，整域就會開始瓦解。','','## 核心牽涉人物','- [聽岔](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/olorase/tingcha.md)｜聽崖誓訊裁定者','- [潮聞](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/olorase/chaowen.md)｜根港聽訊總司','- [崖訊](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/olorase/yaxun.md)｜崖道訊牌校辨官','- [岬音](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/olorase/jiayin.md)｜靜汀祭唱師','','## 事件種子','### 互相否定的潮訊','- 同一晚，兩處聽崖傳回完全相反的封礁訊號。','- 玩家得進去看見到底是訊牌被動、潮訊被造，還是崖本身出了問題。','','### 廢岬塔旁的潮棘小龍','- 潮棘小龍連續守在一座已被判定無用的舊岬塔旁。','- 很可能有一段被掩埋的誓訊路正試著回來。','','### 骨路借給誰','- 某段骨路被低價借給急行隊，違反守望誓序。','- 若不處理，下一次真正的求援隊伍可能會失去唯一合法道路。','','## 可用節點','- [聽崖骨拱](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/olorase/clifflisten-bonearch.md)','- [潮影根門](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/olorase/chaoying-rootgate.md)','','## 主持提示','- 讓玩家聽見聲音，但很難立刻判斷哪個聲音可信，歐羅瑟就會成立。','- 這裡的權威很脆，卻又不能完全倒。')},
  [pscustomobject]@{Key='aulifan';Label='奧里梵晨火蔓叢';Faith='aulifan-faith-and-rites.md';CharDir='aulifan';CharFile='zhiyong.md';CharName='炙詠';Branch='精靈 / 奧里梵族';Role='晨火試道首誓者';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/aulifan/dawnflame-oathyard.md';Summary='炙詠長年主持晨火試禮與封火裁定，深知火道最容易被說成效率和勇氣，卻忘了它其實是一整套承責程序。';Logic='守住試道與封火的宗教底線，不讓火場秩序被軍事化或表演化吃掉。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[炙詠](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/aulifan/zhiyong.md)｜晨火試道首誓者','- 事件包：[奧里梵神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/aulifan-sacred-node-events.md)');EventFile='aulifan-sacred-node-events.md';EventBody=@('# 奧里梵神聖節點事件包','','## 事件主調','奧里梵的宗教危機常在 `試道資格、封火秩序、火藤讓路與演訓過度化` 之間爆發。這裡最怕的是有人把試禮說成只有速度和膽量。','','## 核心牽涉人物','- [炙詠](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/aulifan/zhiyong.md)｜晨火試道首誓者','- [焰柒](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/aulifan/yanqi.md)｜火徑裁定官','- [曉徑](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/aulifan/xiaojing.md)｜試道評定官','- [切蔓](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/aulifan/qieman.md)｜滑翼龍試場教官','','## 事件種子','### 封火期被提前點亮','- 有人私啟試場，卻堅稱自己得到晨火允可。','- 真相可能是有人拿舊誓詞做新用途。','','### 失敗者被直接剝名','- 某演訓師把試禮失敗者記成「無名不得行」。','- 玩家若介入，會直接撞上奧里梵對責任與羞辱邊界的爭論。','','### 滑翼龍偏離火道','- 蔓焰滑翼龍在試禮當日連續偏航。','- 這可能不是生物問題，而是試場本身已不再被認可。','','## 可用節點','- [晨火試庫](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/aulifan/dawnfire-trial-vault.md)','- [火藤密語谷](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/aulifan/firevine-mistvale.md)','','## 主持提示','- 奧里梵的宗教戲劇很適合放在「誰把責任說成榮耀，誰把榮耀說成責任」上。','- 讓火有吸引力，也有代價，這一域會更有形。')},
  [pscustomobject]@{Key='milanyu';Label='米蘭羽迷澤川';Faith='milanyu-faith-and-rites.md';CharDir='milanyu';CharFile='wuqi.md';CharName='霧祈';Branch='精靈 / 米蘭羽族';Role='聽池靜泊守唱';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/milanyu/jingbo-listenhall.md';Summary='霧祈長於靜泊、泊簿與聽池守唱的節律維護。他最常處理的不是大災，而是那些足以讓整片迷澤慢慢失去方向感的小錯。';Logic='維持米蘭羽的靜泊秩序，讓迷澤不因急躁、壟斷或誤導而失去可通行的聽路。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[霧祈](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/milanyu/wuqi.md)｜聽池靜泊守唱','- 事件包：[米蘭羽神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/milanyu-sacred-node-events.md)');EventFile='milanyu-sacred-node-events.md';EventBody=@('# 米蘭羽神聖節點事件包','','## 事件主調','米蘭羽的宗教危機通常不是轟然爆發，而是 `路簿少了一頁、唱法改了半句、霧牆多封一段`。當這些小差錯堆在一起，迷澤就會吃人。','','## 核心牽涉人物','- [霧祈](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/milanyu/wuqi.md)｜聽池靜泊守唱','- [澤聞](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/milanyu/zewen.md)｜聽池主聽','- [泊矩](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/milanyu/boju.md)｜棧橋泊記校準官','- [霧羽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/milanyu/wuyu.md)｜眠羽回燼鳳照看人','','## 事件種子','### 泊簿缺頁','- 一支送眠隊伍在盲沼邊界失去合法路線，因為泊簿少了一頁。','- 真正問題可能不是遺失，而是有人刻意把那頁藏起來。','','### 只有新唱法有效','- 霧潟小龍忽然只對新唱法有回應，讓老派守唱者大為不安。','- 這是革新前兆，還是有人正利用節點弱化來建立新權威？','','### 靜泊被拖太久','- 聽池守唱者互相指責對方故意拖長靜泊期。','- 一旦拖太久，整片迷澤的生活節律都會被壓慢。','','## 可用節點','- [霧牆盲域](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/milanyu/mistwall-blindzone.md)','- [睡羽澤泊](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/milanyu/sleepfeather-marsh.md)','','## 主持提示','- 米蘭羽最迷人的地方是：安靜本身也可能是一場權力角力。','- 把「慢」寫成必要，而不是拖延，這裡會很有味道。')},
  [pscustomobject]@{Key='shranolan';Label='霜諾蘭眠霧寒穴';Faith='shranolan-faith-and-rites.md';CharDir='shranolan';CharFile='mianshi.md';CharName='眠誓';Branch='精靈 / 霜諾蘭族';Role='回名冬井主見';Location='C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/locations/shranolan/fengwu-oathwell.md';Summary='眠誓長年主持冬井誓見、回名補錄與送眠次序校正。她對「名字先回，還是活人先活」這個問題沒有輕鬆答案，但會逼每個人正視自己選擇的代價。';Logic='在極寒與資源壓力中維持送眠、回名與冬井誓律仍可被共同體承認。';FaithSection=@('## 宗教核心人物與節點事件','- 核心人物：[眠誓](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/shranolan/mianshi.md)｜回名冬井主見','- 事件包：[霜諾蘭神聖節點事件包](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/faith/shranolan-sacred-node-events.md)');EventFile='shranolan-sacred-node-events.md';EventBody=@('# 霜諾蘭神聖節點事件包','','## 事件主調','霜諾蘭的宗教危機幾乎總是把 `生者存活、死者回名、冰橋分配、寒井見證` 綁在一起。這一域沒有簡單的善惡，只有誰先承受。','','## 核心牽涉人物','- [眠誓](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/shranolan/mianshi.md)｜回名冬井主見','- [寒銘](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/shranolan/hanming.md)｜名墓封記官','- [冰素](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/shranolan/bingsu.md)｜送眠唱者','- [霜羽](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/shranolan/shuangyu.md)｜霜紋幼龍照看者','','## 事件種子','### 名墓回了活名','- 霧霜名墓連續回出尚未送眠者的名字。','- 玩家得判斷這是誤錄、預警，還是有人故意改了回名次序。','','### 霜紋幼龍不離寒井','- 幼龍拒絕離開寒井，像是在替某段送眠程序守位。','- 若把它強行帶走，可能會讓冬井見證整段斷掉。','','### 冰橋先給誰走','- 一支救援隊與送眠隊伍同時卡在同一段冰橋。','- 誰先走都會有人恨，但不選更糟。','','## 可用節點','- [霧霜名墓](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/shranolan/mistfrost-namecrypt.md)','- [眠霧穴群](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/02-continents/04-isamel/sites/shranolan/mistcave-cluster.md)','','## 主持提示','- 霜諾蘭適合讓玩家真正感受到「秩序也是用來保命的」。','- 當所有人都很累、很冷、很想快，宗教才最容易露出真正重量。')}
)

foreach ($r in $realms) {
  $charPath = Join-Path $root ("content\world\07-characters\{0}\{1}" -f $r.CharDir, $r.CharFile)
  $charContent = @"
# $($r.CharName)

## 身分
- 所屬文明域：$($r.Label)
- 種族：精靈
- 種族-分支：$($r.Branch)
- 角色定位：$($r.Role)
- 常見出沒：[$($r.Label)]($($r.Location))

## 簡述
$($r.Summary)

## 互動方向
- 可作為宗教危機、見證爭議、靈誓伴失序或節點修復任務的第一層在地窗口。
- 不會輕易替玩家開特權，但願意替真正願意承責的人補上一段被忽略的見證。
- 若玩家能理解 $($r.Logic) 背後的地方倫理，會更願意給出深層協助。
"@
  [System.IO.File]::WriteAllText($charPath, $charContent.TrimStart(), $enc)

  $eventPath = Join-Path $root ("content\world\02-continents\04-isamel\faith\{0}" -f $r.EventFile)
  [System.IO.File]::WriteAllText($eventPath, (($r.EventBody -join "`r`n").TrimStart()), $enc)

  $readmePath = Join-Path $root ("content\world\07-characters\{0}\README.md" -f $r.CharDir)
  $readme = Get-Content -Path $readmePath -Raw -Encoding UTF8
  if ($readme -notmatch [regex]::Escape($r.CharName)) {
    $readme = $readme.TrimEnd() + "`r`n- [$($r.CharName)](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/$($r.CharDir)/$($r.CharFile))｜$($r.Role)`r`n"
    [System.IO.File]::WriteAllText($readmePath, $readme, $enc)
  }

  $faithPath = Join-Path $root ("content\world\02-continents\04-isamel\faith\{0}" -f $r.Faith)
  $faith = Get-Content -Path $faithPath -Raw -Encoding UTF8
  if ($faith -notmatch '## 宗教核心人物與節點事件') {
    $faith += "`r`n`r`n" + ($r.FaithSection -join "`r`n") + "`r`n"
    [System.IO.File]::WriteAllText($faithPath, $faith, $enc)
  }
}

$indexPath = Join-Path $root 'content\world\02-continents\04-isamel\isamel-character-index.md'
$index = Get-Content -Path $indexPath -Raw -Encoding UTF8
foreach ($r in $realms) {
  if ($index -notmatch [regex]::Escape($r.CharName)) {
    $sectionHeader = "## $($r.Label)"
    $insert = "- [$($r.CharName)](C:/Users/rabbi/OneDrive/Desktop/Elaris/content/world/07-characters/$($r.CharDir)/$($r.CharFile))｜$($r.Role)"
    $pattern = "($([regex]::Escape($sectionHeader))(?:.|\r|\n)*?)(?=\r?\n## |\z)"
    $index = [regex]::Replace($index, $pattern, { param($m) ($m.Groups[1].Value.TrimEnd() + "`r`n" + $insert + "`r`n") }, 1)
  }
}
[System.IO.File]::WriteAllText($indexPath, $index, $enc)