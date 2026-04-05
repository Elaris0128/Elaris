# AI 開局任務抽取指南

這份指南給 AI / 主持使用，目的是讓「選種族後鎖定區域，再隨機生成開局」這條流程穩定、可重現，而且不需要重寫第二份任務內容。

## 核心原則

所有可玩起始區，統一視為 `A 級可開局`。
差別只在抽取來源：
- `A1`：直接讀既有 quest 檔。
- `A2`：直接讀 region package 的 starter docs。
- `A3`：直接讀地區開局包與模板。

## AI 開局總流程

1. 先看 [玩家起始區域與開局包對照表](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/player-start-region-and-opening-pack-matrix.md)
2. 鎖定玩家起始區的 `A1 / A2 / A3` 類型
3. 若為 A1，改讀 [開局任務推薦矩陣](C:/Users/rabbi/Desktop/Elaris/content/game/10-quests/player-opening-quest-recommendation-matrix.md)
4. 若為 A2，改讀 `starter-overview -> starter-quests -> questlines`
5. 若為 A3，直接讀 [AI 地區專屬開局包](C:/Users/rabbi/Desktop/Elaris/content/game/12-ai-play/regional-opening-pack-library.md)
6. 組成第一批玩家可見內容：
   - 1 個主要問題
   - 1 個次要麻煩
   - 1 個地區味道事件或互動點

## A1 抽取規則

### 直接起始 A1 區
- 幽語海：`whispersea-quest-*`
- 靈穹洋：`spiritvault-ocean-quest-*`
- 焰潮洋：`embersurge-ocean-quest-*`
- 霧羽列島：`fogfeather-isles-quest-*`
- 星盞群島：`starlantern-isles-quest-*`
- 天冠洋極地邊海：`heavencrown-ocean-quest-*`
- 亡極徹淵：`abyss-quest-*`

### 背景例外 A1 區
- 奧崙群星帶：`aolun-starbelt-quest-*`
- 曦環浮境：`xihuan-floating-quest-*`
- 晨穗群島：`morning-isles-quest-*`
- 潮牢列島：`tide-prison-isles-quest-*`
- 黯鉚列島：`dark-anchor-isles-quest-*`
- 暮牙海：`duskfang-sea-quest-*`
- 殞星海：`meteorfall-sea-quest-*`
- 天脈島弧：`tianmai-isle-arc-quest-*`
- 世界流動人物線：`world-wanderers-quest-*`

### A1 抽法
- 先抽推薦首抽範圍內 1 件任務。
- 再從同範圍或第二波範圍抽 1 件支援任務或次麻煩。
- 若玩家主動表達高風險、深掘或灰線意圖，再拉到高風險區間。

### A1 輸出格式
AI 開場時建議直接輸出：
- 第一個可見麻煩
- 這個麻煩背後的委託或需求者
- 玩家當下能立刻做的第一步
- 若忽略它會怎樣

## A2 抽取規則

### A2 區域
- 阿瓦隆王國
- 瑟恩聯邦國
- 暮鏡荒境
- 杜羅山邦
- 杜魯摩克隱域
- 薩德原遷營
- 涅厄斯魔人國
- 瑟堤亞棲國 / 雲裂哨站
- 十個精靈主域
- 克羅嵐、魈陽、巖穹三聯域與其同級支地

### A2 讀取順序
1. `starter-overview.md`
2. `starter-quests.md`
3. `questlines.md`
4. 若存在，再讀 `quest-details.md`

### A2 抽法
- 先整理出 2 至 3 條可直接開局的任務線。
- 再挑 1 條作為主要問題，1 條作為次問題。
- 如果玩家隊伍有明顯職業傾向，優先選能讓該職業發揮的那條。

## A3 抽取規則

### A3 區域
- 港邊航務圈
- 法雷恩沿海諸港
- 葉脈樹海圈
- 萬嶺幽陵山陵圈
- 多數獸人邊支地
- 森馳裔邊林圈

### A3 組裝法
1. 先套地區開局包
2. 抽 `第一壓力`
3. 抽 `第一目標`
4. 抽 `第一互動人物`
5. 抽 `第一個讓局勢變糟的麻煩`
6. 依玩家行動，臨時指向最近的世界觀任務、流動人物線、地方事件或魔物事故

## AI 需要避免的事
- 不要在同一開局裡一次丟三個大型主線。
- 不要把所有壓力都堆成戰鬥。
- 不要忽略地區文化與職業味道。
- 不要直接把高風險遠征任務丟給沒有準備的新手隊伍。

## AI 最佳開局節奏
- 第一幕：讓玩家先理解地區與眼前問題。
- 第二幕：給出兩個可選方向。
- 第三幕：讓一個麻煩浮上來，迫使隊伍表態。

## 參照檔
- [既有地區任務橋接索引](C:/Users/rabbi/Desktop/Elaris/content/game/10-quests/existing-region-quest-bridge-index.md)
- [開局任務推薦矩陣](C:/Users/rabbi/Desktop/Elaris/content/game/10-quests/player-opening-quest-recommendation-matrix.md)
- [玩家地區專屬開局包](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/regional-opening-pack-library.md)