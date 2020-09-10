.ENVIRONMENT := gke

## -- Default commands --------------------------------------------------------------------
first-time-setup: get-gke-credentials-for-kubectl install-cert-manager install-cert-manager-plugin add-helm-repositories
first-time-local-setup: first-time-setup install-contour add-hosts-entry-for-local-ingress
deploy: deploy-helm-chart deploy-jenkins
redeploy: delete-jenkins delete-helm-chart deploy-helm-chart deploy-jenkins
destroy: delete-helm-chart uninstall-cert-manager uninstall-contour
undeploy-apps: delete-helm-chart

## -- Deploy apps -------------------------------------------------------------------------
deploy-helm-chart:
	helm upgrade --install -f environment/$(.ENVIRONMENT)/proxied-apps-values.yaml -f ../secrets/proxied-apps-values.yaml zoover-chart proxied-apps

delete-helm-chart:
	helm uninstall zoover-chart || true

describe-app1: ## Describe app1
	kubectl describe deployment app1
	kubectl describe service app1

describe-app2: ## Describe app2
	kubectl describe deployment app2
	kubectl describe service app2

## -- Jenkins --------------------------------------------------------------------
deploy-jenkins:
	helm upgrade --install -f environment/$(.ENVIRONMENT)/jenkins-values.yaml -f ../secrets/jenkins-values.yaml jenkins jenkinsci/jenkins

delete-jenkins:
	helm uninstall jenkins || true

## -- Ingress --------------------------------------------------------------------
deploy-ingress: ## Deploy ingress with TLS and https redirect
	kubectl apply -f proxied-apps/templates/proxy/ingress.yaml

delete-ingress: ## Delete ingress
	kubectl delete -f proxied-apps/templates/proxy/ingress.yaml

describe-ingress: ## Describe ingress
	kubectl describe ingress zoover-ingress

## -- Contour ingress --------------------------------------------------------------------
install-contour: ## Install contour ingress controller
	kubectl apply -f https://j.hept.io/contour-deployment-rbac

uninstall-contour: ## Uninstall contour ingress controller from cluster
	kubectl delete -f https://j.hept.io/contour-deployment-rbac || true

get-contour-address: ## Get contour ingress information
	kubectl get -n projectcontour service contour -o wide

add-hosts-entry-for-local-ingress: ## Add entry in /etc/hosts in local environment for ingress host
	sudo echo "127.0.0.1 zoover.devops.raff\n" >> /etc/hosts

## -- Cert-manager --------------------------------------------------------------------
install-cert-manager: ## Install cert-manager in Kubernetes
	kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.1/cert-manager.yaml

uninstall-cert-manager: ## Uninstall cert-manager from cluster
	kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.0.1/cert-manager.yaml || true

install-cert-manager-plugin: ## Install cert-manager plugin locally
	sh -c "curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v1.0.1/kubectl-cert_manager-darwin-amd64.tar.gz \
     && tar xzf kubectl-cert-manager.tar.gz \
     && mv kubectl-cert_manager /usr/local/bin \
     && rm kubectl-cert-manager.tar.gz \
     && rm LICENSES"

test-cert-manager-plugin: ## Run help command in cert-manager plugin
	kubectl cert-manager help

get-cert-manager-pods: ## Get cert-manager pods to verify health
	kubectl get pods --namespace cert-manager

test-cert-manager: ## Test cert-manager functionality by creating and removing test resources
	kubectl apply -f test/cert-manager/test-resources.yaml
	kubectl describe certificate -n cert-manager-test
	kubectl delete -f test/cert-manager/test-resources.yaml

## -- Certificates --------------------------------------------------------------------
create-self-signed-issuer: ## Create self-signed issuer cert-manager object
	kubectl apply -f cluster/default/issuer-self-signed.yaml

get-self-signed-issuer: ## Get self-signed issuer resources
	kubectl get issuers selfsigned-issuer -n default -o wide

create-letsencrypt-issuer: ## Create letsencrypt issuer cert-manager object
	kubectl apply -f cluster/default/issuer-letsencrypt.yaml

get-letsencrypt-issuer: ## Get letsencrypt issuer resources
	kubectl get issuers zoover-letsencrypt-staging -n default -o wide

get-letsencrypt-issuer-production: ## Get letsencrypt issuer resources
	kubectl get issuers zoover-letsencrypt-production -n default -o wide

## -- Misc --------------------------------------------------------------------
describe-node: ## Describe node
	kubectl describe node

get-ingress: ## Get ingress information
	kubectl get ingress

## -- Helm --------------------------------------------------------------------
add-helm-repositories:
	helm repo add jenkinsci https://charts.jenkins.io
	helm repo update

## -- GKE-- -------------------------------------------------------------------------------
get-gke-credentials-for-kubectl: ## Get GKE credentials with google-cloud-sdk and already sets it up in kubectl
	gcloud auth activate-service-account terraform@zoover-assignment-rafael.iam.gserviceaccount.com --key-file=../secrets/google-cloud-service-acount-keyfile.json
	gcloud container clusters get-credentials zoover-assignment-gke --zone=europe-west4-b --project=zoover-assignment-rafael

# Based on https://suva.sh/posts/well-documented-makefiles/
help:  ## Display this help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
