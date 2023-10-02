SHELL := /bin/bash

NODE_IMAGE_VERSION=18.18.0-alpine3.18
NGINX_IMAGE_VERSION=1.24.0-alpine3.17
GROUP_ID := $(shell id -g)

export GROUP_ID

# If the first argument is "yarn"...
ifeq (yarn,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "build"
  YARN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(YARN_ARGS):;@:)
endif

# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
APP_CONT = $(DOCKER_COMP) exec -it app

# Executables
YARN     = $(APP_CONT) yarn

# Misc
.DEFAULT_GOAL = help
.PHONY        = help create_app dev build down logs

## —— Help —————————————————————————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker ———————————————————————————————————————————————————————————————————
create_app: ## Creates new vue app
	@NODE_IMAGE_VERSION="${NODE_IMAGE_VERSION}" ./bin/create_app.sh

dev: ## Build dev Docker image & output logs
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.dev.yml build --pull --no-cache --build-arg NODE_IMAGE_VERSION=${NODE_IMAGE_VERSION} --build-arg GROUP_ID=${GROUP_ID}
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.dev.yml up

build: ## Builds prod Docker image
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.prod.yml build --pull --no-cache --build-arg NODE_IMAGE_VERSION=${NODE_IMAGE_VERSION} --build-arg NGINX_IMAGE_VERSION=${NGINX_IMAGE_VERSION} --build-arg GROUP_ID=${GROUP_ID}
prod: build ## Build & start prod image
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.prod.yml up -d

down: ## Stop the docker
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

yarn: ## Run yarn command inside container
	@$(YARN) yarn $YARN_ARGS

