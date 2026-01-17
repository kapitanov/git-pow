#!/usr/bin/env bash
set -euo pipefail

# Prevent accidental recursion
if [[ "${GIT_POW_RUNNING:-}" == "1" ]];
then
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
NONCE_FILE="$REPO_ROOT/.nonce"
START_TS="$(date +%s)"

function read_nonce() {
  if [[ -f "$NONCE_FILE" ]]; then
    if read -r VALUE < "$NONCE_FILE" && [[ "$VALUE" =~ ^[0-9]+$ ]]; then
      echo "$VALUE"
    fi
  else
    printf "0\n" > "$NONCE_FILE"
    git add "$NONCE_FILE" >/dev/null 2>&1 || true
    echo "0"
  fi
}

function write_nonce() {
  local NONCE="$1"
  printf "%s\n" "$NONCE" > "$NONCE_FILE"
  git add "$NONCE_FILE"
}

function run_pow_iteration() {
  NONCE=$((NONCE + 1))
  ITERATION=$((ITERATION + 1))

  write_nonce "$NONCE"

  GIT_POW_RUNNING=1 GIT_AUTHOR_DATE="$GIT_AUTHOR_DATE" GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE" git commit \
    --amend --no-edit --no-gpg-sign --no-verify >/dev/null
  COMMIT_HASH="$(git rev-parse HEAD)"

  printf "\033[2K\rgit-pow: %s (iteration %s)" "$COMMIT_HASH" "$ITERATION"
}

NONCE="$(read_nonce)"
GIT_AUTHOR_DATE="$(git show -s --format=%aI HEAD)"
GIT_COMMITTER_DATE="$(git show -s --format=%cI HEAD)"
LAST_PRINT_TS="0"
COMMIT_HASH="$(git rev-parse HEAD)"

ITERATION=0
while [[ ! "$COMMIT_HASH" =~ ^000 ]]; do
  run_pow_iteration
done

END_TS="$(date +%s)"
ELAPSED_SEC=$((END_TS - START_TS))
printf "\033[2K\rgit-pow: %s\n" "$COMMIT_HASH"
printf "git-pow: generated proof-of-work in %d sec\n" "$ELAPSED_SEC"
printf "git-pow: proof-of-work process took %d iterations\n\n" "$ITERATION"
