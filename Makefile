include .env

# Variables
DOCKER_COMPOSE = docker compose
EXEC = $(DOCKER_COMPOSE) exec www
SYMFONY_CONSOLE = $(EXEC) php bin/console
COMPOSER = $(EXEC) composer

## —— Docker 🐳 ——
start: ## Start app
	$(DOCKER_COMPOSE) up -d

stop: ## Stop app
	$(DOCKER_COMPOSE) stop

down:  ## Stop app and discard containers & networks
	$(DOCKER_COMPOSE) down

terminal:  ## Launch an interactive terminal in the container
	$(EXEC) /bin/bash

chown: ## Give all permission on the project's files to the current user and group www-data. 
	sudo chown -R ${USER:=$(/usr/bin/id -run)}:www-data ./${PROJECT_DIR}

## —— App 💻 ——
create-skeleton: ## Create a minimal Symfony Project (microservice, API, ...)
	$(MAKE) start
	$(COMPOSER) create-project symfony/skeleton:"${SYMFONY_VERSION}" ./

create-full: ## Create Webapp Symfony project
	$(MAKE) create-skeleton
	$(COMPOSER) require webapp --no-interaction

init: ## Initialize an existing project
	$(MAKE) start
	$(COMPOSER) install

cache-clear: ## Clear the cache in Symfony
	$(SYMFONY_CONSOLE) cache:clear

## —— Database 📊 ——
db-create: ## Create DataBase
	$(SYMFONY_CONSOLE) d:d:c --if-not-exists

db-drop: ## Delete DataBase
	$(SYMFONY_CONSOLE) d:d:d --force --if-exists

migration: ## Make migration
	$(SYMFONY_CONSOLE) make:migration

migrate: ## Migrate migrations
	$(SYMFONY_CONSOLE) d:m:m --no-interaction

fixtures: ## Load fixtures
	$(SYMFONY_CONSOLE) d:f:l --no-interaction

db-init: ## (Re)Initialize an existing DataBase
	$(MAKE) db-drop
	$(MAKE) db-create
	$(MAKE) migrate

db-init-fixtures: ## (Re)Initialize an existing DataBase with fixtures
	$(MAKE) db-init
	$(MAKE)	fixtures

## —— NPM 🔧 ——
npm-watch: ## Run npm watch
	$(EXEC) npm run watch

## —— Others 🛠️ ——
help: ## List of commands
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
