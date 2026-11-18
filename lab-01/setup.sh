#!/usr/bin/env bash
# Builds the Lab #01 task workspaces.
#
# Usage: setup.sh [--dest DIR] [--force] [TASK...]
#
# TASK is pr146, common-pr65, or both (the default). Each task becomes
# DIR/<task>/ with three entries:
#   docs/     the documentation repository at the task's base commit; your agent works here
#   code/     the source repository with the code change as its latest commit; read-only reference
#   TASK.md   the prompt to paste into your agent
#
# DIR defaults to ~/beyond-vibes-lab-01, a separate folder next to this clone,
# so an agent working in docs/ can't read the rubric or the worked example.
#
# The workspace logic follows DoGBench's dogbench/workspaces.py (Apache-2.0):
# upstream history and remotes are removed, and every input is checked against
# the pins in tasks/<task>.env.

set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/beyond-vibes-lab-01"
FORCE=0
TASKS=()
NO_WEB_LINE="Do not browse the web, fetch URLs, or look up the upstream project or pull request."

# Neutral, fixed identity so the workspace carries no upstream or personal metadata.
export GIT_AUTHOR_NAME="DogBench" GIT_AUTHOR_EMAIL="dogbench@noreply.invalid"
export GIT_COMMITTER_NAME="DogBench" GIT_COMMITTER_EMAIL="dogbench@noreply.invalid"
export GIT_AUTHOR_DATE="2000-01-01T00:00:00+00:00" GIT_COMMITTER_DATE="2000-01-01T00:00:00+00:00"
export GIT_TERMINAL_PROMPT=0

usage() {
  sed -n '2,13p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

die() {
  printf 'setup: %s\n' "$*" >&2
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
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      die "unknown option: $1 (see --help)"
      ;;
    *)
      TASKS+=("$1")
      shift
      ;;
  esac
done

if [ ${#TASKS[@]} -eq 0 ]; then
  TASKS=(pr146 common-pr65)
fi

command -v git >/dev/null 2>&1 || die "Git is required. Install it, then run setup again."

sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 | cut -d' ' -f1
  else
    die "need sha256sum or shasum to verify downloads"
  fi
}

# Creates an empty repository whose main branch will hold neutral commits only.
init_repo() {
  local repo="$1" url="$2"
  git init --quiet "$repo"
  git -C "$repo" symbolic-ref HEAD refs/heads/main
  git -C "$repo" config core.autocrlf false
  git -C "$repo" remote add source "$url"
}

fetch_commit() {
  local repo="$1" sha="$2" resolved
  git -C "$repo" fetch --quiet --no-tags --depth=1 source "$sha" \
    || die "could not fetch $sha from $(git -C "$repo" remote get-url source). Check your network and try again."
  resolved="$(git -C "$repo" rev-parse --verify "$sha^{commit}")"
  [ "$resolved" = "$sha" ] || die "requested $sha, fetched $resolved"
}

# Points main at a parentless 'snapshot' commit of the base tree and checks it out.
snapshot_base() {
  local repo="$1" base="$2" expected_tree="$3" tree commit
  tree="$(git -C "$repo" rev-parse "$base^{tree}")"
  [ "$tree" = "$expected_tree" ] || die "base tree is $tree, expected $expected_tree"
  commit="$(git -C "$repo" commit-tree "$tree" -m snapshot)"
  git -C "$repo" update-ref refs/heads/main "$commit"
  git -C "$repo" reset --quiet --hard "$commit"
}

# Drops the remote and every upstream object, then proves none are left.
remove_source_identity() {
  local repo="$1" sha unreachable
  shift
  git -C "$repo" remote remove source
  rm -f "$repo/.git/FETCH_HEAD" "$repo/.git/ORIG_HEAD" "$repo/.git/shallow"
  git -C "$repo" reflog expire --expire=now --all
  git -C "$repo" gc --prune=now --quiet
  for sha in "$@"; do
    if git -C "$repo" cat-file -e "$sha^{commit}" 2>/dev/null; then
      die "upstream commit $sha is still reachable in $repo"
    fi
  done
  unreachable="$(git -C "$repo" fsck --unreachable --no-reflogs 2>/dev/null)"
  [ -z "$unreachable" ] || die "upstream objects are still present in $repo"
}

prepare_docs() {
  local repo="$1"
  init_repo "$repo" "$DOCS_REPO"
  fetch_commit "$repo" "$DOCS_BASE"
  snapshot_base "$repo" "$DOCS_BASE" "$DOCS_BASE_TREE"
  remove_source_identity "$repo" "$DOCS_BASE"
}

prepare_code() {
  local repo="$1" entry path expected actual paths changed tree base_commit change_commit
  init_repo "$repo" "$CODE_REPO"
  fetch_commit "$repo" "$CODE_BASE"
  fetch_commit "$repo" "$CODE_HEAD"
  snapshot_base "$repo" "$CODE_BASE" "$CODE_BASE_TREE"
  base_commit="$(git -C "$repo" rev-parse HEAD)"

  paths=()
  for entry in "${CODE_FILES[@]}"; do
    paths+=("${entry#* }")
  done

  git -C "$repo" diff --binary --full-index --no-renames "$CODE_BASE" "$CODE_HEAD" -- "${paths[@]}" \
    | git -C "$repo" apply --binary --index --whitespace=nowarn -
  changed="$(git -C "$repo" diff --cached --name-only --no-renames | LC_ALL=C sort)"
  [ "$changed" = "$(printf '%s\n' "${paths[@]}" | LC_ALL=C sort)" ] \
    || die "the code change touched unexpected paths: $changed"

  tree="$(git -C "$repo" write-tree)"
  change_commit="$(git -C "$repo" commit-tree "$tree" -p "$base_commit" -m change)"
  git -C "$repo" update-ref refs/heads/main "$change_commit"
  git -C "$repo" reset --quiet --hard "$change_commit"

  for entry in "${CODE_FILES[@]}"; do
    expected="${entry%% *}"
    path="${entry#* }"
    actual="$(git -C "$repo" show "HEAD:$path" | sha256)"
    [ "$actual" = "$expected" ] || die "$path doesn't match the pinned code change"
  done

  remove_source_identity "$repo" "$CODE_BASE" "$CODE_HEAD"
}

write_task() {
  local prompt_file="$1" out="$2" actual prompt
  actual="$(sha256 < "$prompt_file")"
  [ "$actual" = "$PROMPT_SHA256" ] \
    || die "$prompt_file has changed (Windows line endings?). Re-clone the repository and run setup again."
  prompt="$(cat "$prompt_file")"
  prompt="${prompt//\/task\/code_repo/../code}"
  printf '%s\n%s\n' "$prompt" "$NO_WEB_LINE" > "$out"
}

build_task() {
  local task="$1" env_file prompt_file target staging answer
  env_file="$LAB_DIR/tasks/$task.env"
  prompt_file="$LAB_DIR/tasks/$task.prompt.md"
  [ -f "$env_file" ] || die "unknown task '$task'. Choose pr146 or common-pr65."

  # shellcheck source=/dev/null
  . "$env_file"

  target="$DEST/$task"
  if [ -e "$target" ]; then
    if [ "$FORCE" -eq 0 ]; then
      if [ -t 0 ]; then
        printf '%s already exists. Replace it, discarding any agent edits? [y/N] ' "$target"
        read -r answer
        case "$answer" in
          y|Y|yes|YES) ;;
          *) echo "Kept $target."; return 0 ;;
        esac
      else
        die "$target already exists. Run again with --force to replace it."
      fi
    fi
  fi

  printf 'Setting up %s ...\n' "$task"
  mkdir -p "$DEST"
  staging="$DEST/.staging-$task-$$"
  rm -rf "$staging"
  mkdir -p "$staging"
  trap "rm -rf '$staging'" EXIT

  prepare_docs "$staging/docs"
  prepare_code "$staging/code"
  write_task "$prompt_file" "$staging/TASK.md"

  rm -rf "$target"
  mv "$staging" "$target"
  trap - EXIT
  printf '  done: %s\n' "$target"
}

for task in "${TASKS[@]}"; do
  build_task "$task"
done

main="${TASKS[0]}"
for task in "${TASKS[@]}"; do
  [ "$task" = pr146 ] && main=pr146
done

task_dir="$DEST/$main"
if [ "$main" = pr146 ]; then
  run_guide="step 4 in lab-01/README.md"
  show_guide="step 5 in lab-01/README.md"
else
  run_guide="lab-01/stretch/README.md"
  show_guide="lab-01/stretch/README.md"
fi

cat <<EOF

Workspaces are ready in $DEST

Your task folder is $task_dir
Next, run your agent: $run_guide.

To run the $main task with any agent, start it in $task_dir/docs
and paste everything between the two lines below as your first message.
It's also saved in $task_dir/TASK.md.

-------------------- copy from the next line --------------------
EOF
cat "$task_dir/TASK.md"
printf '\n-------------------- copy to the line above ---------------------\n'

cat <<EOF

With Claude Code or Codex, skip the paste and run one of these instead.
The agent's final reply is saved to $task_dir/my-reply.md.

Claude Code:

  cd "$task_dir/docs"
  claude -p "\$(cat "$task_dir/TASK.md")" \\
    --add-dir "$task_dir/code" --permission-mode acceptEdits \\
    --disallowedTools WebFetch WebSearch | tee "$task_dir/my-reply.md"

Codex:

  cd "$task_dir/docs"
  codex exec --sandbox workspace-write -c web_search='"disabled"' \\
    -o "$task_dir/my-reply.md" "\$(cat "$task_dir/TASK.md")"
EOF

show_cmd="\"$LAB_DIR/show-patch.sh\""
[ "$DEST" = "${HOME}/beyond-vibes-lab-01" ] || show_cmd="$show_cmd --dest \"$DEST\""
[ "$main" = pr146 ] || show_cmd="$show_cmd $main"
cat <<EOF

When the agent finishes, run this to see its changes as a page in your browser
($show_guide). It also saves them to $task_dir/my-patch.diff.

  $show_cmd
EOF
