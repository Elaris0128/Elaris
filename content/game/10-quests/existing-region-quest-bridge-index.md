# 既有地區任務橋接索引

這份索引的目的，不是重寫世界觀裡既有的任務，而是把 `content/scenarios` 裡已經存在的任務、地區包、開局模板，整理成玩家與 AI 都能直接調用的橋接層。

目前原則已統一為：
`所有可玩起始區，都視為 A 級可開局。`

差別不再是「能不能玩」，而是 `AI 取材來源` 不同：
- `A1`：有完整獨立任務池，可直接抽既有任務檔。
- `A2`：有完整地區包，可直接讀地區 starter 與 questlines 形成起始任務群。
- `A3`：暫時沒有獨立任務池，但已有完整開局模板，可直接作為 A 級可開局來源。

## A 級三型說明

### A1：獨立任務池直抽型
適用於已經存在大量 `*-quest-XX.md` 的區域。

AI 使用方式：
1. 先鎖定起始區域。
2. 直接讀該區域的 quest 檔前段編號。
3. 先抽 1 個主要委託，再補 1 個次問題或地方麻煩。
4. 依玩家行動，再延伸到同區下一批 quest。

### A2：地區包直讀型
適用於已有完整 region package、starter docs、questlines 或 quest-details 的區域。

AI 使用方式：
1. 先讀 `starter-overview.md`。
2. 再讀 `starter-quests.md` 或 `questlines.md`。
3. 取其中最適合新角色的 2 至 3 條任務線作為開局候選。
4. 將其改寫成玩家第一章可直接接觸的委託或事故。

### A3：模板直開型
適用於世界觀完整、文化與區域味道明確，但暫時沒有拆出完整任務池的區域。

AI 使用方式：
1. 套用地區專屬開局包。
2. 先抽第一壓力、第一目標、第一互動對象。
3. 再用既有世界觀地點、人脈、職業與流動人物模板，臨時生成第一批任務。
4. 只要能直接開局並穩定延伸，即視為 A 級可用。

## A1：有完整獨立任務池的起始區

| 起始區 | 任務前綴 | 任務量 | 主要讀取來源 | 備註 |
| --- | --- | ---: | --- | --- |
| 幽語海 | `whispersea-quest-*` | 16 | `whispersea` | 諾魯因人主起始區 |
| 靈穹洋 | `spiritvault-ocean-quest-*` | 36 | `spiritvault-ocean` | 冒險者公會與航權線 |
| 焰潮洋 | `embersurge-ocean-quest-*` | 20 | `embersurge-ocean` | 海人與南渦外洋線 |
| 霧羽列島 | `fogfeather-isles-quest-*` | 24 | `fogfeather-isles` | 藥師公會總部線 |
| 星盞群島 | `starlantern-isles-quest-*` | 43 | `starlantern-isles` | 外來遠征與古文明線 |
| 天冠洋極地邊海 | `heavencrown-ocean-quest-*` | 20 | `heavencrown-ocean` | 極地冰海與冰陸探索 |
| 亡極徹淵 | `abyss-quest-*` | 12 | `abyss` | 魔人深層起始圈 |

### A1：可作背景例外起始的完整任務池
這些區域不一定是種族預設出生地，但作為例外出身、流亡、遠征、跨區成員開局時，依然視為 A1 可直接抽任務。

| 區域 | 任務前綴 | 任務量 | 主要讀取來源 |
| --- | --- | ---: | --- |
| 奧崙群星帶 | `aolun-starbelt-quest-*` | 28 | `aolun-starbelt` |
| 曦環浮境 | `xihuan-floating-quest-*` | 28 | `xihuan-floating` |
| 晨穗群島 | `morning-isles-quest-*` | 24 | `morning-isles` |
| 潮牢列島 | `tide-prison-isles-quest-*` | 28 | `tide-prison-isles` |
| 黯鉚列島 | `dark-anchor-isles-quest-*` | 30 | `dark-anchor-isles` |
| 暮牙海 | `duskfang-sea-quest-*` | 29 | `duskfang-sea` |
| 殞星海 | `meteorfall-sea-quest-*` | 20 | `meteorfall-sea` |
| 天脈島弧 | `tianmai-isle-arc-quest-*` | 28 | `tianmai-isle-arc` |
| 世界流動人物線 | `world-wanderers-quest-*` | 12 | `world-wanderers` |

## A2：地區包直讀即可開局的區域

這些區域目前不一定已拆成大批獨立 quest 檔，但已有完整 starter docs、questlines、quest-details 或 region package，可以穩定生成開局任務。

### 人類與王國主圈

| 區域 ID | 對應地區 | 使用方式 |
| --- | --- | --- |
| `avalon` | 阿瓦隆王國 | 讀 `starter-overview -> starter-quests -> questlines` |
| `therne` | 瑟恩聯邦國 | 同上 |
| `mujing` | 暮鏡荒境 | 同上 |
| `durocral` | 杜羅山邦 | 同上 |
| `duromok` | 杜魯摩克隱域 | 同上 |
| `sadren` | 薩德原遷營 | 同上 |
| `nieesi` | 涅厄斯魔人國 | 同上 |
| `seteia` | 瑟堤亞棲國 | 同上 |
| `skyrend-roost` | 雲裂哨站 | 同上 |

### 精靈主圈

| 區域 ID | 對應地區 |
| --- | --- |
| `yunselin` | 雲瑟林域 |
| `xuehua` | 雪華部族地 |
| `shranolan` | 霜諾嵐寒域 |
| `milanyu` | 蜜蘭羽域 |
| `olorase` | 奧羅拉瑟葉庭 |
| `aulifan` | 奧里梵古林 |
| `filune` | 菲露涅月境 |
| `vithare` | 維塔雷林界 |
| `thertalyn` | 瑟塔嶺林群 |
| `jianying-yinlin` | 繭影隱林 |

### 獸人與文化支系主圈

| 區域 ID | 對應地區 |
| --- | --- |
| `krolarn` | 克羅嵐共誓域 |
| `xiaoyang` | 魈陽族山陵圈 |
| `yanqiong-triad` | 巖穹三聯域 |
| `lormeer` | 洛爾彌荒坡 |
| `perlin` | 裴林草脊 |
| `xingwen-road` | 星紋道群 |
| `nanying-belt` | 南影帶 |
| `cangyuan-luodan` | 蒼原落丹圈 |

## A3：模板直開但仍視為 A 級的區域

這些區域目前主要依靠玩家／AI 開局包、既有地區文化、職業模板、流動人物和地點資料來生成第一批任務。

| 區域 | 目前主要來源 |
| --- | --- |
| 港邊航務圈 | 港務、商會、航權、失蹤、查驗衝突模板 |
| 法雷恩沿海諸港 | 沿海港埠、人情債、貨務、海航事故模板 |
| 葉脈樹海圈 | 樹海巡守、採樣、失蹤、潔淨禁線模板 |
| 萬嶺幽陵山陵圈 | 山陵採收、家族糾紛、護送、祖物模板 |
| 多數獸人邊支地 | 氏族遷徙、獵窗、祭期、守域衝突模板 |
| 森馳裔邊林圈 | 林路、遠遞、守林、幽徑事故模板 |

## AI 讀取優先順序

1. `A1`：先讀 quest 檔，直接抽現成任務。
2. `A2`：先讀 starter docs，再整理出任務候選。
3. `A3`：先套地區開局包，再用文化與職業模板補成任務。

## 維護規則

- 有獨立 quest 檔出現時，優先從 `A3 -> A2 -> A1` 升級，不降級。
- 地區任務橋接層永遠指向 `既有內容`，不重複書寫第二份世界觀任務。
- 玩家層與 AI 層只負責「選、抽、排序、轉譯」，不取代原始任務檔。

## 參照檔
- [開局任務推薦矩陣](C:/Users/rabbi/Desktop/Elaris/content/game/10-quests/player-opening-quest-recommendation-matrix.md)
- [玩家起始區域與開局包對照表](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/player-start-region-and-opening-pack-matrix.md)
- [AI 開局任務抽取指南](C:/Users/rabbi/Desktop/Elaris/content/game/12-ai-play/ai-opening-quest-draw-guide.md)