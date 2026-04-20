# 原型區

這裡放的是 `Elaris 文字遊戲` 的可執行原型，而不是世界觀原始資料。

目前第一個做好的切片是：

- [幽語海 CLI 原型說明](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.md)
- [幽語海 CLI 原型腳本](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.ps1)
- [幽語海 region pack v1](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/regions/whispersea-region-pack-v1.json)

## 目前能做什麼

- 白身開局：`跟行者 / 見習 / 短工`
- 起始落點選擇：`寂岩孤島 / 潮息海窟 / 靜唱索岬`
- 三條 starter quest 都可完整推進與交付：
  - `寂岩孤島的潮骨舊誓`
  - `潮息海窟的錯返潛路`
  - `靜唱索岬的斷索號`
- 在每個落點都能先用 `talk` 和關鍵人物搭話，開出線索與職業方向
- 搭話與任務交付現在會累積 `NPC 好感`，可逐步把地方關係從陌生推到可信任
- 每個落點通常只有 `0-2 位` 人物會在好感達標後願意 `同行`
- 一般狀態下，最多可帶 `2 位正式同行`；被地方默認成 `小型冒險團` 後，上限提高到 `3 位`
- 只有少數 NPC 會在好感達標後願意 `同行`，不是每個地方人物都能招進隊伍
- 招進隊後，現在可以用 `party` 看整隊名單、隊伍編制、主同行與每位同行的留下理由
- 也可以用 `focus <number>` 切換主同行
- 招進隊後，現在可以用 `companion` 直接查看主同行的背景、風格、偏好、數據、當前裝備與留下理由
- 目前原型預設同行者不會無故離隊；只要沒真的踩線，他們會繼續留在隊上，除非玩家主動讓他們留在安全點
- `companion` 現在也會直接顯示目前哪些補給與裝備欄正好對味
- `companion` 現在也會顯示同行者自己的成長線、目前階段、已解鎖里程碑與下一段進度
- 同行中的少數 NPC，現在也會在 `danger` 類遭遇裡一起出手
- 若想直接驗證這件事，現在可用 `encounter danger` 叫出危險遭遇，不必等亂數
- 你現在也可以把部分物資交給同行者保管，讓對方在硬局裡動用一份補給替你多穩一次局面
- 若你交給對方的正好是他偏好的補給，援手效果會更強，也可能順手多帶出線索或可信度
- 你現在也可以替同行者配置 `武器 / 防具 / 飾品`，讓對方在硬局裡多撐一段局勢
- 若裝備剛好落在對方最順手的欄位，這份援手也會再加強
- 同行者暫時離隊時，不會自動交還你送出去的物資或裝備；那些東西會留在對方身上，之後再同行時還在
- 同行者現在也會因為一起跑區、一起扛危險、命中對味配裝而慢慢成長，不再只是靜態援手
- 少數同行者在好感與里程碑達標後，還會把自己的 `同行支線` 放上熟人任務板
- 這些同行支線沿用同一套 `board / take / quest / turnin` 流程，不需要額外學新指令
- 在每個落點都能用 `jobs` / `work` 接白身短工，先靠地方雜活活下來
- 在每個落點都能用 `services` / `buy` 做最低限度補給
- 可用 `rest` 讓時間推進、稍微緩掉現場壓力
- 任務完成後會正確結算報酬、物品、地區評價與職業方向
- 在其他落點查看當地任務板，並用 `take <number>` 接下新的 starter quest
- `encounter` 現在不是單純文本種子，而是可分流處理的遭遇：
  - 生成遭遇
  - 顯示選項
  - 用 `respond <number>` 解決
  - 把線索 / 評價 / 職業方向寫回狀態
  - 部分遭遇會再接一段 `遭遇後續`，形成小型鏈式分流
- 存檔 / 讀檔後保留位置、任務、線索、物品與開出的職業方向
- 存檔 / 讀檔後也會保留：
  - 已搭過話的 NPC
  - 已建立的 NPC 好感
  - 目前同行名單、主同行與是否已成團
  - 當日做過的白身短工
  - 尚未處理完的遭遇

## 這一層和其他資料夾的關係

- [content/game](/C:/Users/rabbi/Desktop/Elaris/content/game/README.md)
  這裡是玩家規則、卡庫與橋接資料
- [text-game/02-data](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/compiled-data-format-v1.md)
  這裡是把世界資料編成遊戲可讀格式
- [text-game/03-runtime](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/runtime-state-model.md)
  這裡是狀態、存檔與回合流程模型

## 下一步最自然的擴充

- 讓三條 starter quest 彼此之間出現更明確的後續掛鉤
- 把 `talk / jobs / services` 接到更多白身生活線與地方傳聞
- 把 NPC 好感接到更深的委託、折扣、放行情境與地方庇護
- 把 `encounter` 從目前的兩段式遭遇，再往更深的危險 / 社交 / 撤退鏈式分流擴充
- 做第二個區域包，驗證跨區複用結構


