# this makefile requires yq be installed! brew install yq
TEMURIN_TAGS := $(shell yq -r '.jobs.build.strategy.matrix.temurin_tag | .[]' .github/workflows/ci.yml | tr '\n' ' ')
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
