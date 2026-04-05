import os

folder = '.'
output_file = 'index.html'
files = []

print("🚀 開始掃描目錄...")

for root, dirs, filenames in os.walk(folder):
    for filename in filenames:
        if filename.endswith(('.md', '.html')) and filename != 'index.html':
            rel_path = os.path.relpath(os.path.join(root, filename), folder)
            rel_path = rel_path.replace('\\', '/')
            files.append(rel_path)
            print(f"👉 找到：{rel_path}")

if not files:
    print("❌ 沒找到任何檔案 (.md / .html)！")
else:
    print(f"✅ 共找到 {len(files)} 個檔案，準備寫入 index.html")

html = '''<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>自動產生目錄（含子資料夾）</title>
</head>
<body>
  <h1>文件列表</h1>
  <ul>
'''

for f in sorted(files):
    html += f'    <li><a href="{f}">{f}</a></li>\n'

html += '''  </ul>
</body>
</html>
'''

# 嘗試寫檔
try:
    with open(os.path.join(folder, output_file), 'w', encoding='utf-8') as f:
        f.write(html)
    print(f'✅ 已成功產生 → {output_file}')
except Exception as e:
    print(f"⚠️ 寫檔失敗：{e}")
