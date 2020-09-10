.DEFAULT_GOAL := help

.STACK := dev
.SERVICE_TO_RUN := php-fpm

.DC_BASE := docker-compose -f docker/compose
.DC := $(.DC_BASE)/$(.STACK).yml
.DC_RUN := $(.DC) run --rm $(.SERVICE_TO_RUN)
.DC_RUN_NO_DEPS := $(.DC) run --no-deps --rm $(.SERVICE_TO_RUN)

.RUN :=
.RUN_NO_DEPS :=

ifneq ($(AM_I_INSIDE_DOCKER),true)
    .RUN := $(.DC_RUN)
    .RUN_NO_DEPS := $(.DC_RUN_NO_DEPS)
endif

## -- Defaults (cross-project standards) -------------------------------------------
.PHONY: setup start stop destroy
setup: build-containers composer-install ## Setup project
start: up ## Start project
stop: down ## Stop project
destroy: down-with-volumes ## Destroy project
test: phpunit ## Run tests

## -- Container orchestration ------------------------------------------------------
build-containers: ## Build (and pull) docker containers
	$(.DC) build --pull

up: ## Bring docker containers up
	$(.DC) up

down: ## Bring docker containers down
	$(.DC) down

down-with-volumes: ## Bring docker containers down with volumes
	$(.DC) down --volumes

## -- Project initialization -------------------------------------------------------
composer-install: ## Run composer install
	$(.RUN) composer install

composer-update: ## Run composer update
	$(.RUN) composer update

create-symfony-project: ## Create symfony project with Symfony installer
	$(.RUN) symfony new . --no-git

## -- Cache ------------------------------------------------------------------------
cache-clear: ## Clear application cache
	$(.RUN) ./bin/console cache:clear

## -- Tests ------------------------------------------------------------------------
phpunit:
	$(.RUN) ./vendor/bin/phpunit

## -- Build ------------------------------------------------------------------------
build-production-images:
	docker build --pull -f docker/files/build/php-fpm/Dockerfile . -t eu.gcr.io/zoover-assignment-rafael/zoover-php-app:latest
	docker build --pull -f docker/files/build/nginx/Dockerfile . -t eu.gcr.io/zoover-assignment-rafael/zoover-php-app-nginx:latest

push-production-images-to-gcr:
	docker push eu.gcr.io/zoover-assignment-rafael/zoover-php-app:latest
	docker push eu.gcr.io/zoover-assignment-rafael/zoover-php-app-nginx:latest

authenticate-with-gcr:
	gcloud auth activate-service-account terraform@zoover-assignment-rafael.iam.gserviceaccount.com --key-file=../../secrets/google-cloud-service-acount-keyfile.json
	gcloud auth configure-docker

## -- Misc -------------------------------------------------------------------------
bash: ## Run bash in container
	$(.RUN) bash

# Based on https://suva.sh/posts/well-documented-makefiles/
help:  ## Display this help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
