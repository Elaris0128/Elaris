# 存檔格式 v1

這份文件描述 `Elaris 文字遊戲` 原型層的存檔骨架。它的目標是把玩家目前的角色、位置、任務、背包與世界互動結果穩定記下來，讓後續能做長線遊玩、跨場次續玩與多區域擴充。

目前 `幽語海 CLI 原型` 實際寫出的 `save_version` 已經是 `v7`，因為它比最初草稿多了 `runtime.active_encounter`，之後又再補進 `runtime.talked_npcs`、`runtime.day_job_log`、`relationships.npc_affinity`、`runtime.active_companion_npc_id`、`relationships.companion_supplies`、`relationships.companion_equipment`、`relationships.companion_growth`，以及後來追加的 `runtime.active_companion_npc_ids`、`runtime.focus_companion_npc_id`、`runtime.adventure_company_established`。這份文件保留在 `v1` 路徑下，但內容已經同步到目前原型的有效欄位。

## 設計原則

1. 一份存檔只對應一個玩家角色
2. 狀態欄位要夠明確，讓系統能直接續跑
3. 任務、線索、地區評價與職業方向必須可持續累積
4. NPC 好感必須是可追蹤、可續存的狀態
5. 尚未解決的遭遇也要被保存，不可在讀檔後消失

## 頂層欄位

- `save_version`
- `created_at`
- `updated_at`
- `playtime_minutes`
- `seed`
- `character`
- `location`
- `inventory`
- `relationships`
- `quests`
- `runtime`

## 欄位說明

### 1. 基本資訊

- `save_version`
  目前原型實作為 `v7`
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
- `inventory_slots`
- `containers`

目前原型還沒有完整容器、裝備欄與穿戴區，只先做最小可玩骨架：
- 現金
- 身上物資
- 基本容器

### 5. 任務 `quests`

- `active_quests`
- `completed_quests`
- `failed_quests`

`active_quests` 內每一條任務目前會記：
- `quest_id`
- `status`
- `step_index`
- `progress_log`
- `started_at`
- `completed_at`

`completed_quests` 內每條任務則會保留：
- `quest_id`
- `completed_at`
- `rewards`

### 6. 關係 `relationships`

- `npc_affinity`
- `companion_supplies`
- `companion_equipment`
- `companion_growth`

`npc_affinity` 目前是最小可玩版本的 NPC 好感表，格式為：

- `npc_id -> score`

目前分數主要由兩件事推高：
- 第一次正式搭話
- 完成任務並向對應 NPC 交付

這組分數目前會被顯示成：
- 陌生
- 點頭之交
- 願意搭話
- 開始信任
- 願意帶你
- 視作自己人

`companion_supplies` 則用來記錄：

- `npc_id -> 這位同行者目前代你保管的物資陣列`

目前規則是：
- 只有正在同行的 NPC 能替你保管物資
- 交付物資時，物資會先從玩家身上移到同行者手上
- 若同行者仍在隊上，`danger` 類遭遇裡會優先動用其中一份補給，替你額外穩一次局面
- 若你讓同行者離隊，這些物資不會自動交還，而是繼續留在對方身上

`companion_equipment` 則用來記錄：

- `npc_id -> { weapon, armor, accessory }`

目前規則是：
- 裝備欄位是 `weapon / armor / accessory`
- 只有正在同行的 NPC 能被你直接配置裝備
- 裝備一旦交給對方，就會先留在對方身上
- 若你讓同行者離隊，這些裝備不會自動回到玩家身上
- 若你之後再把同一位 NPC 招回來，對方仍會帶著原本那套裝備

`companion_growth` 則用來記錄：

- `npc_id -> { shared_steps, danger_supports, preferred_hits, unlocked_milestones }`

目前規則是：
- `shared_steps`
  代表你和這位同行者一起跑區、休整、累積路感的次數
- `danger_supports`
  代表你們一起扛過多少次真正的硬局
- `preferred_hits`
  代表你命中對方偏好補給或偏好裝備欄的次數
- `unlocked_milestones`
  代表這位同行者已經解鎖哪些同行成長里程碑

這組欄位現在會直接影響：
- `companion` 面板裡的成長線顯示
- `status` 裡同行者的目前階段
- `danger` 類遭遇中同行援手的強度

### 7. 執行狀態 `runtime`

- `active_encounter`
- `active_companion_npc_ids`
- `active_companion_npc_id`
- `focus_companion_npc_id`
- `adventure_company_established`
- `talked_npcs`
- `day_job_log`

這是目前從早期草稿一路升成 `v7` 的主要原因之一。

若 `active_encounter` 不為空，代表玩家眼前還有一個未解決的遭遇。這時系統應阻止：
- 移動
- 接新任務
- 推進任務
- 交付任務

`active_encounter` 目前至少會記：
- `type`
- `title`
- `text`
- `stage`
- `parent_title`
- `options`
- `source_path`

`active_companion_npc_ids` 用來記錄目前正式同行名單。現行規則是：
- 每個落點通常只有 `0-2 位` 真正願意同行的人
- 一般狀態下最多 `2 位正式同行`
- 若 `adventure_company_established = true`，代表地方已默認你們是一支小型冒險團，上限提高到 `3 位`
- 不是每位 NPC 都可同行
- 只有少數具備 `同行欄位` 的人物，在好感達標後才能被邀請

`focus_companion_npc_id` 用來記錄：
- 目前被視為 `主同行` 的是哪一位
- `companion / gear / supplies` 這些細部指令會優先看這個人

`active_companion_npc_id` 現在保留為相容欄位：
- 會同步等於 `focus_companion_npc_id`
- 舊存檔只有單一同行欄時，讀檔會自動轉成新格式

`talked_npcs` 用來記玩家在這一輪生涯裡已經和哪些關鍵人物正式搭過話，避免首次獎勵重複發放。

`day_job_log` 用來限制白身短工：
- 同一個 `job_id`
- 在同一個 `day_count`
- 只會完整結算一次

## JSON 範例

```json
{
  "save_version": "v7",
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
    "traits": [],
    "flaws": [],
    "background": "白身開局"
  },
  "location": {
    "current_region_id": "whispersea",
    "current_scene_id": "tidesigh-sea-cave",
    "time_of_day": "night",
    "day_count": 3
  },
  "inventory": {
    "currency": 34,
    "inventory_slots": [
      "潮骨舊誓片",
      "海霧照明燈"
    ],
    "containers": [
      "潮布肩包"
    ]
  },
  "quests": {
    "active_quests": [
      {
        "quest_id": "whispersea-quest-02",
        "status": "active",
        "step_index": 1,
        "progress_log": [
          "描記潮泡列"
        ],
        "started_at": "2026-04-05T20:32:00+08:00",
        "completed_at": null
      }
    ],
    "completed_quests": [
      {
        "quest_id": "whispersea-quest-01",
        "completed_at": "2026-04-05T21:48:00+08:00",
        "rewards": {
          "currency": 18,
          "items": [
            "潮骨舊誓片",
            "薄霧燈罩"
          ],
          "reputation_track": "whispersea-local",
          "reputation_delta": 1,
          "job_directions": [
            "潮路見習",
            "引水見習"
          ]
        }
      }
    ],
    "failed_quests": []
  },
  "notebook": {
    "known_clues": [
      "潮骨舊誓與鐘線偏差有關"
    ],
    "revealed_truths": []
  },
  "reputation": {
    "region": "neutral",
    "factions": {},
    "tracks": {
      "whispersea-local": 1
    }
  },
  "relationships": {
    "npc_affinity": {
      "character-whispersea-chaoguheng": 3,
      "character-whispersea-fanchaoshu": 2
    },
    "companion_supplies": {
      "character-whispersea-chaoguheng": [
        "備索卷"
      ]
    },
    "companion_equipment": {
      "character-whispersea-chaoguheng": {
        "weapon": "封聲袋",
        "armor": null,
        "accessory": "潮骨刻片"
      }
    },
    "companion_growth": {
      "character-whispersea-chaoguheng": {
        "shared_steps": 3,
        "danger_supports": 2,
        "preferred_hits": 2,
        "unlocked_milestones": [
          "nearshore-rhythm",
          "held-the-line",
          "oath-supplies"
        ]
      }
    }
  },
  "runtime": {
    "current_pressure_tags": [
      "wrong-route",
      "dive-risk"
    ],
    "linked_npcs": [
      "character-whispersea-fanchaoshu",
      "character-whispersea-wuduocen"
    ],
    "save_name": "無名見習-whispersea-save.json",
    "learned_job_directions": [
      "引水見習",
      "照護幫手"
    ],
    "active_encounter": null,
    "active_companion_npc_ids": [
      "character-whispersea-chaoguheng",
      "character-whispersea-wuduocen"
    ],
    "active_companion_npc_id": "character-whispersea-chaoguheng",
    "focus_companion_npc_id": "character-whispersea-chaoguheng",
    "adventure_company_established": true,
    "talked_npcs": [
      "character-whispersea-chaoguheng"
    ],
    "day_job_log": [
      "day1:shore-oath-run"
    ]
  }
}
```

## 擴充方向

之後若要把 `幽語海` 從單區原型擴成長團骨架，最自然會新增：

- 區域任務板冷卻與刷新
- 長行動進度條
- 傷勢、狀態與恢復計時
- 跨區移動與世界時鐘

## 對照文件

- [執行狀態模型](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/runtime-state-model.md)
- [指令循環與場景流程](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/command-loop-and-scene-flow.md)
- [幽語海 CLI 原型說明](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.md)


