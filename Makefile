
# Build options
IMAGE_NAME="hlds"
IMAGE_TAG="alpha"

STEAM_USER?="anonymous"
STEAM_PASSWORD?=""

DOCKER_NO_CACHE?="false"

# Test tools
SHELLCHECK_IMAGE?="koalaman/shellcheck:latest"
TEST_CONTAINER_NAME?="test_hlds_auto"
TEST_CONTAINER_PORT?="27111"
HLDS_NAME?="Test auto"
HLDS_MAP?="de_dust2"

.PHONY: build
build:
	docker build -f Dockerfile --no-cache=$(DOCKER_NO_CACHE) \
	-t $(IMAGE_NAME):$(IMAGE_TAG) \
	--build-arg steam_user=$(STEAM_USER) \
	--build-arg steam_password=$(STEAM_PASSWORD) .

.PHONY: test
test: shellcheck test-smoke test-clean

.PHONY: shellcheck
shellcheck:
	docker run --rm -v $(PWD):/code \
	--entrypoint sh $(SHELLCHECK_IMAGE) -c \
	"find /code/ -type f -name '*.sh' | xargs shellcheck"

.PHONY: test-start-server
test-start-server:
	$(MAKE) test-stop-server
	docker run -d -p $(TEST_CONTAINER_PORT):27015/udp \
	-e START_MAP=$(HLDS_MAP) -e SERVER_NAME=$(HLDS_NAME) \
	--name $(TEST_CONTAINER_NAME) $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: test-stop-server
test-stop-server:
	-docker rm -f $(TEST_CONTAINER_NAME)

.PHONY: test-smoke
test-smoke: test-start-server
	tests/smoke.py

.PHONY: test-clean
test-clean: test-stop-server

.PHONY: clean
clean: test-clean
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)
