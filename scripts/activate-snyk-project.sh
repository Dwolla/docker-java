#!/usr/bin/env bash

SNYK_TOKEN=$1
IMAGE_ID=$2
TAG=$3
COMMIT_HASH=$4
TAG_WITH_COMMIT_HASH="dwolla/$IMAGE_ID:$TAG-$COMMIT_HASH"

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

echo "Looking Snyk project with name $TAG_WITH_COMMIT_HASH..."
SNYK_PROJECT_ID=$(get_snyk_projects | jq -c -r --arg IMAGE_NAME "$TAG_WITH_COMMIT_HASH" '.projects[] | select( .name==$IMAGE_NAME ).id')

if [ -z "$SNYK_PROJECT_ID" ]
then
echo "No snyk project found for $TAG_WITH_COMMIT_HASH."
exit 99
else
activate_snyk_project "$SNYK_PROJECT_ID"
echo "Successfully turned on Snyk monitoring for $TAG_WITH_COMMIT_HASH with project id $SNYK_PROJECT_ID."
fi
