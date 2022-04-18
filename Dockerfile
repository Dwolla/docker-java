ARG TEMURIN_TAG

FROM eclipse-temurin:$TEMURIN_TAG

ARG TEMURIN_TAG
MAINTAINER Dwolla Engineering <dev+docker@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/docker-java"

RUN if [ "$TEMURIN_TAG" = "8u322-b06-jdk" ] ; then \
    SECURITY_FILE_PATH=$JAVA_HOME/jre/lib/security/java.security ; \
    elif [ "$TEMURIN_TAG" = "8u322-b06-jre" ] ; then \
    SECURITY_FILE_PATH=$JAVA_HOME/lib/security/java.security ; \
    else \
    SECURITY_FILE_PATH=$JAVA_HOME/conf/security/java.security; \
    fi && \
    apt-get update && \
    apt-get install -y bash && \
    sed -i s_#networkaddress.cache.ttl=-1_networkaddress.cache.ttl=60_ $SECURITY_FILE_PATH && \
    sed -i s_securerandom.source=file:/dev/random_securerandom.source=file:/dev/./urandom_ $SECURITY_FILE_PATH && \
    apt-get clean && \
    grep ^networkaddress\\\.cache\\\.ttl=60$ $SECURITY_FILE_PATH && \
    grep ^securerandom\\\.source=file:/dev/\\\./urandom$ $SECURITY_FILE_PATH \
