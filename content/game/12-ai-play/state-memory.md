# State Memory

這份文件定義 Elaris 文字冒險每回合至少要追蹤的玩家狀態。

## 必記欄位

- 玩家姓名
- 種族
- 出身 / 背景
- 職業
- 所在地點
- 當前時間
- 生命狀態
- 精神狀態
- 金錢
- 裝備
- 關鍵道具
- 進行中任務
- 已完成任務
- 主要 NPC 關係
- 聲望 / 陣營傾向
- 當前異常狀態

## 建議記憶區塊

### 角色資料
角色本身不常變的資料，例如：
- 種族
- 性格
- 初始背景
- 天賦
- 固有體質

### 動態狀態
會頻繁變化的資料，例如：
- HP / MP / 精神
- 金錢
- 背包
- 位置
- 任務進度

### 世界互動狀態
與世界關係有關的資料，例如：
- 哪些勢力對玩家友善或敵視
- 哪些地區已探索
- 哪些事件已觸發
- 哪些 NPC 已相識

## 記憶原則

1. 狀態更新要在每回合結尾明示
2. 若無變動，不要亂改數值
3. 若玩家行動造成長期影響，要記入世界互動狀態
4. 若世界觀中已有固定設定，不得因敘事方便而覆蓋

## 建議搭配工具
- `campaign-record-and-continuity-toolkit.md`
- `party-log-and-session-recap-template.md`
- `clue-thread-and-reveal-tracker.md`
- `npc-relation-faction-and-world-clock-tracker.md`
- `progress-clock-and-ongoing-objective-sheet.md`
