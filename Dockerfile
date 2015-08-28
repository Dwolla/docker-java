FROM java:8-jre
MAINTAINER Dwolla Engineering <dev+docker@dwolla.com>

ADD Dockerfile /Dockerfile
RUN export JAVA_HOME=$(dirname $(dirname `realpath /etc/alternatives/java`)) && \
    sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=60/ $JAVA_HOME/lib/security/java.security
