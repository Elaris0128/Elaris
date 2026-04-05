import { listScopes, searchLore } from '../_lib/lore.js';

export default async function handler(req, res) {
  const q = String(req.query?.q || '').trim();
  const scope = String(req.query?.scope || '').trim().toLowerCase();
  const limit = Number.parseInt(String(req.query?.limit || '5'), 10);

  if (!q) {
    res.status(400).json({
      error: 'missing_query',
      message: '請提供 q 來搜尋 lore。',
      allowedScopes: listScopes(),
    });
    return;
  }

  if (scope && !listScopes().includes(scope)) {
    res.status(400).json({
      error: 'invalid_scope',
      message: 'scope 必須是 world、game、scenarios 或 docs。',
      allowedScopes: listScopes(),
    });
    return;
  }

  try {
    const items = await searchLore(q, scope || null, limit);

    res.status(200).json({
      query: q,
      scope: scope || null,
      limit: Math.max(1, Math.min(limit || 5, 10)),
      count: items.length,
      items,
    });
  } catch (error) {
    res.status(500).json({
      error: 'internal_error',
      message: '搜尋 lore 時發生錯誤。',
      detail: String(error?.message || error),
    });
  }
}
