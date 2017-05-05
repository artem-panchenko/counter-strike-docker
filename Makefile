
# Build options
IMAGE_NAME="hlds"
IMAGE_TAG="alpha"

STEAM_USER?="anonymous"
STEAM_PASSWORD?=""

DOCKER_NO_CACHE?="false"

# Test tools
SHELLCHECK_IMAGE="koalaman/shellcheck:latest"

.PHONY: build
build:
	docker build -f Dockerfile --no-cache=$(DOCKER_NO_CACHE) \
	-t $(IMAGE_NAME):$(IMAGE_TAG) \
	--build-arg steam_user=$(STEAM_USER) \
	--build-arg steam_password=$(STEAM_PASSWORD) .

.PHONY: test
test: shellcheck

.PHONY: shellcheck
shellcheck:
	docker run --rm -v $(PWD):/code \
	--entrypoint sh $(SHELLCHECK_IMAGE) -c \
	"find /code/ -type f -name '*.sh' | xargs shellcheck"
