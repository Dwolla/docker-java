# Dwolla Java Base Image

Starting from the official [`java:8-jre`](https://github.com/docker-library/java/blob/master/openjdk-8-jre/Dockerfile) image, the `Dockerfile` modifies the JRE’s `java.security` settings to set the DNS TTL to 60 seconds.

CI will publish this image as `docker.dwolla.com/dwolla/java:8`.

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
