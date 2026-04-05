# openapi-static 分支

這是用來部署 openapi.json 給 ChatGPT 自訂 GPT 使用的輕量分支。

## 結構
- public/openapi.json：OpenAPI 3.1 描述
- vercel.json：靜態部署設定（version: 2）

## 使用方式
1. 上傳整份 zip 到 GitHub 分支 `openapi-static`
2. 建立 Pull Request → 點 Merge
3. 部署網址將變成：https://your-vercel-url.vercel.app/openapi.json
