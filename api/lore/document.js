import { readDocumentByPath } from '../_lib/lore.js';

export default async function handler(req, res) {
  const inputPath = String(req.query?.path || '').trim();

  if (!inputPath) {
    res.status(400).json({
      error: 'missing_path',
      message: '請提供 path，例如 content/world/05-races/noruin-lineage.md',
    });
    return;
  }

  try {
    const document = await readDocumentByPath(inputPath);

    if (!document) {
      res.status(404).json({
        error: 'not_found',
        message: '找不到指定文件，或該路徑不在允許讀取的 lore 範圍內。',
      });
      return;
    }

    res.status(200).json(document);
  } catch (error) {
    res.status(500).json({
      error: 'internal_error',
      message: '讀取 lore 文件時發生錯誤。',
      detail: String(error?.message || error),
    });
  }
}
