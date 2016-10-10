# Dwolla Java Base Image

Starting from the official [`openjdk`](https://github.com/docker-library/openjdk) images, these `Dockerfile`s modify each JRE’s `java.security` settings to set the DNS TTL to 60 seconds and to [use `/dev/urandom`* as an entropy source](http://www.2uo.de/myths-about-urandom/).

_* Actually, it's using `/dev/./urandom` instead of `/dev/urandom`. This is the same thing, but it's working around a [“feature” of the JRE](https://bugs.openjdk.java.net/browse/JDK-6202721) that looks for the string `/dev/urandom` and switches it back to `/dev/random`. The only references to that behavior I can find are for Java 5 and 6, but in an abundance of caution, we're working around it in these Java 8 images too._
