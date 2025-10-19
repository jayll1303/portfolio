# Hướng dẫn thêm bài viết và tùy biến giao diện

## Thêm bài viết mới (Private: `porfolio-content`)

1. Tạo file theo định dạng: `porfolio-content/_posts/YYYY-MM-DD-title.md`
2. Front matter mẫu:
```markdown
---
layout: post
title: "Tiêu đề bài viết"
date: 2025-01-01 00:00:00 +0000
categories: [blog]
---

Nội dung bài viết...
```
3. Commit và push trong submodule private:
```bash
cd porfolio-content
git add _posts/2025-01-01-title.md
git commit -m "feat(post): add <title>"
git push origin main
```
4. Workflow sẽ tự đồng bộ sang `jayll1303.github.io` và build Pages.

## Tùy biến giao diện (Public: `jayll1303.github.io`)

- Theme: Hacker (`pages-themes/hacker`)
- Cấu hình trong `_config.yml`:
```yaml
remote_theme: pages-themes/hacker@v0.2.0
plugins:
  - jekyll-remote-theme
```
- Ghi đè style:
```text
jayll1303.github.io/assets/css/style.scss
```
Nội dung mẫu:
```scss
---
---
@import "jekyll-theme-hacker";

/* overrides */
body { font-size: 17px; }
```
- Tùy biến layout/include: thêm file vào `jayll1303.github.io/_layouts/` hoặc `_includes/`.

## Cập nhật submodules

```bash
git submodule update --init --recursive
git submodule foreach git fetch --all --prune
git submodule foreach git checkout main
git submodule foreach git pull --rebase
```

## Tham chiếu

- Hacker theme README: https://github.com/pages-themes/hacker/blob/master/README.md
- Public site: https://jayll1303.github.io
