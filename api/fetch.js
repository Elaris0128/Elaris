export const config = {
  runtime: 'edge',
};

export default async function handler(req) {
  const { searchParams } = new URL(req.url);
  const query = searchParams.get('q');
  let pageUrl = 'https://elaris0128.github.io/Elaris/index.html';

  if (query) {
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
      headers: {
        'Content-Type': 'application/json',
      },
    });
  }
}
