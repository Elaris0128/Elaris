# Elaris 文字遊戲框架

這裡放的是 `Elaris` 電腦文字遊戲本體的設計、資料格式、執行狀態、AI 護欄、原型，以及之後要擴成完整遊戲的框架層。

它和 [content/game](/C:/Users/rabbi/Desktop/Elaris/content/game/README.md) 的分工是：

- `content/game`
  這裡是玩家規則、卡庫、橋接資料與世界內可玩的原始內容
- `text-game`
  這裡是把那些內容變成「真的能執行」的遊戲骨架、資料格式、狀態模型、原型與框架程式

## 目前結構

- `01-design`
  遊戲範圍、核心迴圈、第一版可玩切片
- `02-data`
  把 `content/game` / `content/world` / `content/scenarios` 編成遊戲可讀資料的格式
- `03-runtime`
  存檔、狀態、回合流程與場景循環
- `04-ai`
  AI 敘事與護欄原則
- `05-prototypes`
  單區原型、CLI 驗證與可玩的切片
- `06-framework`
  整個文字遊戲的正式入口、區域註冊表與可擴充模組骨架
- `07-ui-shell`
  一般遊戲畫面風格的 UI 原型，先把按鈕、面板與 HUD 骨架定下來

## 目前狀態

目前最完整的可玩區域是：

- [幽語海 CLI 原型說明](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.md)
- [幽語海 CLI 原型腳本](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.ps1)
- [幽語海 region pack v1](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/regions/whispersea-region-pack-v1.json)

而整個遊戲框架的入口則是：

- [遊戲啟動器](/C:/Users/rabbi/Desktop/Elaris/text-game/play-elaris.ps1)
- [框架總覽](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/framework-overview.md)
- [框架說明](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/README.md)
- [切片註冊表](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/config/slices.registry.json)
- [遊戲畫面 UI 原型](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/README.md)

## 框架方向

這套文字遊戲目前採用：

- `資料固定`
  世界觀、任務、NPC、物品、地區、職業與遭遇都有明確來源
- `規則固定`
  狀態、任務推進、好感、同行、存檔、區域循環與成長是可驗證的
- `敘事可延展`
  之後可接 AI 或模板敘事，但不允許改動正典事實

也就是說，目標不是做成「全靠 AI 即興」的作品，而是：

`一個世界與規則穩定、敘事自由度高的文字遊戲`

## 啟動方式

若你要從整個遊戲框架入口進去，而不是直接跑單一 prototype，可用：

```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\rabbi\Desktop\Elaris\text-game\play-elaris.ps1"
```

目前這個入口會先帶你進框架層，再選要進哪個可玩切片。

現在主框架選單也已經支援：

- `查看框架狀態`
- `查看存檔總覽`

如果你不想手打指令，現在可以直接在資料夾裡雙擊：

- [啟動-Elaris-文字遊戲框架.bat](/C:/Users/rabbi/Desktop/Elaris/text-game/啟動-Elaris-文字遊戲框架.bat)
  進入整個文字遊戲框架入口
- [啟動-Elaris-遊戲畫面原型.bat](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/啟動-Elaris-遊戲畫面原型.bat)
  直接打開一般遊戲畫面風格的 UI 原型

## 目前最重要的文件

- [遊戲範圍與核心迴圈](/C:/Users/rabbi/Desktop/Elaris/text-game/01-design/game-scope-and-core-loop.md)
- [第一版可玩切片](/C:/Users/rabbi/Desktop/Elaris/text-game/01-design/first-playable-slice.md)
- [資料層規劃](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/data-layer-plan.md)
- [編譯資料格式 v1](/C:/Users/rabbi/Desktop/Elaris/text-game/02-data/compiled-data-format-v1.md)
- [執行狀態模型](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/runtime-state-model.md)
- [指令循環與場景流程](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/command-loop-and-scene-flow.md)
- [存檔格式 v1](/C:/Users/rabbi/Desktop/Elaris/text-game/03-runtime/save-format-v1.md)
- [AI 敘事與護欄](/C:/Users/rabbi/Desktop/Elaris/text-game/04-ai/ai-narration-and-guardrails.md)
- [原型區索引](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/README.md)
- [框架總覽](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/framework-overview.md)

## 下一步最自然的擴充

- 把 `幽語海` 的互動再往更長線的區域生活推進
- 讓 `06-framework` 變成多區域共用的主框架，而不只是啟動器
- 做第二個區域包，驗證跨區複用
- 再往後接成真正的 `長團 / 世界時鐘 / 跨區存檔`


