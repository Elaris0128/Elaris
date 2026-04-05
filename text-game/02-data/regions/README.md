# Region Packs

這裡放的是 `給遊戲程式讀取的地區資料包`。

和 `content/scenarios/regions/...` 的差別是：
- `content/scenarios/regions`
  放原始地區內容、任務線、開局導覽與世界觀細節
- `text-game/02-data/regions`
  放整理過、可直接被遊戲拿來開局與執行的資料包

## 第一版建議格式
- 以 `*-region-pack-v1.json` 為主
- 每包都保留 `source_paths`

## 目前已做
- [幽語海 region pack v1](C:/Users/rabbi/Desktop/Elaris/text-game/02-data/regions/whispersea-region-pack-v1.json)

## 建議下一步
1. 先把 `幽語海` 拿去做 CLI 原型
2. 再做 `港邊航務圈`
3. 之後才擴到第二個完整起始區域
