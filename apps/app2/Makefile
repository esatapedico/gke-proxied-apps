.DEFAULT_GOAL:=help

.RUN := pipenv run

## -- Defaults (cross-project standards) -------------------------------------------
start: run-app
start-containerized: run-app-docker
setup: create-env-from-lockfile copy-secrets-dist ## Setup environment and dependencies (including dev)
destroy: remove-env ## Remove environment with dependencies
test: nose-tests ## Run tests
qa: vulnerabilities-check black-formatter flake8-logical-check ## Run vulnerabilities check, code formatter and logical test
ci: create-env-from-lockfile vulnerabilities-check black-formatter-dry-run flake8-logical-check test ## Setup environment and dependencies (including dev), run vulnerabilities check, code style and logical analysis, run tests

## -- Project initialization -------------------------------------------------------
create-env-from-lockfile: ## Setup environment and dependencies (including dev)
	pipenv sync --dev

recreate-env: remove-env create-env-from-lockfile ## Remove existing environment, setups new environment and dependencies (including dev)

remove-env: ## Remove existing environment
	pipenv --rm

update-dependencies: ## Update dependencies (including dev)
	pipenv update --dev

## -- App --------------------------------------------------------------------------
run-app:
	cd src && pipenv run flask run --host=0.0.0.0 --port=5005

run-app-docker:
	docker-compose -f docker/compose/build.yml up

## -- Tests ------------------------------------------------------------------------
nose-tests: ## Run nose2 tests
	$(.RUN) nose2 -v

## -- QA ---------------------------------------------------------------------------
black-formatter: ## Run black code formatter
	$(.RUN) black ./src ./tests

black-formatter-dry-run: ## Run black formatter in check-only mode
	$(.RUN) black ./src ./tests --check

vulnerabilities-check: ## Check for vulnerabilities in the code and dependencies.
	pipenv check

flake8-logical-check: ## Run code logic analyser flake8
	$(.RUN) flake8 ./src ./tests

## -- Build ------------------------------------------------------------------------
build-production-images:
	docker build --pull -f docker/files/build/python/Dockerfile . -t eu.gcr.io/zoover-assignment-rafael/zoover-python-app:latest
	docker build --pull -f docker/files/build/nginx/Dockerfile . -t eu.gcr.io/zoover-assignment-rafael/zoover-python-app-nginx:latest

push-production-images-to-gcr:
	docker push eu.gcr.io/zoover-assignment-rafael/zoover-python-app:latest
	docker push eu.gcr.io/zoover-assignment-rafael/zoover-python-app-nginx:latest

authenticate-with-gcr:
	gcloud auth activate-service-account terraform@zoover-assignment-rafael.iam.gserviceaccount.com --key-file=../../secrets/google-cloud-service-acount-keyfile.json
	gcloud auth configure-docker


## -- Misc -------------------------------------------------------------------------
shell-pipenv: ## Activate existing pipenv
	pipenv shell

copy-secrets-dist: ## copies dist files to set personal secrets in
	cp -n src/conf/secrets.ini.dist src/conf/secrets.ini || true

# Based on https://suva.sh/posts/well-documented-makefiles/
help:  ## Display this help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
