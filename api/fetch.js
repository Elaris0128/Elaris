export default async function handler(req, res) {
  const url = 'https://elaris0128.github.io/Elaris/index.html';

  try {
    const resp = await fetch(url);
    const html = await resp.text();
    res.status(200).json({ content: html });
  } catch (e) {
    res.status(500).json({ error: '無法抓取頁面內容' });
  }
}
