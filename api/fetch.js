export const config = {
  runtime: 'edge',
};

export default async function handler(req) {
  const { searchParams } = new URL(req.url);
  const query = searchParams.get('q');

  if (!query) {
    return new Response(JSON.stringify({ error: '缺少查詢參數 q' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const safeQuery = query.replace(/[^a-zA-Z0-9_\\-./]/g, '');
  const pageUrl = `https://elaris0128.github.io/Elaris/${safeQuery}`;

  try {
    const resp = await fetch(pageUrl);
    if (!resp.ok) {
      return new Response(JSON.stringify({ error: `查無 ${safeQuery}` }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const html = await resp.text();
    return new Response(JSON.stringify({ content: html }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: '無法抓取頁面內容' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
}
