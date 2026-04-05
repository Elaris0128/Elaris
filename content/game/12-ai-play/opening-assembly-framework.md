# 開局組裝框架

這份是 AI / 主持端的開局工作表。
目的不是做固定劇本，而是讓每次開局都能：
- 先符合角色種族與起始區域
- 再保留隨機性
- 最後長出該地區的味道與第一批可接內容

## 開局核心原則
1. 先決定 `玩家在哪裡醒來或出現`
2. 再決定 `第一個立刻要處理的壓力`
3. 再決定 `第一批可以互動的人、地點、委託`
4. 最後才補 `尾鉤與下一步`

## 正式流程
1. 讀玩家的 `種族 / 分支`
2. 查 [玩家起始區域與開局包對照表](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/player-start-region-and-opening-pack-matrix.md)
3. 確認該區是 `A1 / A2 / A3` 哪一種來源
4. 讀對應的 [玩家地區專屬開局包](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/regional-opening-pack-library.md) 與 [AI 地區專屬開局包](C:/Users/rabbi/Desktop/Elaris/content/game/12-ai-play/regional-opening-pack-library.md)
5. 若該區有既有任務池，就依 [AI 開局任務抽取指南](C:/Users/rabbi/Desktop/Elaris/content/game/12-ai-play/ai-opening-quest-draw-guide.md) 優先抽既有任務
6. 再用本框架組第一幕

## A 級來源判法
- `A1`：直接抽既有獨立任務檔
- `A2`：直接讀地區 starter / questline / region pack
- `A3`：直接用地區開局模板組合，不另抽獨立任務檔

## 每次開局一定要組出的五塊
- 起始落點：玩家人在哪裡
- 立即壓力：眼前不處理就會變糟的事
- 第一目標：玩家很快能理解的短期目標
- 第一批互動點：人、地點、委託、證據
- 第一個麻煩：讓局勢變得不只是一件小事

## 壓力類型庫
- 社交壓力：查驗、拒收、誤會、欠帳、身份卡關
- 生存壓力：失溫、缺藥、船損、迷路、補給不足
- 戰鬥壓力：遭襲、包夾、追獵、怪物逼近
- 時間壓力：潮窗要關、船要開、證物要壞、天氣要變
- 灰線壓力：黑市摻手、貨物不乾淨、有人想抹名
- 異變壓力：錯燈、病潮、污染、低語、異樣徵兆

## 第一幕最安全的組法
- `1` 個起始落點
- `1` 個立即壓力
- `2` 個互動點
- `1` 個可接任務
- `1` 個後續麻煩

## 第一幕不要同時塞太多的東西
- 不要第一幕就同時丟 `首領戰 + 大異變 + 多勢力會談`
- 不要在玩家還不懂地區時，先塞三條以上長線
- 不要讓第一個難點完全不對應角色能力

## 常見地區開局偏好
### 幽語海
- 適合：低聲異變、港邊失蹤、潮路問題、守路委託
- 第一壓力常見：錯潮、潮窟病、失路、低聲壞兆

### 焰潮洋
- 適合：海盜、海人守域、危材、熱潮補給
- 第一壓力常見：貨不乾淨、暗泊衝突、熱潮窗口、巡守阻攔

### 暮鏡荒境
- 適合：寒境生存、部族誓約、狩獵、邊境守望
- 第一壓力常見：雪夜、獸群、獵路衝突、守界問題

### 王都都市圈
- 適合：查案、執照、社交、議價、階層衝突
- 第一壓力常見：通行卡關、委託競標、名譽問題、證物糾紛

### 港邊航務圈
- 適合：航權、泊位、運輸、救援、灰線查驗
- 第一壓力常見：泊位不足、貨損、查驗、船班時間壓力

## AI 輸出時的最短模板
- 你現在在：`起始落點`
- 你立刻碰上：`立即壓力`
- 你可以先接觸：`2 個互動點`
- 你現在最清楚的短目標：`第一目標`
- 如果拖延，會發生：`第一個麻煩`

## 搭配使用
- [Opening Flow](C:/Users/rabbi/Desktop/Elaris/content/game/12-ai-play/opening-flow.md)
- [玩家開局組裝工具](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/player-opening-construction-kit.md)
- [玩家開局模板庫](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/player-opening-template-library.md)
- [開局任務推薦矩陣](C:/Users/rabbi/Desktop/Elaris/content/game/10-quests/player-opening-quest-recommendation-matrix.md)
