FROM adoptopenjdk/openjdk11:alpine
MAINTAINER Dwolla Engineering <dev+docker@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/docker-java"

RUN apk update && \
    apk add bash && \
    sed -i s_#networkaddress.cache.ttl=-1_networkaddress.cache.ttl=60_ /opt/java/openjdk/conf/security/java.security && \
    rm -rf /var/cache/apk/* && \
    grep ^networkaddress\\\.cache\\\.ttl=60$ /opt/java/openjdk/conf/security/java.security

USER nobody
