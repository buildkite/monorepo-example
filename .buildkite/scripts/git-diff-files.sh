#!/bin/bash

set -euo pipefail

COMMIT="${BUILDKITE_COMMIT:-}"
BASE_BRANCH="${BUILDKITE_PULL_REQUEST_BASE_BRANCH:-main}"

if [[ -z "$COMMIT" ]]; then
  echo "❌ Missing BUILDKITE_COMMIT env var"
  exit 1
fi

BRANCH_POINT_COMMIT=$(git merge-base "$BASE_BRANCH" "$COMMIT")

echo "⚙️ Diff between $COMMIT and $BRANCH_POINT_COMMIT"

CHANGED_FILES=$(git --no-pager diff --name-only "$BRANCH_POINT_COMMIT".."$COMMIT" | \
  grep -Ev '^\.buildkite/|\.md$|^README\.md$|^LICENSE$' || true)

if [[ -z "$CHANGED_FILES" ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ No changes detected!"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "No triggering of pipelines was necessary."
  echo ""
  buildkite-agent annotate "✅ No changes detected - no pipelines triggered." --style "info"
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Changes detected in:"
echo "$CHANGED_FILES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
