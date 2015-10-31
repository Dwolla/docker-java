# Dwolla Java Base Image

Starting from `alpine:edge` and installing the Alpine `openjdk8-jre` community package, the `Dockerfile` modifies the JRE’s `java.security` settings to set the DNS TTL to 60 seconds.

## Dependencies
1. Run bundler to install any needed gems.

        bundle install
2. `DOCKER_HOST` must point to a valid Docker instance.

## Test and Build

    rake

## Publish

    rake publish

Set the `DOCKER_REPOSITORY` environment variable to publish to a repository other than the default ([docker.sandbox.dwolla.net](https://docker.sandbox.dwolla.net/ui)).

## Clean

    rake clean

Removes the image and any test artifacts which also might be added to your local Docker repository.
