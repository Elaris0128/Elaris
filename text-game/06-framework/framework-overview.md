# Elaris 文字遊戲框架總覽

這份文件描述 `text-game` 從單區原型走向完整遊戲時的骨架。

## 一、總體分層

### 1. 世界與規則原始資料

來源：

- [content/world](/C:/Users/rabbi/Desktop/Elaris/content/world)
- [content/game](/C:/Users/rabbi/Desktop/Elaris/content/game)
- [content/scenarios](/C:/Users/rabbi/Desktop/Elaris/content/scenarios)

角色：

- 提供正典
- 提供玩家規則
- 提供任務、人物、物品、魔物與地區資料

### 2. 遊戲資料層

位置：

- [02-data](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/compiled-data-format-v1.md)

角色：

- 把原始資料整理成遊戲可讀格式
- 讓每個區域有自己的 `region pack`

### 3. 執行狀態層

位置：

- [03-runtime](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/runtime-state-model.md)

角色：

- 記錄角色、位置、任務、關係、背包、同行、時間與遭遇
- 支援存檔 / 讀檔

### 4. 框架入口層

位置：

- [play-elaris.ps1](/C:/Users/rabbi/Desktop/Elaris/text-game/play-elaris.ps1)
- [06-framework](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/README.md)

角色：

- 提供整個遊戲的主入口
- 管理哪些區域目前可玩
- 負責把玩家送進對應切片

### 5. 單區原型層

位置：

- [05-prototypes](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/README.md)

角色：

- 先把一個區域做到真的能玩
- 驗證規則和互動是否站得住
- 再把成熟部件慢慢抽回框架層

## 二、目前第一版的策略

目前不是先做「整個世界都能跑」，
而是先做：

`一個完整單區 -> 提煉共用模組 -> 複製到第二區`

所以現在：

- `幽語海`
  是第一個完整可玩切片
- `06-framework`
  則是把第一個切片包成更正式的遊戲入口

## 三、目前框架已經做好的事

- 有正式主入口
- 有外部切片註冊表
- 有主選單
- 有框架狀態檢視
- 有存檔總覽
- 有共用路徑初始化
- 有可擴充模組資料夾
- 已接上 `幽語海` 這個第一個可玩區域

## 四、下一階段要慢慢抽離的東西

目前很多邏輯仍在 [whispersea-cli-prototype.ps1](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.ps1) 裡。

接下來最自然的抽離順序是：

1. 共用輸入 / 選單 / 顯示工具
2. 共用存檔層與繼續遊玩入口
3. 共用任務推進流程
4. 共用遭遇流程
5. 共用 NPC 關係與同行層
6. 多區域切換與旅行層

## 五、框架成功的標準

當下列條件成立時，就表示框架從「入口骨架」進入「正式遊戲核心」：

- 第二個區域可直接掛進註冊表
- 共用主入口不用改很多就能開第二區
- 共用存檔能同時辨識多區域狀態
- 共用任務 / 遭遇 / 同行機制不再寫死在單一 prototype 裡

## 六、目前最好的使用方式

如果你要：

- `直接玩`
  先用 [play-elaris.ps1](/C:/Users/rabbi/Desktop/Elaris/text-game/play-elaris.ps1)
- `直接測幽語海`
  也可以直接跑 [whispersea-cli-prototype.ps1](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.ps1)


