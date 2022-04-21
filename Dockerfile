ARG TEMURIN_TAG

FROM eclipse-temurin:$TEMURIN_TAG

MAINTAINER Dwolla Engineering <dev+docker@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/docker-java"

RUN if [ -f "$JAVA_HOME/jre/lib/security/java.security" ] ; then \
        SECURITY_FILE_PATH=$JAVA_HOME/jre/lib/security/java.security ; \
    elif [ -f "$JAVA_HOME/lib/security/java.security" ] ; then \
        SECURITY_FILE_PATH=$JAVA_HOME/lib/security/java.security ; \
    elif [ -f "$JAVA_HOME/conf/security/java.security" ] ; then \
        SECURITY_FILE_PATH=$JAVA_HOME/conf/security/java.security ; \
    else \
        echo 'java.security file path not found' ; \
        exit 98 ; \
    fi && \
    apt-get update && \
    apt-get install -y bash && \
    sed -i s_#networkaddress.cache.ttl=-1_networkaddress.cache.ttl=60_ $SECURITY_FILE_PATH && \
    sed -i s_securerandom.source=file:/dev/random_securerandom.source=file:/dev/./urandom_ $SECURITY_FILE_PATH && \
    apt-get clean && \
    grep ^networkaddress\\\.cache\\\.ttl=60$ $SECURITY_FILE_PATH && \
    grep ^securerandom\\\.source=file:/dev/\\\./urandom$ $SECURITY_FILE_PATH \
