#!/usr/bin/env bash

set -euo pipefail

print_usage() {
  cat <<'EOF'
Usage: tools/push.sh -m "commit message"

Actions:
  1) Fetch + pull latest from repo jayll1303.github.io (branch: main)
  2) Add, commit (with provided message), and push in porfolio-content (branch: main)

Options:
  -m   Commit message (required)
  -h   Show this help
EOF
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

COMMIT_MSG=""
while getopts ":m:h" opt; do
  case "$opt" in
    m)
      COMMIT_MSG="$OPTARG"
      ;;
    h)
      print_usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      print_usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      print_usage
      exit 1
      ;;
  esac
done

if [[ -z "${COMMIT_MSG}" ]]; then
  echo "Error: commit message is required (-m)." >&2
  print_usage
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GITHUB_IO_DIR="${ROOT_DIR}/jayll1303.github.io"
CONTENT_DIR="${ROOT_DIR}/porfolio-content"

if [[ ! -d "${GITHUB_IO_DIR}" ]]; then
  echo "Error: directory not found: ${GITHUB_IO_DIR}" >&2
  exit 1
fi

if [[ ! -d "${CONTENT_DIR}" ]]; then
  echo "Error: directory not found: ${CONTENT_DIR}" >&2
  exit 1
fi

# Step 1: Pull latest from github.io
log "Step 1/2: Fetching and pulling latest in ${GITHUB_IO_DIR}"
pushd "${GITHUB_IO_DIR}" >/dev/null
log "Git remote: $(git remote -v | tr '\n' ' | ')"
git fetch --all --prune
log "Pulling origin main"
git pull --rebase origin main
popd >/dev/null

# Step 2: Commit and push changes in porfolio-content
log "Step 2/2: Staging, committing, and pushing in ${CONTENT_DIR}"
pushd "${CONTENT_DIR}" >/dev/null
git add -A

if git diff --cached --quiet; then
  log "No changes to commit. Skipping commit and push."
else
  log "Committing with message: ${COMMIT_MSG}"
  git commit -m "${COMMIT_MSG}"
  log "Pushing to origin main"
  git push origin main
fi

popd >/dev/null
log "All done."


