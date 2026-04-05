# 幽語海 CLI 原型

這份原型是 `Elaris 文字遊戲` 的第一個單區可玩切片。它的目標不是一次做完整世界，而是先把一個區域做成可反覆驗證、可複製到其他區域的玩法骨架。

目前這個原型已經證明三件事：

- 白身開局可以成立
- 單區 starter quest 可以完整推進、交付、結算
- 單次遭遇可以獨立分流，並把結果寫回玩家狀態

## 執行方式

在 PowerShell 執行：

```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\rabbi\Desktop\Elaris\text-game\05-prototypes\whispersea-cli-prototype.ps1"
```

## 目前支援的內容

### 開局

- 白身身分：
  - `跟行者`
  - `見習`
  - `短工`
- 起始落點：
  - `寂岩孤島`
  - `潮息海窟`
  - `靜唱索岬`
- 新遊戲時會自動掛上該落點對應的第一條 starter quest

### 任務

- 每條任務都有：
  - 多步推進
  - 正確地點限制
  - 線索累積
  - 完成後交付
  - 現金 / 物品 / 地區評價 / 職業方向結算
- 完成第一條後，可以到其他落點用 `board` 看當地任務板，再用 `take <number>` 接下一條 starter quest
- 目前已驗證可完整交付與結算的 starter quest：
  - `寂岩孤島的潮骨舊誓`
  - `潮息海窟的錯返潛路`
  - `靜唱索岬的斷索號`

### 遭遇

- `encounter` 會生成單次遭遇，而不是只顯示一段風味文字
- 每次遭遇都會提供 3 個可選應對
- 玩家需用 `respond <number>` 做出選擇
- 未處理遭遇時：
  - 不能移動
  - 不能接新任務
  - 不能推進任務步驟
  - 不能交付任務
- 遭遇結果會寫回：
  - 線索
  - 現金
  - 物品
  - 地區評價
  - 職業方向
  - 壓力標記

### 狀態與存檔

- `status` 看角色、位置、物資、現金、線索、已開職業方向與目前遭遇
- `save` 可存檔
- 主選單 `讀取存檔` 可接續遊玩
- 存檔後會保留：
  - 位置
  - 任務進度
  - 線索
  - 物品
  - 評價
  - 職業方向
  - 尚未處理完的遭遇

## 指令一覽

- `look`
- `status`
- `quest`
- `board`
- `actions`
- `take <number>`
- `do <keyword>`
- `advance`
- `turnin`
- `npcs`
- `services`
- `circuits`
- `move`
- `encounter`
- `respond <number>`
- `save`
- `help`
- `exit`

## 建議驗收流程

### 第一條任務完整跑通

1. 新遊戲
2. 從 `寂岩孤島` 開局
3. 用 `advance` 推進前兩步
4. `move` 到 `靜唱索岬`
5. 再用 `advance` 完成調查
6. `move` 回 `寂岩孤島`
7. `turnin` 領報酬

### 接第二條任務

1. 第一條結算後，`move` 到 `潮息海窟`
2. 輸入 `board`
3. 輸入 `take 1`
4. 再用 `quest` 確認第二條任務已掛上

### 第三條任務完整跑通

1. 新遊戲
2. 直接從 `靜唱索岬` 開局
3. 連續兩次 `advance`
4. `move` 到 `寂岩孤島`
5. 再 `advance`
6. `move` 回 `靜唱索岬`
7. `turnin`

### 遭遇分流驗收

1. 新遊戲後輸入 `encounter`
2. 確認畫面出現遭遇名稱與 3 個選項
3. 嘗試先 `move` 或 `take 1`
4. 確認系統會阻止，要求先 `respond <number>`
5. 輸入 `respond 1` 或其他選項
6. 再用 `status` 確認結果已寫回角色狀態

## 存檔位置

存檔會寫到：

`C:\Users\rabbi\Desktop\Elaris\text-game\05-prototypes\saves`

## 這版代表什麼

這版代表 `幽語海` 已經不是只有開場文本，而是有：

- 白身身份
- 落點差異
- 三條可完整跑通的 starter quest
- 任務推進、交付與結算
- 可接續下一條任務的區域循環
- 可獨立處理的單次遭遇分流

接下來就能沿著同一套結構，複製到其他區域，再逐步加深戰鬥、社交、撤退與長線事件。