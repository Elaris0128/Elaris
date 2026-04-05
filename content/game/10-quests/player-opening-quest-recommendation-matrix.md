# 開局任務推薦矩陣

這份矩陣給玩家與 AI 共用，目的不是重做任務，而是告訴你：
`選到某個起始區後，第一批最適合抽哪些既有任務或任務來源。`

目前所有可玩起始區，統一視為 `A 級可開局`。
差別只在來源模式：
- `A1`：直接抽獨立 quest 檔。
- `A2`：直接讀 starter / questlines。
- `A3`：直接用開局模板產生任務。

## A1：獨立任務池直抽型

| 起始區 | 任務前綴 | 任務量 | 首抽區間 | 第二波區間 | 高風險區間 |
| --- | --- | ---: | --- | --- | --- |
| 幽語海 | `whispersea-quest-*` | 16 | `01-02` | `03-04` | `05-08` |
| 靈穹洋 | `spiritvault-ocean-quest-*` | 36 | `01-03` | `04-06` | `07-12` |
| 焰潮洋 | `embersurge-ocean-quest-*` | 20 | `01-02` | `03-05` | `06-10` |
| 霧羽列島 | `fogfeather-isles-quest-*` | 24 | `01-02` | `03-05` | `06-10` |
| 星盞群島 | `starlantern-isles-quest-*` | 43 | `01-03` | `04-06` | `07-16` |
| 天冠洋極地邊海 | `heavencrown-ocean-quest-*` | 20 | `01-02` | `03-04` | `05-10` |
| 亡極徹淵 | `abyss-quest-*` | 12 | `01-02` | `03-04` | `05-08` |

### A1：背景例外起始也可直抽

| 區域 | 任務前綴 | 任務量 | 推薦首抽 |
| --- | --- | ---: | --- |
| 奧崙群星帶 | `aolun-starbelt-quest-*` | 28 | `01-04` |
| 曦環浮境 | `xihuan-floating-quest-*` | 28 | `01-04` |
| 晨穗群島 | `morning-isles-quest-*` | 24 | `01-04` |
| 潮牢列島 | `tide-prison-isles-quest-*` | 28 | `01-04` |
| 黯鉚列島 | `dark-anchor-isles-quest-*` | 30 | `01-04` |
| 暮牙海 | `duskfang-sea-quest-*` | 29 | `01-04` |
| 殞星海 | `meteorfall-sea-quest-*` | 20 | `01-04` |
| 天脈島弧 | `tianmai-isle-arc-quest-*` | 28 | `01-04` |
| 世界流動人物線 | `world-wanderers-quest-*` | 12 | `01-03` |

## A2：地區包直讀型推薦

| 起始區 | 區域 ID | 建議首批任務數 | AI 使用方式 |
| --- | --- | ---: | --- |
| 阿瓦隆王國 | `avalon` | 2-3 | `starter-overview -> starter-quests -> questlines` |
| 瑟恩聯邦國 | `therne` | 2-3 | 同上 |
| 暮鏡荒境 | `mujing` | 2 | 同上 |
| 杜羅山邦 | `durocral` | 2 | 同上 |
| 杜魯摩克隱域 | `duromok` | 2 | 同上 |
| 薩德原遷營 | `sadren` | 2 | 同上 |
| 涅厄斯魔人國 | `nieesi` | 2-3 | 同上 |
| 瑟堤亞棲國 / 雲裂哨站 | `seteia / skyrend-roost` | 2 | 同上 |
| 任一精靈主域 | 對應精靈 region package | 2 | 讀該域 starter docs |
| 克羅嵐 / 魈陽 / 巖穹三聯域 | `krolarn / xiaoyang / yanqiong-triad` | 2 | 讀該域 starter docs |

## A3：模板直開型推薦

| 起始區 | 建議首批配置 |
| --- | --- |
| 港邊航務圈 | `1 委託 + 1 港務衝突 + 1 地方麻煩` |
| 法雷恩沿海諸港 | `1 港邊委託 + 1 海上事故 + 1 人情債` |
| 葉脈樹海圈 | `1 巡守委託 + 1 失蹤線索 + 1 禁區壓力` |
| 萬嶺幽陵山陵圈 | `1 採收/護送委託 + 1 家族糾紛 + 1 祖物問題` |
| 多數獸人邊支地 | `1 氏族任務 + 1 獵窗壓力 + 1 外來干擾` |
| 森馳裔邊林圈 | `1 林路護送 + 1 邊林事故 + 1 守林選擇` |

## 推薦首抽節奏

### 新手安全節奏
- 第 1 抽：地方委託或可立即理解的麻煩
- 第 2 抽：人際糾紛、失蹤、查驗、追蹤
- 第 3 抽：灰線誘惑、封樣問題、護送或戰鬥壓力

### 標準開局節奏
- 1 個主要任務
- 1 個次問題
- 1 個地區味道事件

### 高風險開局節奏
- 1 個高報酬任務
- 1 個反噬性問題
- 1 個牽扯勢力或世界時鐘的副壓力

## 玩家如何使用

如果你不想管系統細節，只要記住：
- `A1`：直接選任務。
- `A2`：先看地區 starter 檔，再選任務方向。
- `A3`：先用地區開局包，再讓 AI 組第一批委託。

## 參照檔
- [既有地區任務橋接索引](C:/Users/rabbi/Desktop/Elaris/content/game/10-quests/existing-region-quest-bridge-index.md)
- [AI 開局任務抽取指南](C:/Users/rabbi/Desktop/Elaris/content/game/12-ai-play/ai-opening-quest-draw-guide.md)
- [玩家地區專屬開局包](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/regional-opening-pack-library.md)