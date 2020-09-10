## -- Defaults ------------------------------------------
first-time-setup: ## Run only once per setup
	cd terraform && make setup
	cd kubernetes && make first-time-setup

setup: ## Configure and deploy everything (infrastructure with terraform, building apps and push images, deploy with Kubernetes)
	cd terraform && make setup
	cd apps && make setup
	cd kubernetes && make deploy

destroy: ## Destroy everything (deployed applications, infrastructure in Google Cloud and application resources) in reverse order, so it's like you never did anything with this project
	cd kubernetes && make destroy
	cd apps && make destroy
	cd terraform && make destroy

deploy: ## Deploy applications (app1 and app2, and secure proxy)
	cd kubernetes && make deploy

undeploy: ## Undeploy applications (app1 and app2, and secure proxy)
	cd kubernetes && make undeploy-apps

redeploy: ## Redeploy applications (app1 and app2, and secure proxy)
	cd kubernetes && make redeploy

apply-infrastructure-changes: ## Apply any terraform changes to the Google Cloud infrastructure
	cd terraform && make apply

rebuild-and-push-app-images: ## Grab updates in the code from applications, rebuild images and push latest versions
	cd apps && make setup

refresh: apply-infrastructure-changes rebuild-and-push-app-images redeploy ## Apply infrastructure changes, grab application changes and redeploy applications

## -- Additional ----------------------------------------

# Based on https://suva.sh/posts/well-documented-makefiles/
help:  ## Display this help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


