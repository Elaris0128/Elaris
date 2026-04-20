# Elaris 遊戲畫面 UI 原型

這一層先不接劇情邏輯，目的是把 `Elaris 文字遊戲` 從 CLI 指令感，先拉成比較像一般遊戲的畫面骨架。

## 這版先做什麼

- 開頭首頁只保留三顆按鈕：
  - `開始遊玩`
  - `再續篇章`
  - `設定`
- 遊戲內畫面採 `中間主敘事 / 左側系統 / 右側內容` 的閱讀重心
- 一般遊戲 HUD
- 新遊戲建立流程
- 切片選擇 / 白身身份選擇 / 起始落點選擇
- 存檔讀取視窗
- 左側主導覽
- 右側抽屜面板
- 中央敘事與操作按鈕區
- 任務 / 角色 / 背包 / 同行 / 關係 / 存檔 / 設定 這些常用視窗

## 先不做什麼

- 不先接任務運算
- 不先接存檔讀寫
- 不先接真實世界時鐘
- 不先把 CLI 原型整段搬過來

也就是說，這一版是：

`先定畫面，再慢慢接邏輯`

但這次已經不只是靜態展示，而是有：

- 首頁模式與遊戲內模式切換
- 新遊戲建立 modal
- 讀取存檔 modal
- 設定 modal
- 切片 / 白身身份 / 起始落點的前置選擇
- 主畫面與遊玩畫面的切換
- 抽屜與場景按鈕的互動
- 預設先看中央劇情
- 左側保留主選單、續篇、存檔與設定等系統入口
- 右側只放角色 / 任務 / 背包 / 同行 / 關係 / 地圖等內容面板
- 左右欄都可以收起，讓畫面回到故事本身
- 啟動時自動讀取框架切片與現有存檔
- 本機 localhost 啟動層
- `開始遊玩 / 再續篇章` 可直接在新的本機遊戲視窗裡開出目前的 CLI 原型

## 目前檔案

- [index.html](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/index.html)
- [styles.css](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/styles.css)
- [app.js](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/app.js)
- [prototype-data.js](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/prototype-data.js)
- [generated-data.js](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/generated-data.js)
- [generate-ui-shell-data.ps1](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/generate-ui-shell-data.ps1)
- [start-ui-shell-server.ps1](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/start-ui-shell-server.ps1)
- [啟動-Elaris-遊戲畫面原型.bat](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/啟動-Elaris-遊戲畫面原型.bat)

## 打開方式

直接雙擊：

- [啟動-Elaris-遊戲畫面原型.bat](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/啟動-Elaris-遊戲畫面原型.bat)

它現在會：
- 先更新切片與存檔資料
- 啟動本機 localhost UI shell
- 自動打開瀏覽器

如果你只是直接開 [index.html](/C:/Users/rabbi/Desktop/Elaris/text-game/07-ui-shell/index.html)，仍然可以看 UI，但 `開始遊玩 / 再續篇章` 不會真的啟動本機遊戲。

## 接下來最自然的接法

1. 把 `play-elaris.ps1` 的主入口選單改成畫面化主選單
2. 把 `06-framework/config/slices.registry.json` 和存檔總覽直接接進這個 UI
3. 把 `幽語海` 目前的 `status / quest / companion / inventory` 接到這個 UI 殼層
4. 再決定是不是要保留 CLI 當開發模式、UI 當正式遊玩模式
