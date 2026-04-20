# 文字遊戲框架層

這裡放的是 `Elaris 文字遊戲` 的正式框架骨架，而不是單一區域的 prototype 內容。

目前這層的用途是：

- 提供一個乾淨的主入口
- 把「可玩切片」從單一腳本中抽成可註冊、可擴充的區域條目
- 替未來的多區域共用模組留位置

## 目前內容

- [框架總覽](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/framework-overview.md)
- [切片註冊表](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/config/slices.registry.json)
- [共用函式模組](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/modules/Elaris.TextGame.Common.psm1)
- [共用路徑模組](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/modules/Elaris.TextGame.Paths.psm1)
- [區域註冊表模組](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/modules/Elaris.TextGame.RegionRegistry.psm1)
- [存檔總覽模組](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/modules/Elaris.TextGame.SaveCatalog.psm1)
- [啟動流程模組](/C:/Users/rabbi/Desktop/Elaris/text-game/06-framework/modules/Elaris.TextGame.Session.psm1)

## 目前角色

這一層現在先負責：

- 顯示主框架選單
- 列出目前已可玩的切片
- 由外部註冊表管理切片
- 掃描目前已有的存檔
- 將玩家送進對應區域 prototype
- 保持之後能擴成：
  - 多區域選單
  - 正式共用回合流程
  - 正式共用存檔管理
  - 區域切換

## 和原型區的關係

- [05-prototypes](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/README.md)
  這裡仍然是目前最實際的可玩內容
- `06-framework`
  這裡則是把那些內容收攏成一個更像「遊戲本體」的入口

目前已接上的第一個切片是：

- [幽語海 CLI 原型腳本](/C:/Users/rabbi/Desktop/Elaris/text-game/05-prototypes/whispersea-cli-prototype.ps1)

## 啟動入口

整個框架目前的入口是：

- [play-elaris.ps1](/C:/Users/rabbi/Desktop/Elaris/text-game/play-elaris.ps1)

目前主入口選單已經多了：

- `查看框架狀態`
- `查看存檔總覽`


