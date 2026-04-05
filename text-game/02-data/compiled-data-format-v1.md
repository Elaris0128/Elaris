# 編譯資料格式 v1

這份文件定義 `Elaris 文字遊戲` 的資料編譯層。它的作用不是取代原始世界觀檔，而是把 `content/world`、`content/game`、`content/scenarios` 裡的資料整理成遊戲執行時能直接讀取的結構。

簡單說：
- 世界觀原檔是正典來源
- 編譯資料是遊戲執行層用的輸入格式

## 設計原則

1. 每份編譯資料都要能回扣正典
2. 遊戲執行時不要再依賴大量散落 Markdown 即時拼裝
3. 同一種結構要能複製到不同區域
4. 每份包都要保留 `source_paths`

## 目前主要包類型

### 1. Region Pack

區域包是目前第一版原型最核心的資料單位。

它負責提供：
- 起始落點
- 地區路線迴路
- starter quest 池
- 遭遇種子
- NPC 鉤子
- 白身開局身分建議

### 2. Quest Pack

任務包之後可獨立拆大，但在目前第一版裡，starter quest 先內嵌在 region pack。

### 3. NPC Hook Pack

NPC Hook 不是完整人物卡，而是原型層用來：
- 引導玩家認識誰
- 知道誰可以交付任務
- 知道誰和某條任務線有關

### 4. Encounter Pack

遭遇包目前先用 `encounter_seeds + 預設 profiles` 的組合實作。之後若做深，會拆成獨立遭遇資料檔。

## Region Pack v1 骨架

```json
{
  "pack_version": "v1",
  "kind": "region-pack",
  "region_id": "whispersea",
  "display_name": "幽語海",
  "source_mode": "A1",
  "opening_mode": "blank-slate-first",
  "recommended_for": [],
  "learning_curve": [],
  "service_tags": [],
  "runtime_tags": [],
  "start_points": [],
  "location_circuits": [],
  "starter_quest_pool": [],
  "encounter_seeds": [],
  "npc_hooks": [],
  "blank_slate_roles": [],
  "source_paths": []
}
```

## Region Pack 欄位說明

### `pack_version`
資料格式版本。

### `kind`
目前固定為 `region-pack`。

### `region_id`
區域唯一識別，例如 `whispersea`。

### `display_name`
玩家介面顯示名稱。

### `source_mode`
對應你前面做好的 A 級橋接邏輯，例如 `A1 / A2 / A3`。

### `opening_mode`
目前第一版先採：
- `blank-slate-first`

### `recommended_for`
這區域適合哪種玩家風格。

### `learning_curve`
玩家在這區最容易先學到什麼。

### `service_tags`
可快速標出：
- 補給
- 修繕
- 路線資訊
- 任務交付

### `runtime_tags`
執行時可能有用的環境標記，例如：
- `fog`
- `ritual-law`
- `grayline`
- `deep-dive`

### `start_points`
每個起始落點都應包含：
- `id`
- `name`
- `why_start_here`
- `pressure_tags`
- `recommended_first_quest`
- `linked_npcs`
- `source_paths`

### `location_circuits`
區域內可供玩家理解的移動回路。

### `starter_quest_pool`
每條 starter quest 目前至少要有：
- `quest_id`
- `title`
- `entry_point_id`
- `arc`
- `chapter_tier`
- `core_conflict`
- `key_npcs`
- `decision`
- `progress`
- `source_paths`

其中 `progress` 內再拆：
- `steps`
- `completion`

### `encounter_seeds`
遭遇種子是目前第一版讓區域有動態感的最低骨架。它們會和程式內建的 encounter profiles 對接。

### `npc_hooks`
目前每個 hook 至少有：
- `id`
- `name`
- `role`
- `intro_use`
- `source_paths`

### `blank_slate_roles`
對應這區域最常見的白身起點，例如：
- 跟行者
- 見習
- 短工

### `source_paths`
列出整個 region pack 回扣了哪些正典來源。

## 幽語海目前已驗證的結構

[whispersea-region-pack-v1.json](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/regions/whispersea-region-pack-v1.json) 目前已經能穩定供應：

- 3 個起始落點
- 4 條地方迴路
- 3 條可完整跑通的 starter quest
- 5 種遭遇種子
- 5 個 NPC 鉤子
- 3 種白身身分建議

## 之後如何複製到其他區域

當你要做第二個區域時，最穩的做法是：

1. 先挑一個區域主檔
2. 抽出起始落點 / 路線 / 任務 / NPC / 遭遇
3. 裝進同一份 region pack 骨架
4. 保留 `source_paths`
5. 再讓 CLI 或其他執行層讀這份包

這樣之後像 `焰潮洋`、`暮鏡荒境`、`港邊航務圈` 都能沿用同一套結構擴張。

## 對照文件

- [資料層規劃](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/data-layer-plan.md)
- [第一版可玩切片](/C:/Users/rabbi/Desktop/Elaris/text-game/01-design/first-playable-slice.md)
- [存檔格式 v1](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/save-format-v1.md)
- [幽語海 CLI 原型說明](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.md)