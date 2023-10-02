SHELL := /bin/bash


GROUP_ID := $(shell id -g)

export GROUP_ID

# load docker env file
ifneq (,$(wildcard ./.docker/.env))
    include ./.docker/.env
    export
endif

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

GREEN := $(shell tput setaf 2)
RESET := $(shell tput sgr0)

## —— Help —————————————————————————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker ———————————————————————————————————————————————————————————————————
create_app: ## Creates new vue app
	@NODE_IMAGE_VERSION="${NODE_IMAGE_VERSION}" ./bin/create_app.sh

dev: ## Build & start dev image
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.dev.yml build --pull --no-cache --build-arg NODE_IMAGE_VERSION=${NODE_IMAGE_VERSION} --build-arg GROUP_ID=${GROUP_ID}
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.dev.yml up

build: ## Build prod image
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.prod.yml build --pull --no-cache --build-arg NODE_IMAGE_VERSION=${NODE_IMAGE_VERSION} --build-arg NGINX_IMAGE_VERSION=${NGINX_IMAGE_VERSION} --build-arg GROUP_ID=${GROUP_ID}
prod: build ## Build & start prod image
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.prod.yml up -d
	@echo ""
	@echo -e "App running at ${GREEN}http://localhost:${NGINX_PORT}${RESET}"
	@echo ""

stop: ## Stop the docker
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

yarn: ## Run yarn command inside container
	@$(YARN) yarn $YARN_ARGS

