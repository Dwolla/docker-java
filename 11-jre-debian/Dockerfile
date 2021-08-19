FROM eclipse-temurin:11 as jre-build

# Create a custom Java runtime
RUN $JAVA_HOME/bin/jlink \
         --add-modules java.base \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

# Define your base image
FROM debian:buster-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME

RUN apt-get update && \
    apt-get install -y bash && \
    sed -i s_#networkaddress.cache.ttl=-1_networkaddress.cache.ttl=60_ /opt/java/openjdk/conf/security/java.security && \
    apt-get clean && \
    grep ^networkaddress\\\.cache\\\.ttl=60$ /opt/java/openjdk/conf/security/java.security

USER nobody
