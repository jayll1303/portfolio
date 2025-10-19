<!-- 102de6db-0d92-413f-884d-55383b03c021 d711ea1c-2aa4-4d98-89ec-028cd501c769 -->
# Kế hoạch triển khai portfolio (private chỉ content, build ở public)

## 1) Clone hai repo về thư mục hiện tại với `--reference`

- Thư mục làm việc: `/home/jayll/portfolio`
- Tạo mirror cache cục bộ để tận dụng `--reference`, sau đó clone 2 repo:
```bash
# Chuẩn bị cache mirror (1 lần)
mkdir -p ~/.cache/git/mirrors

# Tạo mirror cho 2 repo
git clone --mirror https://github.com/jayll1303/jayll1303.github.io.git ~/.cache/git/mirrors/jayll1303.github.io.git
git clone --mirror https://github.com/jayll1303/porfolio-content.git ~/.cache/git/mirrors/porfolio-content.git

# Clone về thư mục hiện tại bằng --reference
cd /home/jayll/portfolio
git clone --reference ~/.cache/git/mirrors/jayll1303.github.io.git https://github.com/jayll1303/jayll1303.github.io.git
git clone --reference ~/.cache/git/mirrors/porfolio-content.git https://github.com/jayll1303/porfolio-content.git
```

- Cập nhật cache khi cần (tùy chọn):
```bash
git -C ~/.cache/git/mirrors/jayll1303.github.io.git remote update --prune
git -C ~/.cache/git/mirrors/porfolio-content.git remote update --prune
```


## 2) Phân vai 2 repository

- `porfolio-content` (Private): chỉ chứa nội dung bài viết, khuyến nghị đặt ở `/_posts` và (tuỳ chọn) `assets/uploads`.
- `jayll1303.github.io` (Public): chứa mã nguồn Jekyll (theme, `_config.yml`, `Gemfile`, v.v.). Build + deploy Pages diễn ra tại đây.

Lưu ý: Nếu repo public chưa có skeleton Jekyll, sẽ khởi tạo tối thiểu (`Gemfile`, `_config.yml`, `index.md`) hoặc dùng `remote_theme`.

## 3) Secrets & quyền truy cập

- Tạo PAT Classic với scope `repo`. Lưu giá trị làm Secret trong repo Private `porfolio-content`:
                - Name: `DEPLOY_TOKEN`
                - Dùng để push đồng bộ content sang repo Public.
- Bật GitHub Pages cho repo Public với nguồn "GitHub Actions" (Settings → Pages → Build and deployment → Source: GitHub Actions).

## 4) Workflow đồng bộ content (repo Private)

- File: `porfolio-content/.github/workflows/sync-content.yml`
- Ý tưởng: Mỗi lần push vào `main` của Private, workflow sẽ clone Public bằng PAT, chép `/_posts` (và `assets/uploads` nếu có) vào repo Public, commit và push. Điều này sẽ kích hoạt workflow build ở repo Public.
```yaml
name: Sync Content to Public
on:
  push:
    branches: [main]

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout private content
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Clone public repo
        env:
          TOKEN: ${{ secrets.DEPLOY_TOKEN }}
        run: |
          git config --global user.name "github-actions[bot]"
          git config --global user.email "github-actions[bot]@users.noreply.github.com"
          git clone https://$TOKEN@github.com/jayll1303/jayll1303.github.io.git public

      - name: Copy content into public repo
        run: |
          rsync -av --delete _posts/ public/_posts/
          if [ -d assets/uploads ]; then mkdir -p public/assets/uploads && rsync -av --delete assets/uploads/ public/assets/uploads/; fi

      - name: Commit and push if changes
        run: |
          cd public
          if [ -n "$(git status --porcelain)" ]; then
            git add -A
            git commit -m "chore(content): sync from private"
            git push origin main
          else
            echo "No changes to commit"
          fi
```


## 5) Workflow build & deploy Pages (repo Public)

- File: `jayll1303.github.io/.github/workflows/pages.yml`
- Ý tưởng: Khi có thay đổi (ví dụ `_posts/**`, `_config.yml`, theme, v.v.), build Jekyll, upload artifact và deploy bằng GitHub Pages Actions.
```yaml
name: Build and Deploy Jekyll to Pages

on:
  push:
    branches: [main]
    paths:
      - '_posts/**'
      - 'assets/**'
      - '_config.yml'
      - 'Gemfile*'
      - '**.html'
      - '**.scss'
      - '**.md'
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: 'pages'
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true

      - name: Install deps
        run: bundle install --jobs 4 --retry 3

      - name: Build site
        run: JEKYLL_ENV=production bundle exec jekyll build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: _site

  deploy:
    runs-on: ubuntu-latest
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```


## 6) (Nếu cần) Khởi tạo Jekyll tối thiểu ở repo Public

- Tạo `Gemfile`, `_config.yml`, `index.md` tối thiểu (hoặc dùng `remote_theme`), ví dụ:
```ruby
# Gemfile
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
```




```yaml
# _config.yml
title: Jay's Portfolio
description: Personal site
url: https://jayll1303.github.io
plugins: []
# hoặc dùng remote_theme: owner/theme-name
```



```markdown
# index.md
---
layout: default
title: Home
---

Welcome!
```

## 7) Kiểm thử nhanh

- Tạo một bài viết mẫu trong `porfolio-content/_posts` (định dạng `YYYY-MM-DD-title.md`).
- Push lên `main` của Private. Quan sát:
                - Workflow `Sync Content to Public` chạy và đẩy file vào Public.
                - Workflow `Build and Deploy Jekyll to Pages` chạy ở Public, site cập nhật tại `https://jayll1303.github.io`.

### To-dos

- [ ] Clone 2 repo với --reference và tạo mirror cache
- [ ] Khởi tạo skeleton Jekyll tối thiểu ở repo public (nếu thiếu)
- [ ] Tạo PAT `DEPLOY_TOKEN` (scope repo) và thêm vào repo private
- [ ] Thêm workflow sync content vào `porfolio-content`
- [ ] Thêm workflow build & deploy vào `jayll1303.github.io`
- [ ] Tạo bài viết mẫu, verify pipelines và site cập nhật