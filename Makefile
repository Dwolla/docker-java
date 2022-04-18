TEMURIN_TAGS := 8u322-b06-jdk 11.0.14.1_1-jdk 8u322-b06-jre 11.0.14.1_1-jre
JOBS := $(addprefix temurin-,${TEMURIN_TAGS})
CHECKS := $(addprefix check-,${TEMURIN_TAGS})
CLEAN := $(addprefix clean-,${TEMURIN_TAGS})

all: ${JOBS}
check: ${CHECKS}
clean: ${CLEAN}
.PHONY: all check clean ${JOBS} ${CHECKS} ${CLEAN}

${JOBS}: temurin-%: Dockerfile
	docker build \
	  --build-arg TEMURIN_TAG=$* \
	  --tag dwolla/docker-java:$*-SNAPSHOT \
	  .

${CHECKS}: check-%:
	grep --silent "^          - $*$$" .github/workflows/ci.yml

${CLEAN}: clean-%:
	docker rmi dwolla/docker-java:$*-SNAPSHOT --force