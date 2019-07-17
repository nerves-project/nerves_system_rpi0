#!/usr/bin/env bash

# Create build context file
# Example:
# build-context.sh /path/to/output.json

OUTPUT="$1"
FW="$2"

[ -n "$FW" ] || FW=$(ls ./_build/*/nerves/images/*.fw 2> /dev/null | head -n 1)

FW_METADATA=$(fwup -m -i $FW | jq -n -R 'reduce inputs as $i ({}; . + ($i | (match("([^=]*)=\"(.*)\"") | .captures | {(.[0].string) : .[1].string})))')
BUILD_CONTEXT=$(echo "{}" | jq '{
  "repo_sha" : env.CIRCLE_SHA1,
  "repo_name" : env.CIRCLE_PROJECT_REPONAME,
  "repo_org" : env.CIRCLE_PROJECT_USERNAME,
  "repo_branch" : env.CIRCLE_BRANCH,
  "repo_pr" : env.CIRCLE_PULL_REQUEST,
  "ci" : "circleci",
  "ci_build_number" : env.CIRCLE_BUILD_NUM,
  "ci_build_url" : env.CIRCLE_BUILD_URL
}')

echo "$FW_METADATA $BUILD_CONTEXT" | jq -s add >> $OUTPUT
