FROM eclipse-temurin:11
MAINTAINER Dwolla Engineering <dev+docker@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/docker-java"

RUN apt-get update && \
    apt-get install -y bash && \
    sed -i s_#networkaddress.cache.ttl=-1_networkaddress.cache.ttl=60_ /opt/java/openjdk/conf/security/java.security && \
    apt-get clean && \
    grep ^networkaddress\\\.cache\\\.ttl=60$ /opt/java/openjdk/conf/security/java.security

USER nobody
