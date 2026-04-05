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
- 任務完成後會正確結算報酬、物品、地區評價與職業方向
- 在其他落點查看當地任務板，並用 `take <number>` 接下新的 starter quest
- `encounter` 現在不是單純文本種子，而是可分流處理的遭遇：
  - 生成遭遇
  - 顯示選項
  - 用 `respond <number>` 解決
  - 把線索 / 評價 / 職業方向寫回狀態
- 存檔 / 讀檔後保留位置、任務、線索、物品與開出的職業方向

## 這一層和其他資料夾的關係

- [content/game](/C:/Users/rabbi/Desktop/Elaris/content/game/README.md)
  這裡是玩家規則、卡庫與橋接資料
- [text-game/02-data](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/compiled-data-format-v1.md)
  這裡是把世界資料編成遊戲可讀格式
- [text-game/03-runtime](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/runtime-state-model.md)
  這裡是狀態、存檔與回合流程模型

## 下一步最自然的擴充

- 讓三條 starter quest 彼此之間出現更明確的後續掛鉤
- 把 `encounter` 從目前的單次處理，再往更深的危險 / 社交 / 撤退鏈式分流擴充
- 做第二個區域包，驗證跨區複用結構
