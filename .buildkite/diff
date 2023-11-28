#!/bin/bash

[ $# -lt 1 ] && { echo "argument is missing."; exit 1; }

COMMIT=$1

BRANCH_POINT_COMMIT=$(git merge-base master $COMMIT)

echo "diff between $COMMIT and $BRANCH_POINT_COMMIT"
git --no-pager diff --name-only $COMMIT..$BRANCH_POINT_COMMIT
