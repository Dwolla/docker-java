FROM alpine:edge
MAINTAINER Dwolla Engineering <dev+docker@dwolla.com>

RUN echo http://dl-4.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    apk --update add openjdk8-jre && \
    export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre && \
    sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=60/ $JAVA_HOME/lib/security/java.security
