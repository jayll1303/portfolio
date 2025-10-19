# Portfolio Monorepo

This repository references two submodules:

- `jayll1303.github.io` (public): Jekyll site and GitHub Pages build
- `porfolio-content` (private): content source (`_posts/`, optional `assets/uploads/`)

## Add a new post

1. Create a new markdown in `porfolio-content/_posts/` with filename `YYYY-MM-DD-title.md`.
2. Include front matter:

```markdown
---
layout: post
title: "Your Title"
date: 2025-01-01 00:00:00 +0000
categories: [notes]
---

Your content here.
```

3. Commit and push in `porfolio-content` submodule:

```bash
cd porfolio-content
git add _posts/2025-01-01-your-title.md
git commit -m "feat(post): add your title"
git push origin main
```

4. The sync workflow will copy posts into `jayll1303.github.io` and trigger Pages build.

## Customize theme

The public site uses the Hacker theme via `remote_theme`.

- Update `jayll1303.github.io/_config.yml`:

```yaml
remote_theme: pages-themes/hacker@v0.2.0
plugins:
  - jekyll-remote-theme
```

- Override styles by creating `assets/css/style.scss` in `jayll1303.github.io`:

```scss
---
---
@import "jekyll-theme-hacker";

/* Custom overrides */
:root { --accent-color: #00ff66; }
```

- Customize navigation or layouts by adding files under `jayll1303.github.io/_layouts/`, `_includes/`, `assets/`.

- Rebuild happens automatically on push to `main` of the public repo.

## Submodules

Update submodules to latest remote:

```bash
git submodule update --init --recursive
git submodule foreach git fetch --all --prune
git submodule foreach git checkout main
git submodule foreach git pull --rebase
```

## Initial setup

- Ensure `porfolio-content` repo has secret `DEPLOY_TOKEN` (classic PAT, scope `repo`).
- Ensure Pages source in public repo is GitHub Actions.

## Links

- Public site: https://jayll1303.github.io
- Hacker theme docs: https://github.com/pages-themes/hacker/blob/master/README.md

## Tools

- Push helper: `tools/push.sh`

Usage:

```bash
tools/push.sh -m "feat(content): add new post"
```

What it does:
- Pull latest for `jayll1303.github.io` (main)
- Add/commit/push in `porfolio-content` (main) with provided message
