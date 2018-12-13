#!/usr/bin/env bash

# Retreive the URL of the location for artifacts beginning with the path

# Example:
# primary-site.sh dl
# https://726-55319430-gh.circle-artifacts.com/0/dl

ARTIFACT_PATH="$1"

API_URL="https://circleci.com/api/v1.1/project/github/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME?circle-token=$CIRCLE_TOKEN&limit=25&filter=successful"

LAST_SUCCESSFUL_JOB=$(curl -s -H "Accept: application/json" "$API_URL" | jq --arg CIRCLE_JOB "$CIRCLE_JOB" 'reduce .[] as $i ([]; if ($i | .build_parameters[]) == $CIRCLE_JOB then . + [$i] else . end) | first')

if [ -n "$LAST_SUCCESSFUL_JOB" ]; then
  BUILD_NUMBER=$(echo "$LAST_SUCCESSFUL_JOB" | jq '.build_num')

  API_URL="https://circleci.com/api/v1.1/project/github/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/$BUILD_NUMBER/artifacts?circle-token=$CIRCLE_TOKEN"
  ARTIFACTS=$(curl -s -H "Accept: application/json" "$API_URL" | jq -s '.[]')

  ARTIFACT=$(echo "$ARTIFACTS" | jq --arg ARTIFACT_PATH "$ARTIFACT_PATH" '[.[] | select(.path | startswith("dl"))] | first')
  if [ -n "$ARTIFACT" ]; then
    PRIMARY_SITE=$(echo "$ARTIFACT" | jq -r '.url' | sed 's/'"$ARTIFACT_PATH"'.*$/'"$ARTIFACT_PATH"'/')
    echo "$PRIMARY_SITE"
  fi
else
  echo "No eligible jobs found"
  echo ""
fi
