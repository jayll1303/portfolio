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

## Dùng tool đẩy bài và kéo site public

Script tiện ích nằm ở `tools/push.sh`.

```bash
# Từ thư mục gốc repo
tools/push.sh -m "update: chỉnh sửa bài viết"
```

Chức năng:
- Kéo (fetch/pull) mới nhất cho `jayll1303.github.io` (branch `main`).
- Add/commit/push thay đổi trong `porfolio-content` (branch `main`) với message truyền qua `-m`.

Ghi chú:
- Yêu cầu `origin` đã trỏ đến đúng remote của từng subrepo.
- Nếu không có thay đổi trong `porfolio-content`, script sẽ bỏ qua bước commit/push.

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
