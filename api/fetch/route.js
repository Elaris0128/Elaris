export const config = {
  runtime: 'edge',
};

export default async function handler(req) {
  const url = 'https://elaris0128.github.io/Elaris/index.html';

  try {
    const resp = await fetch(url);
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
