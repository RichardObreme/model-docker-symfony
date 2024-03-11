# Variables
DOCKER_COMPOSE = docker compose
EXEC = $(DOCKER_COMPOSE) exec www
SYMFONY_CONSOLE = $(EXEC) php bin/console

## —— 🐳 Docker ——
create: ## Create the Symfony project
	$(MAKE) start
	composer create-project symfony/skeleton:"7.0.*" app
	cd app
	composer require webapp

start: ## Start app
	$(DOCKER_COMPOSE) up -d

stop: ## Stop app
	$(DOCKER_COMPOSE) stop

down:  ## Stop app and discard containers & networks
	$(DOCKER_COMPOSE) down

terminal:  ## Launch an interactive terminal in the container
	$(EXEC) /bin/bash

chown: ## Give all permission on the project's files to the current user and group www-data. 
	sudo chown -R ${USER:=$(/usr/bin/id -run)}:www-data ./app

## —— 🔥 App ——
cache-clear: ## Clear cache
	$(SYMFONY_CONSOLE) cache:clear

migration: ## Make migration
	$(SYMFONY_CONSOLE) make:migration

migrate: ## Migrate migrations
	$(SYMFONY_CONSOLE) d:m:m --no-interaction

## —— 🐈 NPM ——
npm-watch: ## Run npm watch
	$(EXEC) npm run watch

## —— 🛠️  Others ——
help: ## List of commands
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
