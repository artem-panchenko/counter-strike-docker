IMAGE_NAME="hlds"
IMAGE_TAG="alpha"

STEAM_USER?="anonymous"
STEAM_PASSWORD?=""

DOCKER_NO_CACHE?="false"

.PHONY: build
build:
	docker build -f Dockerfile --no-cache=$(DOCKER_NO_CACHE) \
	-t $(IMAGE_NAME):$(IMAGE_TAG) \
	--build-arg steam_user=$(STEAM_USER) \
	--build-arg steam_password=$(STEAM_PASSWORD) .
