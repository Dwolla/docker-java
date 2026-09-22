# this makefile requires jq be installed! brew install jq
TEMURIN_TAGS := $(shell jq -r '.[]' temurin-tags.json | tr '\n' ' ')
JOBS := $(addprefix temurin-,${TEMURIN_TAGS})
CLEAN := $(addprefix clean-,${TEMURIN_TAGS})

all: ${JOBS}
clean: ${CLEAN}
.PHONY: all check clean ${JOBS} ${CLEAN}

check:
	jq -e 'type == "array" and length > 0 and all(type == "string")' temurin-tags.json > /dev/null

${JOBS}: temurin-%: Dockerfile
	docker build \
	  --build-arg TEMURIN_TAG=$* \
	  --tag dwolla/docker-java:$*-SNAPSHOT \
	  .

${CLEAN}: clean-%:
	docker rmi dwolla/docker-java:$*-SNAPSHOT --force
