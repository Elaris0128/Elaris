# Elaris 電腦文字遊戲層

這個資料夾是給 `電腦文字遊戲版本` 用的。

它和 `content/game` 的分工是：

- `content/game`
  放世界規則、玩家卡、職業、物品、戰鬥、成長、任務、開局規則等 `原始規則資料`
- `text-game`
  放真正要把這些規則跑起來的 `執行層`

也就是說：

- `content/game` 是 `世界與規則資料庫`
- `text-game` 是 `遊戲系統與運行框架`

## 為什麼要分開

如果不分開，之後很容易把：
- 世界觀原稿
- 玩家規則
- AI 主持提示
- 遊戲執行狀態
- 存檔
- 編譯後資料

全部混在一起。

一旦要改系統、換 UI、換存檔格式，會很痛苦。

## 目前建議的結構

- `01-design`
  放這款遊戲到底怎麼玩的設計稿
- `02-data`
  放從 `content/game`、`content/world` 整理過來給遊戲用的資料層
- `03-runtime`
  放狀態、存檔、世界時鐘、任務進度等執行中資料模型
- `04-ai`
  放 AI 主持、敘事、查證、護欄規則
- `05-prototypes`
  放日後你要做的 CLI、網頁版、桌面版原型

## 建議工作流

1. 先在 `content/game` 與 `content/world` 繼續養資料
2. 再把真正需要執行的資料整理進 `text-game/02-data`
3. 把遊戲流程、狀態、回合、任務、世界反應整理進 `03-runtime`
4. 最後再做實際介面或程式原型

## 現階段最重要的事

先把以下幾件事定清楚：

1. 遊戲的最小核心迴圈
2. 什麼資料直接讀原始檔，什麼資料要編譯成遊戲用格式
3. AI 主持可以自由發揮到哪裡，哪裡只能照資料走
4. 存檔至少要記哪些欄位

## 現在已經補好的第一版規格

- [遊戲範圍與核心迴圈](C:/Users/rabbi/Desktop/Elaris/text-game/01-design/game-scope-and-core-loop.md)
- [第一版可玩切片](C:/Users/rabbi/Desktop/Elaris/text-game/01-design/first-playable-slice.md)
- [資料層規劃](C:/Users/rabbi/Desktop/Elaris/text-game/02-data/data-layer-plan.md)
- [執行狀態模型](C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/runtime-state-model.md)
- [指令循環與場景流程](C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/command-loop-and-scene-flow.md)
- [存檔格式 v1](C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/save-format-v1.md)
- [AI 敘事與護欄](C:/Users/rabbi/Desktop/Elaris/text-game/04-ai/ai-narration-and-guardrails.md)
- [原型區](C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/README.md)

## 建議下一步

如果要繼續往下做，最順的順序會是：
1. 先把 `一個起始區域` 的場景、任務、NPC 編譯成遊戲資料
2. 再做 `CLI 單區原型`
3. 接著把 `存檔 / 讀檔` 跑通
4. 最後才接 AI 敘事層

## 對應入口

- [遊戲規則總索引](C:/Users/rabbi/Desktop/Elaris/content/game/README.md)
- [玩家快速上手套件](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/README.md)
- [玩家白身開局與後定職模式](C:/Users/rabbi/Desktop/Elaris/content/game/00-player-kit/player-blank-slate-opening-mode.md)
