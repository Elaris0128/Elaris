import fs from 'fs/promises';
import path from 'path';

const PROJECT_ROOT = process.cwd();

const ALLOWED_SCOPES = {
  world: 'content/world',
  game: 'content/game',
  scenarios: 'content/scenarios',
  docs: 'docs/chatgpt-custom-gpt-pack',
};

const ALLOWED_EXTENSIONS = new Set(['.md', '.json', '.txt']);
const MANIFEST_SEARCH_SLICE = 5000;
const MANIFEST_EXCERPT_LENGTH = 220;

let manifestPromise;

function toAbsolute(relPath) {
  return path.join(PROJECT_ROOT, relPath);
}

function normalizeText(input) {
  return String(input || '')
    .replace(/\r/g, '')
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/^#+\s+/gm, '')
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1')
    .replace(/!\[[^\]]*\]\([^)]+\)/g, ' ')
    .replace(/[*_>#-]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase();
}

function extractTitle(content, relPath) {
  const headingMatch = String(content || '').match(/^#\s+(.+)$/m);
  if (headingMatch) {
    return headingMatch[1].trim();
  }
  return path.basename(relPath, path.extname(relPath));
}

function extractExcerpt(content) {
  const plain = String(content || '')
    .replace(/\r/g, '')
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/^#+\s+/gm, '')
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1')
    .replace(/!\[[^\]]*\]\([^)]+\)/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();

  return plain.slice(0, MANIFEST_EXCERPT_LENGTH);
}

function extractHeadings(content) {
  return Array.from(String(content || '').matchAll(/^(#{1,3})\s+(.+)$/gm))
    .slice(0, 24)
    .map((match) => ({
      level: match[1].length,
      text: match[2].trim(),
    }));
}

async function walkMarkdownFiles(absDir, relDir) {
  const dirEntries = await fs.readdir(absDir, { withFileTypes: true });
  const files = [];

  for (const entry of dirEntries) {
    const childAbs = path.join(absDir, entry.name);
    const childRel = path.posix.join(relDir.replace(/\\/g, '/'), entry.name);

    if (entry.isDirectory()) {
      files.push(...(await walkMarkdownFiles(childAbs, childRel)));
      continue;
    }

    if (entry.isFile() && ALLOWED_EXTENSIONS.has(path.extname(entry.name).toLowerCase())) {
      files.push(childRel);
    }
  }

  return files;
}

async function buildManifest() {
  const items = [];

  for (const [scope, relRoot] of Object.entries(ALLOWED_SCOPES)) {
    const absRoot = toAbsolute(relRoot);

    let files = [];
    try {
      files = await walkMarkdownFiles(absRoot, relRoot);
    } catch {
      continue;
    }

    for (const relPath of files) {
      try {
        const content = await fs.readFile(toAbsolute(relPath), 'utf8');
        const title = extractTitle(content, relPath);
        const excerpt = extractExcerpt(content);
        const searchable = normalizeText(
          [relPath, title, excerpt, content.slice(0, MANIFEST_SEARCH_SLICE)].join(' ')
        );

        items.push({
          id: relPath.replace(/[\\/]/g, '__').replace(/\.[^.]+$/, ''),
          scope,
          path: relPath.replace(/\\/g, '/'),
          title,
          excerpt,
          searchable,
        });
      } catch {
        // Ignore unreadable files.
      }
    }
  }

  return items;
}

export async function getManifest() {
  if (!manifestPromise) {
    manifestPromise = buildManifest();
  }
  return manifestPromise;
}

export function listScopes() {
  return Object.keys(ALLOWED_SCOPES);
}

export function resolveScope(relPath) {
  const normalized = String(relPath || '').replace(/\\/g, '/');
  const scope = Object.entries(ALLOWED_SCOPES).find(([, root]) => normalized.startsWith(`${root}/`) || normalized === root);
  return scope ? scope[0] : null;
}

export function sanitizePath(inputPath) {
  const normalized = String(inputPath || '')
    .replace(/\\/g, '/')
    .replace(/^\/+/, '')
    .trim();

  if (!normalized || normalized.includes('..')) {
    return null;
  }

  const scope = resolveScope(normalized);
  if (!scope) {
    return null;
  }

  const ext = path.extname(normalized).toLowerCase();
  if (!ALLOWED_EXTENSIONS.has(ext)) {
    return null;
  }

  return normalized;
}

export async function readDocumentByPath(inputPath) {
  const safePath = sanitizePath(inputPath);
  if (!safePath) {
    return null;
  }

  const content = await fs.readFile(toAbsolute(safePath), 'utf8');
  const title = extractTitle(content, safePath);
  const excerpt = extractExcerpt(content);
  const headings = extractHeadings(content);

  return {
    id: safePath.replace(/[\\/]/g, '__').replace(/\.[^.]+$/, ''),
    path: safePath,
    scope: resolveScope(safePath),
    title,
    excerpt,
    headings,
    content,
    wordCount: normalizeText(content).split(/\s+/).filter(Boolean).length,
  };
}

function scoreItem(item, query, terms, scopeFilter) {
  if (scopeFilter && item.scope !== scopeFilter) {
    return 0;
  }

  let score = 0;
  const title = item.title.toLowerCase();
  const relPath = item.path.toLowerCase();
  const excerpt = item.excerpt.toLowerCase();

  if (title.includes(query)) score += 120;
  if (relPath.includes(query)) score += 100;
  if (excerpt.includes(query)) score += 35;

  for (const term of terms) {
    if (title.includes(term)) score += 30;
    if (relPath.includes(term)) score += 25;
    if (excerpt.includes(term)) score += 8;
    if (item.searchable.includes(term)) score += 4;
  }

  return score;
}

export async function searchLore(query, scopeFilter, limit = 5) {
  const normalizedQuery = normalizeText(query);
  if (!normalizedQuery) {
    return [];
  }

  const terms = normalizedQuery.split(/\s+/).filter(Boolean);
  const manifest = await getManifest();

  return manifest
    .map((item) => ({
      ...item,
      score: scoreItem(item, normalizedQuery, terms, scopeFilter),
    }))
    .filter((item) => item.score > 0)
    .sort((a, b) => b.score - a.score || a.path.localeCompare(b.path, 'zh-Hant'))
    .slice(0, Math.max(1, Math.min(limit, 10)))
    .map(({ searchable, score, ...item }) => item);
}

