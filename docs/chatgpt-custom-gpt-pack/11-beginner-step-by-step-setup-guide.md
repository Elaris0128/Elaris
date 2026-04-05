# Elaris 自訂 GPT 新手一步一步設定指南

這份是給「已經把 Knowledge 上傳好，但還不知道下一步怎麼做」的人。

## 先講最重要的

你現在有兩條路：

### 路線 A：先直接玩

這條最簡單。

你現在已經把 Knowledge 上傳好了，所以其實已經可以直接玩：

1. 打開你的自訂 GPT。
2. 先不要管 Actions。
3. 直接輸入：

`我要開始創角。`

或：

`我要玩諾魯因人，主職引水人，副職療傷手。`

如果它能正確：

- 幫你創角
- 正確辨認種族 / 分支
- 把你放到對應起始區
- 給你不是固定劇本的開場

那代表你的 `Knowledge 版` 已經能玩了。

### 路線 B：再讓它能查完整世界資料

這條比較進階。

你需要：

1. 把這個專案部署成一個可公開存取的網址
2. 在自訂 GPT 裡加上 `Actions`
3. 匯入 [`openapi.json`](/C:/Users/rabbi/Desktop/Elaris/openapi.json)

如果你現在只是想先開始玩，請先走 `路線 A`。

## 我建議你現在先做的事

### 第 1 步：先測目前這顆 GPT 能不能玩

丟這三句給它：

1. `我要開始創角。`
2. `我要玩海人。`
3. `直接幫我開始，但不要固定劇本。`

你要觀察的是：

- 它會不會正確要求你選海人分支
- 它會不會把你放到正確起始區
- 它會不會自動硬塞固定開局

### 第 2 步：如果能玩，就先用這版玩

因為你目前最大的價值，其實已經在：

- 種族 / 分支
- 起始區域
- 創角
- 玩家規則
- 開局邏輯
- AI 裁定框架

這些都已經在 Knowledge 裡了。

## 什麼時候才需要做 Actions

當你開始遇到下面這些情況時，就該做：

- 它不知道某個冷門國家細節
- 它不知道某個地區的完整任務池
- 它不知道某個公會完整制度
- 它不知道某個魔物 / 物品 / 歷史條目的全文

簡單說：

- `Knowledge` 負責讓它能玩
- `Actions` 負責讓它能查更多世界觀全文

## 如果你要接 Actions，最簡單做法

### 第 1 步：先部署這個專案

最簡單通常是用 Vercel。

你需要把：

- [`api/lore/search.js`](/C:/Users/rabbi/Desktop/Elaris/api/lore/search.js)
- [`api/lore/document.js`](/C:/Users/rabbi/Desktop/Elaris/api/lore/document.js)
- [`openapi.json`](/C:/Users/rabbi/Desktop/Elaris/openapi.json)

一起部署出去。

部署成功後，你會拿到一個網址，像：

`https://your-elaris.vercel.app`

### 第 2 步：改掉 openapi 的網址

打開：

- [`openapi.json`](/C:/Users/rabbi/Desktop/Elaris/openapi.json)

把：

`https://your-elaris-vercel-url.vercel.app`

改成你的真實網址。

### 第 3 步：到自訂 GPT 裡加 Action

依 OpenAI 官方說明：

1. 到 `chatgpt.com/gpts/editor`
2. 打開你的 GPT
3. 進入 `Configure`
4. 找到 `Actions`
5. 選 `Create new action`
6. 匯入 OpenAPI schema

官方參考：

- [Creating a GPT](https://help.openai.com/en/articles/8554397-creating-a-gpt)
- [Knowledge in GPTs](https://help.openai.com/en/articles/8843948-knowledge-in-gpts)
- [Configuring actions in GPTs](https://help.openai.com/en/articles/9442513-configuring-actions-in-gpts)

### 第 4 步：匯入後的使用方式

接好後，這顆 GPT 就能：

- 先靠 Knowledge 跑遊戲
- 遇到細部世界觀問題時，再透過 Action 查文件

建議它用的順序是：

1. 先 `search`
2. 再 `document`

## 我最建議你的實際順序

1. 先用現在這顆 GPT 開始創角
2. 確認它真的能玩
3. 玩到你開始覺得它「不知道更多世界資料」時
4. 再來接 Actions

## 如果你想要我接著幫你做什麼

我最能直接幫你的下一步有兩種：

### 1. 我幫你做「Vercel 部署教學」

適合你現在最想把 Actions 接起來。

### 2. 我幫你做「自訂 GPT 驗收清單」

適合你現在先想確認：

- 這顆 GPT 會不會創角
- 會不會分支判斷錯
- 會不會起始區放錯
- 會不會開固定劇本

如果你現在要我直接帶你做，我最建議從：

`先驗收目前這顆 GPT 能不能玩`

開始。
