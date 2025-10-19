# Hướng dẫn nhanh

## Viết bài mới

- Thư mục: `porfolio-content/_posts/`
- Định dạng file: `YYYY-MM-DD-title.md`
- Front matter mẫu:
```markdown
---
layout: post
title: "Tiêu đề"
date: 2025-01-01 00:00:00 +0000
categories: [blog]
---
```
- Push lên `main` của `porfolio-content` để kích hoạt sync và build.

## Tuỳ biến giao diện

- Chỉnh `jayll1303.github.io/_config.yml` để đổi tiêu đề, mô tả, theme.
- Thêm `assets/css/style.scss` để override CSS.
- Có thể thêm `_layouts/*.html` hoặc `_includes/*.html` để thay đổi layout.

## Cập nhật submodules

```bash
git submodule update --init --recursive
git submodule foreach git pull --rebase
```

## Links

- Site: https://jayll1303.github.io
- Theme: https://github.com/pages-themes/hacker/blob/master/README.md
