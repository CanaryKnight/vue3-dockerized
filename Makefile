# If the first argument is "build"...
ifeq (build,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "build"
  BUILD_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(BUILD_ARGS):;@:)
endif

# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
APP_CONT = $(DOCKER_COMP) exec app

# Executables
YARN     = $(APP_CONT) yarn

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh composer vendor sf cc create_vue

## —— Help —————————————————————————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker ———————————————————————————————————————————————————————————————————
create_app: ## Creates new vue app
	@./bin/create_app.sh
	#@$(DOCKER_COMP) -f docker-compose.yml -f docker-compose.dev.yml build --pull --no-cache

dev: ## Build dev Docker images & output logs
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.dev.yml build --pull --no-cache --build-arg UID=$(id -u) --build-arg GID=$(id -g)
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.dev.yml up

build: ## Builds prod Docker images
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.prod.yml build --pull --no-cache

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

