# 資料層規劃

## 分層原則

電腦文字遊戲不應直接把所有原始 Markdown 當執行資料。

應分成兩層：

### 1. 原始資料層
來源：
- `content/world`
- `content/game`
- `content/scenarios`

用途：
- 維持正典
- 持續編修
- 給 AI 查證與閱讀

### 2. 遊戲執行資料層
位置：
- `text-game/02-data`

用途：
- 給遊戲程式快速讀取
- 給 AI 主持抓關鍵狀態
- 給任務、地區、NPC、物品、魔物做結構化引用

## 哪些資料建議編譯

最值得先整理成遊戲資料格式的有：

1. 種族 / 分支
2. 起始區域對照
3. 開局包
4. 任務索引
5. 職業方向
6. 種族能力 / 分支能力
7. 狀態 / 傷勢 / 恢復
8. 聲望 / 執照 / 稱號
9. 常見商店 / 消耗品 / 裝備包
10. 魔物遭遇卡

## 哪些資料先保留原始查證

以下先不急著完全編譯：

- 大篇幅歷史
- 詳細文化敘述
- 長篇人物傳記
- 海量物品條目全文

這些更適合在需要時由 AI 透過查證層讀取。

## 第一版已落下的資料格式

- [編譯資料格式 v1](C:/Users/rabbi/Desktop/Elaris/text-game/02-data/compiled-data-format-v1.md)
- [Region Packs](C:/Users/rabbi/Desktop/Elaris/text-game/02-data/regions/README.md)
- [幽語海 region pack v1](C:/Users/rabbi/Desktop/Elaris/text-game/02-data/regions/whispersea-region-pack-v1.json)

## 建議編譯順序
1. 先做 `幽語海`
2. 再做 `港邊航務圈`
3. 再做第二個完整起始區
