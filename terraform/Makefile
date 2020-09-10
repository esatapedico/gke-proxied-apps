.RUN_TERRAFORM := docker-compose run --rm terraform
.RUN_GOOGLE_CLOUD := docker-compose run --rm google-cloud-sdk

## -- Defaults ------------------------------------------
setup: init apply

init:
	$(.RUN_TERRAFORM) init

plan:
	$(.RUN_TERRAFORM) plan

plan-destruction:
	$(.RUN_TERRAFORM) plan -destroy

apply:
	$(.RUN_TERRAFORM) apply

destroy:
	$(.RUN_TERRAFORM) destroy

shell-terraform:
	docker-compose run --rm --entrypoint=bash terraform

## -- Additional ----------------------------------------

# Based on https://suva.sh/posts/well-documented-makefiles/
help:  ## Display this help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

