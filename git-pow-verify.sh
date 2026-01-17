#!/usr/bin/env bash
set -euo pipefail

for COMMIT in "$(git log --format=%H)"; do
    printf "%s: " "$COMMIT"
    if [[ ! "$COMMIT" =~ ^000 ]]; then
        printf "FAIL\nProof of Work verification failed for commit '%s'\nExpected commit hash to start with '000'\n" "$COMMIT"
        exit 1
    fi

    printf "OK\n"
done

printf "All commits have valid Proof of Work\n"
