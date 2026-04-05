# Elaris Custom GPT Actions 設定清單

這份清單是給 `ChatGPT 自訂 GPT -> Actions` 使用的。

## 目標

讓自訂 GPT 在保留既有 `Knowledge` 遊玩核心包的前提下，還能透過 API 查詢完整的 Elaris 世界資料。

## 已準備好的 API

- `GET /api/lore/search`
  先用關鍵字找文件。
- `GET /api/lore/document`
  用路徑讀單一文件全文。
- `GET /api/fetch`
  舊版相容端點，建議只在必要時使用。

OpenAPI 檔位置：

- [`/openapi.json`](/C:/Users/rabbi/Desktop/Elaris/openapi.json)
- [`/public/openapi.json`](/C:/Users/rabbi/Desktop/Elaris/public/openapi.json)

## 建議接法

1. 先把專案部署到可公開存取的網址。
2. 把 `openapi.json` 裡的 `servers[0].url` 改成實際部署網址。
3. 在自訂 GPT 的 `Actions` 設定中匯入這份 OpenAPI schema。
4. 保留目前已上傳的 `Knowledge` 檔，讓 GPT：
   - 用 Knowledge 維持遊玩規則與核心正典
   - 用 Action 查地區、種族、任務、世界觀全文

## 建議使用順序

對 GPT 的指示可以維持：

1. 先依 `Knowledge` 判斷玩家創角、分支、起始區域與遊玩流程。
2. 當玩家問到細部世界觀，或需要更完整地區資料時：
   - 先呼叫 `search`
   - 再對最相關的結果呼叫 `document`
3. 如果 API 查不到，再明講目前沒有命中資料，不要硬編。

## 建議查詢例

### 搜尋種族

`/api/lore/search?q=諾魯因人&scope=world`

### 搜尋地區

`/api/lore/search?q=幽語海&scope=world`

### 讀取全文

`/api/lore/document?path=content/world/05-races/noruin-lineage.md`

## 建議給 GPT 的 Action 使用規則

可以加進 Instructions 的補充原則：

- 當世界觀細節不在 Knowledge 中時，先用 `search` 找候選文件，再用 `document` 讀全文。
- 不要直接把 `search` 的結果當成完整答案。
- 若多份文件互有關聯，優先讀：
  1. 種族 / 地區主檔
  2. README / index 類索引
  3. 專題細檔
- 若資料不足，明確說明是「目前 API 未命中足夠資料」。

## 第一版限制

這一版 API 先重點解決：

- 可以查詢
- 可以讀全文
- 可供自訂 GPT Actions 穩定使用

之後若要再升級，最值得補的是：

- 更強的中文斷詞搜尋
- 指定類型查詢，例如 `race / region / quest / item`
- 文件關聯推薦
- 地區任務與玩家開局的直接查詢端點
