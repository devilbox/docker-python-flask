ifneq (,)
.error This Makefile requires GNU Make.
endif

# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
.PHONY: build


# -------------------------------------------------------------------------------------------------
# Docker configuration
# -------------------------------------------------------------------------------------------------
DIR = .
FILE = Dockerfile
IMAGE = devilbox/python-flask
NO_CACHE =
PYTHON = 3.8


# -------------------------------------------------------------------------------------------------
# Default target
# -------------------------------------------------------------------------------------------------
help:
	@echo "build        Build Docker image"
	@echo "test         Test Docker image"


# -------------------------------------------------------------------------------------------------
# Common Targets
# -------------------------------------------------------------------------------------------------
build:
	docker build \
		--label "org.opencontainers.image.created"="$$(date --rfc-3339=s)" \
		--label "org.opencontainers.image.revision"="$$(git rev-parse HEAD)" \
		--label "org.opencontainers.image.version"="$(PYTHON)-dev" \
		--target dev \
		--build-arg ALPINE= \
		--build-arg PYTHON=$(PYTHON) \
		-t $(IMAGE) \
		-f $(DIR)/Dockerfile $(DIR)
	@$(MAKE) --no-print-directory tag TAG=$(PYTHON)-dev


test:
	docker run --rm $(IMAGE):$(PYTHON)-dev python --version 2>&1 | grep -E 'Python $(PYTHON)[.0-9]+'
	.tests/test-project.sh "$(IMAGE)" "$(PYTHON)"


# -------------------------------------------------------------------------------------------------
# CI Targets
# -------------------------------------------------------------------------------------------------
tag:
	@if [ "$(TAG)" = "" ]; then \
		>&2 echo "Error, you must specify TAG=..."; \
		exit 1; \
	fi
	docker tag $(IMAGE) $(IMAGE):$(TAG)
	docker images "$(IMAGE)"


login:
	yes | docker login --username $(USER) --password $(PASS)


push: tag
	docker push $(IMAGE):$(TAG)
