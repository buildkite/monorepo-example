#!/bin/bash

set -euo pipefail

[ -z $BUILDKITE_AGENT_TOKEN ] && { echo "BUILDKITE_AGENT_TOKEN is not set."; exit 1;}

CURRENT_DIR=$(pwd)
ROOT_DIR="$( dirname "${BASH_SOURCE[0]}" )"/..
PARAMETERS=$(cat ./bin/stack-config | envsubst)

cd $ROOT_DIR

echo "downloading elastic ci stack template.."
curl -s https://s3.amazonaws.com/buildkite-aws-stack/latest/aws-stack.yml -O

aws cloudformation deploy \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-file ./aws-stack.yml \
  --stack-name "buildkite-elastic-ci" \
  --parameter-overrides $PARAMETERS

rm -f aws-stack.yml

cd $CURRENT_DIR
