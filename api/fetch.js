import { readDocumentByPath } from './_lib/lore.js';

export default async function handler(req, res) {
  const query = String(req.query?.q || '').trim();

  if (!query) {
    res.status(400).json({
      error: 'missing_query',
      message: '請提供 q，內容為可讀取的相對檔案路徑。',
      example: 'content/world/05-races/noruin-lineage.md',
      deprecated: true,
    });
    return;
  }

  try {
    const document = await readDocumentByPath(query);

    if (!document) {
      res.status(404).json({
        error: 'not_found',
        message: '找不到對應文件，或該路徑不在允許讀取的 lore 範圍內。',
        deprecated: true,
      });
      return;
    }

    res.status(200).json({
      deprecated: true,
      note: '請改用 /api/lore/document 取得更完整、穩定的結構化結果。',
      ...document,
    });
  } catch (error) {
    res.status(500).json({
      error: 'internal_error',
      message: '讀取 lore 文件時發生錯誤。',
      detail: String(error?.message || error),
      deprecated: true,
    });
  }
}
