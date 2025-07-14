export const config = {
  runtime: 'edge',
};

export default async function handler(req) {
  const { searchParams } = new URL(req.url);
  const query = searchParams.get('q');

  // 預設網址
  let pageUrl = 'https://elaris0128.github.io/Elaris/index.html';

  // 如果有提供查詢參數，就變更頁面網址（你可依實際結構調整）
  if (query) {
    // 安全處理：只允許英數與斜線
    const safeQuery = query.replace(/[^a-zA-Z0-9\-\/]/g, '');
    pageUrl = `https://elaris0128.github.io/Elaris/${safeQuery}.html`;
  }

  try {
    const resp = await fetch(pageUrl);
    const html = await resp.text();

    return new Response(JSON.stringify({ content: html }), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: '無法抓取頁面內容' }), {
      status: 500,
      h
