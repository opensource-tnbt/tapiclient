DOCKERHUB_USER = spirent
REPONAME = netaut
DOCKERHUB = $(DOCKERHUB_USER)/$(REPONAME)
GITHUB_USER = opensource-tnbt
GITHUB = https://github.com/$(GITHUB_USER)/$(REPONAME)
VER = 1.0
CONTAINERNAME = $(DOCKERHUB):$(VER)

BUILDFLAGS = \
  --compress \
  --force-rm \
  --label org.label-schema.schema-version="1.0" \
  --label org.label-schema.description="Network Automation With Ansible on Alpine Linux" \
  --label org.label-schema.vcs-url="$(GITHUB)" \
  --label org.label-schema.vcs-ref="$(VER)" \
  --label org.label-schema.docker.cmd="docker run -it --rm $(CONTAINERNAME)" \
  --label org.label-schema.name="$(DOCKERHUB)" \
  --label org.label-schema.build-date="$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")"


default: help


build:  ## build container
	@docker build $(BUILDFLAGS) -t $(CONTAINERNAME) .

build-no-cache:  ## build container without cache
	@docker build --no-cache $(BUILDFLAGS) -t $(CONTAINERNAME) .

build-ver:  ## build specific alpine/ansible version: make build-ver ALPINE_VERSION="3.9" ANSIBLE_VERSION="2.7.6"
	@docker build $(BUILDFLAGS) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg ANSIBLE_VERSION=$(ANSIBLE_VERSION) -t $(CONTAINERNAME) .

run:  ## run container
	@docker run -it --rm $(CONTAINERNAME)

clean:  ## remove images
	@docker rmi $(CONTAINERNAME)

.PHONY: inspect
inspect:  ## inspect container properties - pretty: 'make inspect | jq .' requires jq
	@docker inspect -f "{{json .ContainerConfig }}" $(CONTAINERNAME)

.PHONY: test
test:  ## test container with builtin tests
	docker run --rm $(CONTAINERNAME) version
	docker run --rm $(CONTAINERNAME) setup
