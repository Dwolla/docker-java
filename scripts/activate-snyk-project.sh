#!/usr/bin/env bash

IMAGE_ID=$1
TAG=$2
COMMIT_HASH=$3
TAG_WITH_COMMIT_HASH="dwolla/$IMAGE_ID:$TAG-$COMMIT_HASH"

function get_integrations() {
     curl \
    --silent \
    -H "Authorization: token $SNYK_TOKEN" \
    https://snyk.io/api/v1/org/dwolla/integrations   
}

function get_snyk_projects() {
    curl \
    --silent \
    -H "Authorization: token $SNYK_TOKEN" \
    https://snyk.io/api/v1/org/dwolla/projects
}

function activate_snyk_project() {
    PROJECT_ID=$1
    curl \
    -X POST \
    --silent \
    -H "Authorization: token $SNYK_TOKEN" \
    https://snyk.io/api/v1/org/dwolla/project/"$PROJECT_ID"/activate \
    > /dev/null
}


function import_snyk_project() {
    INTEGRATION_ID=$1
    curl \
    -X POST \
    --silent \
    https://snyk.io/api/v1/org/dwolla/integrations/"$INTEGRATION_ID"/import \
    -H "Authorization: token $SNYK_TOKEN" -H "Content-Type: application/json" \
    -d '{"target": {"name": "'"$TAG_WITH_COMMIT_HASH"'"}}' \
    > /dev/null
}

DOCKERHUB_INTEGRATION_ID=$(get_integrations | jq -r '.["docker-hub"]')
import_snyk_project "$DOCKERHUB_INTEGRATION_ID"

echo "Looking for Snyk project with name $TAG_WITH_COMMIT_HASH..."
for (( counter=1; counter<=10; counter++ ))
do  
    SNYK_PROJECT_ID=$(get_snyk_projects | jq -c -r --arg IMAGE_NAME "$TAG_WITH_COMMIT_HASH" '.projects[] | select( .name==$IMAGE_NAME ).id')
    if [ -n "$SNYK_PROJECT_ID" ]; then
    activate_snyk_project "$SNYK_PROJECT_ID"
    echo "Successfully activated Snyk monitoring for $TAG_WITH_COMMIT_HASH with project id $SNYK_PROJECT_ID."
    exit 0
    fi
    if [ "$counter" -lt 10 ]; then
    echo "Not found: sleeping 30s then retrying..."
    sleep 30
    fi
done

echo "No snyk project found for $TAG_WITH_COMMIT_HASH, import job may have failed."
exit 99