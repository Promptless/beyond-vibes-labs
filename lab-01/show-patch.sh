#!/usr/bin/env bash
# Saves your agent's changes and opens them as a readable page in your browser.
#
# Usage: show-patch.sh [--dest DIR] [--no-open] [TASK]
#
# TASK is pr146 (the default) or common-pr65. DIR is the folder setup.sh built,
# ~/beyond-vibes-lab-01 by default. The script writes two files next to docs/:
#   my-patch.diff   every change the agent made, new files included
#   my-patch.html   the same changes word by word: added text in green,
#                   removed text struck through in red
# and opens my-patch.html unless you pass --no-open.

set -euo pipefail

DEST="${HOME}/beyond-vibes-lab-01"
TASK=pr146
OPEN=1

die() {
  printf 'show-patch: %s\n' "$*" >&2
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dest)
      [ $# -ge 2 ] || die "--dest needs a directory"
      DEST="$2"
      shift 2
      ;;
    --dest=*)
      DEST="${1#--dest=}"
      shift
      ;;
    --no-open)
      OPEN=0
      shift
      ;;
    -h|--help)
      sed -n '2,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    -*)
      die "unknown option $1 (see --help)"
      ;;
    *)
      TASK="$1"
      shift
      ;;
  esac
done

task_dir="$DEST/$TASK"
docs="$task_dir/docs"
[ -d "$docs/.git" ] || die "no workspace at $docs. Run lab-01/setup.sh first."

# Stage everything into a throwaway index, so new files show up and the
# workspace's own index is left alone.
index="$(mktemp)"
trap 'rm -f "$index"' EXIT
GIT_INDEX_FILE="$index" git -C "$docs" read-tree HEAD
GIT_INDEX_FILE="$index" git -C "$docs" add -A

GIT_INDEX_FILE="$index" git -C "$docs" diff --cached --no-color > "$task_dir/my-patch.diff"

files="$(GIT_INDEX_FILE="$index" git -C "$docs" diff --cached --name-only | wc -l | tr -d ' ')"

{
  cat <<EOF
<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Your agent's changes: $TASK</title>
<style>
  body { font: 17px/1.6 -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 0; background: #f6f7f9; color: #1c1f2b; }
  main { max-width: 900px; margin: 0 auto; padding: 32px 20px 64px; }
  h1 { font-size: 28px; margin: 0 0 8px; }
  .meta { color: #484c5d; margin: 0 0 24px; }
  .key ins, .key del { padding: 0 4px; }
  section { background: #fff; border: 1px solid #e4e6ed; border-radius: 10px; margin: 0 0 24px; overflow: hidden; }
  h2 { font-size: 18px; margin: 0; padding: 12px 16px; background: #eeeff4; border-bottom: 1px solid #e4e6ed; font-family: ui-monospace, Menlo, Consolas, monospace; }
  h2 span { font-family: inherit; font-weight: 400; font-size: 14px; color: #6b6f81; margin-left: 8px; }
  .loc { font-size: 13px; color: #6b6f81; padding: 10px 16px 0; }
  .text { white-space: pre-wrap; word-wrap: break-word; padding: 4px 16px 12px; font-family: ui-monospace, Menlo, Consolas, monospace; font-size: 15px; border-bottom: 1px dashed #e4e6ed; }
  .text:last-child { border-bottom: 0; }
  ins { background: #d8f5e3; color: #0b5c32; text-decoration: none; }
  del { background: #fde2e6; color: #8f1d33; }
  .empty { padding: 16px; }
</style></head><body><main>
<h1>Your agent's changes: $TASK</h1>
EOF
  if [ "$files" = 0 ]; then
    printf '<p class="meta">Your agent didn'"'"'t change any files.</p>\n'
  else
    printf '<p class="meta">%s file(s) changed. <span class="key"><ins>Green</ins> is text the agent added; <del>red</del> is text it removed.</span> The same changes are saved in my-patch.diff, next to this page.</p>\n' "$files"
    GIT_INDEX_FILE="$index" git -C "$docs" diff --cached --no-color --word-diff=porcelain -U3 | awk '
      function esc(s) { gsub(/&/, "\\&amp;", s); gsub(/</, "\\&lt;", s); gsub(/>/, "\\&gt;", s); return s }
      function close_text() { if (intext) { printf "</div>\n"; intext = 0 } }
      function close_file() { close_text(); if (infile) { printf "</section>\n"; infile = 0 } }
      /^diff --git / {
        close_file()
        name = $0; sub(/^diff --git a\//, "", name); sub(/ b\/.*$/, "", name)
        status = "changed"; hunk = 0; pending = 1
        next
      }
      pending && /^new file mode/ { status = "new file"; next }
      pending && /^deleted file mode/ { status = "deleted"; next }
      pending && /^Binary files/ {
        printf "<section><h2>%s<span>%s</span></h2><p class=\"empty\">Binary file, not shown.</p>\n", esc(name), status
        infile = 1; pending = 0; next
      }
      /^@@/ {
        if (pending) { printf "<section><h2>%s<span>%s</span></h2>\n", esc(name), status; infile = 1; pending = 0 }
        close_text()
        line = $0; sub(/^@@ -[0-9,]* \+/, "", line); sub(/[, ].*$/, "", line)
        printf "<div class=\"loc\">Around line %s</div><div class=\"text\">", line
        intext = 1; hunk = 1
        next
      }
      !hunk { next }
      /^~/ { printf "\n"; next }
      /^ / { printf "%s", esc(substr($0, 2)); next }
      /^\+/ { printf "<ins>%s</ins>", esc(substr($0, 2)); next }
      /^-/ { printf "<del>%s</del>", esc(substr($0, 2)); next }
      END { close_file() }
    '
  fi
  printf '</main></body></html>\n'
} > "$task_dir/my-patch.html"

printf 'Saved %s/my-patch.diff\n' "$task_dir"
printf 'Saved %s/my-patch.html\n' "$task_dir"

[ "$OPEN" = 1 ] || exit 0
html="$task_dir/my-patch.html"
case "$(uname -s)" in
  Darwin) open "$html" ;;
  MINGW*|MSYS*|CYGWIN*) cmd.exe //c start "" "$(cygpath -w "$html")" ;;
  *)
    if command -v wslview >/dev/null 2>&1; then wslview "$html"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$(wslpath -w "$html")" || true
    elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$html" >/dev/null 2>&1
    else printf 'Open that file in your browser to read the changes.\n'
    fi
    ;;
esac
