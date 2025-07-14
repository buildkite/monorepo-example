#!/bin/bash

set -euo pipefail

COMMIT="${BUILDKITE_COMMIT:-}"
BASE_BRANCH="${BUILDKITE_PULL_REQUEST_BASE_BRANCH:-main}"

if [[ -z "$COMMIT" ]]; then
  echo "Missing BUILDKITE_COMMIT env var"
  exit 1
fi

BRANCH_POINT_COMMIT=$(git merge-base "$BASE_BRANCH" "$COMMIT")

echo "⚙️ Diff between $COMMIT and $BRANCH_POINT_COMMIT"

git --no-pager diff --name-only "$BRANCH_POINT_COMMIT".."$COMMIT" | \
  grep -Ev '^\.buildkite/|\.md$|^README\.md$|^LICENSE$'
