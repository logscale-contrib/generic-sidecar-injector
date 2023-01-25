GIT_HASH=$(shell git rev-parse --short HEAD)
GIT_TAG=$(shell git tag | tail -1)


all: git fmt build test install

.PHONY: git
git: 
	@echo GIT_HASH IS $(GIT_HASH)
	@echo GIT_TAG IS $(GIT_TAG)

fmt:
	go fmt ./...

build:
	go build -mod=vendor -ldflags "-X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitHash=$(GIT_HASH)' -X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitTag=$(GIT_TAG)'" ./cmd/...

test:
	go test -mod=vendor -ldflags "-X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitHash=$(GIT_HASH)' -X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitTag=$(GIT_TAG)'" -cover ./...

install:
	go install -mod=vendor -ldflags "-X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitHash=$(GIT_HASH)' -X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitTag=$(GIT_TAG)'" ./cmd/...

linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install -mod=vendor -ldflags "-s" -installsuffix cgo -v ./cmd/...

docker:
	docker build . -t sidecarinjector --build-arg GIT_HASH=$(GIT_HASH) --build-arg GIT_TAG=$(GIT_TAG)
