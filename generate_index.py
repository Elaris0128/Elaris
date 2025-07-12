import os

folder = '.'
output_file = 'index.html'
files = []

print("🚀 開始掃描資料夾...")

# 掃所有子資料夾
for root, dirs, filenames in os.walk(folder):
    for filename in filenames:
        if filename.endswith(('.md', '.html')) and filename != output_file:
            rel_path = os.path.relpath(os.path.join(root, filename), folder)
            rel_path = rel_path.replace('\\', '/')
            files.append(rel_path)
            print(f"👉 找到：{rel_path}")

if not files:
    print("❌ 沒找到任何檔案！")
else:
    print(f"✅ 共找到 {len(files)} 個檔案，開始產生分群內文目錄")

# 建立分群結構
tree = {}
for f in files:
    parts = f.split('/')
    current = tree
    for p in parts[:-1]:
        current = current.setdefault(p, {})
    current.setdefault('__files__', []).append(parts[-1])

# HTML 開頭
html = '''<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>分群內文目錄</title>
</head>
<body>
  <h1>文件分群目錄</h1>
  <hr>
'''

def render(node, level=1, prefix=''):
    global html
    for k, v in node.items():
        if k == '__files__':
            for f in v:
                full_path = prefix + f
                html += f'<h{level+1}>{f}</h{level+1}>\n'
                try:
                    with open(full_path, 'r', encoding='utf-8') as file:
                        content = file.read()
                        html += f'<pre>{content}</pre>\n'
                except Exception as e:
                    html += f'<p>⚠️ 無法讀取：{e}</p>\n'
        else:
            html += f'<h{level}>{k}</h{level}>\n'
            render(v, level+1, prefix + k + '/')

render(tree)

html += '''
</body>
</html>
'''

# 輸出 index.html
with open(os.path.join(folder, output_file), 'w', encoding='utf-8') as f:
    f.write(html)

print(f'✅ 已成功產生 → {output_file}')
