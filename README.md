## Zoover DevOps

In real-life the code from this repository would be distributed among a few other
repositories, such as one for each application, for instance.

### Decisions and considerations

The project was challenging in the way that the most of my experience goes around AWS with Elastic Container Service,
as well as plain Docker Swarm from scratch. My experience with both Kubernetes and Google Cloud Platform was not extensive,
and I needed to spend quite a bit longer than expected on the respective documentations.

The general architecture, with comments, goes with:

#### Applications

One application is in PHP 7.4 (latest version) with the latest version of Symfony framework. As starting point I used a 
skeleton project that I took part on creating, with several individual improvements I did on it ever since. Implementing
it went very quickly and straightforward. The highlight is the included dev environment powered by Docker with
docker-compose, which was mostly designed by me.

The other application is a basic Python application with flask framework. I used a skeleton project on the same lines as
the PHP one above.

Each application has a Makefile with setup, build, startup and qa tasks. They're used from top-level project tasks.

#### Google Cloud + GKE

For setting up Google Cloud I used Terraform 0.13 (latest version at the time). I applied good practices on project
structure that would do well for if its scope would expand, though not really needed for the size of what we have. I
used standard Terraform resources from the Google Cloud provider for static ips and docker registry setup, and official
modules for setting up the VPC and GKE cluster and node pool.

Google Cloud project, billing and service account were create manually in the console in advance.

Given more time and longer project life, versioning would have been stricter and the terraform state would have a more
robust backend to address safer locking and avoid conflicts.

A Makefile encapsulates the most common terraform tasks, powered by a Docker + docker-compose dev environment.

#### Kubernetes

I wrote the deployment and service code for the applications individually. Later I packaged them up in a single Helm
chart along with an ingress resource that proxied the requests to /app1 and /app2. For secure access I used the
cert-manager certificate management controller.

First I tested it in a local Kubernetes cluster, for which I installed a Contour ingress controller and used a
self-signed certificate. Later I got that into GKE and parameterized the ingress object to use the GCE native ingress.

Unfortunately I could not get the certificate issued through letsencrypt with the almost-free cheap domain I bought in
namecheap.com, since it does not support dns01 challenges. I tried http01, but got issues and couldn't get that done on
time. For what I see a domain issued and managed by Google Cloud DNS would have worked seamlessly.

For the environments, I set helm value files per environments, and a "secret" one in the secrets directory to emulate
proper secret management - for which there wasn't enough time and resources.

A Makefile also ships in with all relevant task definitions.

### Structure

The project consists of the following:

- `apps`: contains the code for both applications, including tests and deployment pipelines (Jenkinsfiles)
- `terraform`: basic provisioning code for setting up Google Cloud with Google Kubernetes Engine (GKE) and
Container Registry.
- `kubernetes`: code setting up, deploying and exposing the applications and services `proxied-apps`, `prometheus`,
`jenkins`, as well as an `environment` directory for env-specific helm values, and a `test` directory for tests.
- `docs`: additional documentation

### How to use

The standard commands are listed and can be executed from the `Makefile` in the root
of the project. Each individual moving part has its own `Makefile` as well, and higher
level Makefiles may execute commands in lower level Makefiles.

### Quick start

1. Make sure you have Google Cloud account with billing enabled.
2. Create a project manually through the Google Cloud console.
3. Create a service-account user with the following roles (see https://github.com/terraform-google-modules/terraform-google-kubernetes-engine#configure-a-service-account):
```
    roles/compute.viewer
    roles/compute.securityAdmin (only required if add_cluster_firewall_rules is set to true)
    roles/container.clusterAdmin
    roles/container.developer
    roles/iam.serviceAccountAdmin
    roles/iam.serviceAccountUser
    roles/resourcemanager.projectIamAdmin (only required if service_account is set to create)
```
4. Enable the following Google Cloud APIs:
```
    Compute Engine API - compute.googleapis.com
    Kubernetes Engine API - container.googleapis.com
    Google Container Registry API - containerregistry.googleapis.com
```
5. Create a non-dist copy of the files under `secrets/` and put up your values. The service-account keyfile can be
downloaded from the Google Cloud console when you create the service account.
6. Make sure you have `google-cloud-sdk` installed and authenticated into your local machine.

```shell script
make first-time-setup # You only need to run this once
make setup # Run this to apply or reapply everything
```

(TODO) Applications will be accessible through URLs in the output of the command.

### Additional commands

For additional commands, use the `help` Makefile task.

```shell script
make help
```

### Run in a local Kubernetes cluster

To run your Kubernetes commands against a local cluster (tested with docker-desktop), edit the first line of
`kubernetes/Makefile` from:
```shell script
.ENVIRONMENT := gke
```

into

```shell script
.ENVIRONMENT := local
```

Then on `./Makefile` replace any occurrences of `first-time-setup` with `first-time-local-setup`.
