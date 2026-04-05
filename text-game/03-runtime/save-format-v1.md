# 存檔格式 v1

這份文件描述 `Elaris 文字遊戲` 原型層的存檔骨架。它的目標是把玩家目前的角色、位置、任務、背包與世界互動結果穩定記下來，讓後續能做長線遊玩、跨場次續玩與多區域擴充。

目前 `幽語海 CLI 原型` 實際寫出的 `save_version` 已經是 `v2`，因為它比最初草稿多了 `runtime.active_encounter`。這份文件保留在 `v1` 路徑下，但內容已經同步到目前原型的有效欄位。

## 設計原則

1. 一份存檔只對應一個玩家角色
2. 狀態欄位要夠明確，讓系統能直接續跑
3. 任務、線索、地區評價與職業方向必須可持續累積
4. 尚未解決的遭遇也要被保存，不可在讀檔後消失

## 頂層欄位

- `save_version`
- `created_at`
- `updated_at`
- `playtime_minutes`
- `seed`
- `character`
- `location`
- `inventory`
- `quests`
- `runtime`

## 欄位說明

### 1. 基本資訊

- `save_version`
  目前原型實作為 `v2`
- `created_at`
- `updated_at`
- `playtime_minutes`
- `seed`
  用來讓區域事件、遭遇與流程具可重現性

### 2. 角色 `character`

- `name`
- `race`
- `branch`
- `origin_region`
- `blank_slate_status`
- `job_direction_primary`
- `job_direction_secondary`
- `clues`
- `reputation_tracks`

目前原型聚焦在 `白身開局 -> 慢慢長出職業方向`，所以正式職業欄位還沒有完全拆成獨立卡槽，而是先以 `job_direction_*` 表示角色已經偏向哪種生活路線。

### 3. 位置 `location`

- `current_region_id`
- `current_scene_id`
- `time_of_day`
- `day_count`

這組欄位用來控制：
- 你現在在哪個區域
- 你站在哪個落點
- 當前是白晝還是夜間
- 已經過了多少天

### 4. 背包 `inventory`

- `currency`
- `items`

目前原型還沒有完整容器、裝備欄與穿戴區，只先做最小可玩骨架：
- 現金
- 物品清單

### 5. 任務 `quests`

- `active`
- `completed`

`active` 內每一條任務會記：
- `quest_id`
- `title`
- `current_step_index`
- `step_count`
- `ready_to_turn_in`
- `turn_in_location_id`
- `turn_in_npc_id`
- `source_paths`

`completed` 內每條任務則會保留：
- `quest_id`
- `title`
- `completed_at`
- `reward_summary`

### 6. 執行狀態 `runtime`

- `active_encounter`

這是目前從早期草稿升成 `v2` 的主要原因。

若 `active_encounter` 不為空，代表玩家眼前還有一個未解決的遭遇。這時系統應阻止：
- 移動
- 接新任務
- 推進任務
- 交付任務

`active_encounter` 目前至少會記：
- `type`
- `title`
- `text`
- `options`
- `source_path`

## JSON 範例

```json
{
  "save_version": "v2",
  "created_at": "2026-04-05T20:00:00+08:00",
  "updated_at": "2026-04-05T22:10:00+08:00",
  "playtime_minutes": 95,
  "seed": "whispersea-a01",
  "character": {
    "name": "無名見習",
    "race": "諾魯因人",
    "branch": null,
    "origin_region": "whispersea",
    "blank_slate_status": "見習",
    "job_direction_primary": "引水見習",
    "job_direction_secondary": "照護幫手",
    "clues": [
      "潮骨舊誓與鐘線偏差有關"
    ],
    "reputation_tracks": {
      "whispersea-local": 1
    }
  },
  "location": {
    "current_region_id": "whispersea",
    "current_scene_id": "tidesigh-sea-cave",
    "time_of_day": "night",
    "day_count": 3
  },
  "inventory": {
    "currency": 34,
    "items": [
      "潮骨舊誓片",
      "海霧照明燈"
    ]
  },
  "quests": {
    "active": [
      {
        "quest_id": "whispersea-quest-02",
        "title": "潮息海窟的錯返潛路",
        "current_step_index": 1,
        "step_count": 3,
        "ready_to_turn_in": false,
        "turn_in_location_id": "tidesigh-sea-cave",
        "turn_in_npc_id": "character-whispersea-wuduocen",
        "source_paths": [
          "content/scenarios/quests/whispersea-quest-02.md"
        ]
      }
    ],
    "completed": [
      {
        "quest_id": "whispersea-quest-01",
        "title": "寂岩孤島的潮骨舊誓",
        "completed_at": "2026-04-05T21:48:00+08:00",
        "reward_summary": {
          "currency": 18,
          "reputation_track": "whispersea-local",
          "reputation_delta": 1,
          "job_directions": [
            "潮路見習",
            "引水見習"
          ]
        }
      }
    ]
  },
  "runtime": {
    "active_encounter": null
  }
}
```

## 擴充方向

之後若要把 `幽語海` 從單區原型擴成長團骨架，最自然會新增：

- NPC 關係狀態
- 區域任務板冷卻與刷新
- 長行動進度條
- 傷勢、狀態與恢復計時
- 跨區移動與世界時鐘

## 對照文件

- [執行狀態模型](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/runtime-state-model.md)
- [指令循環與場景流程](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/command-loop-and-scene-flow.md)
- [幽語海 CLI 原型說明](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.md)