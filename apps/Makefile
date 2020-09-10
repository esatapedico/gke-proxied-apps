setup:
	cd app1 && make setup
	cd app2 && make setup
	make build-and-push-production-images

destroy:
	cd app1 && make destroy
	cd app2 && make destroy

down:
	cd app1 && make down
	cd app2 && make down

build-production-images:
	cd app1 && make build-production-images
	cd app2 && make build-production-images

push-production-images-to-gcr:
	cd app1 && make push-production-images-to-gcr
	cd app2 && make push-production-images-to-gcr

build-and-push-production-images: build-production-images push-production-images-to-gcr

authenticate-with-gcr:
	gcloud auth activate-service-account terraform@zoover-assignment-rafael.iam.gserviceaccount.com --key-file=../secrets/google-cloud-service-acount-keyfile.json
	gcloud auth configure-docker
