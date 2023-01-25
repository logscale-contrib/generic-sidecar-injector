FROM golang:1.19.5-alpine3.17 AS build

WORKDIR /sidecarinjector
COPY go.mod go.sum ./

RUN go mod download

COPY . ./
COPY pkg ./pkg

ARG GIT_HASH
ARG GIT_TAG
ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go build -ldflags  "-X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitHash=$GIT_HASH' -X 'github.com/salesforce/generic-sidecar-injector/pkg/metrics.gitTag=$GIT_TAG' -s" -installsuffix cgo -o sidecarinjector ./cmd/sidecarinjector

FROM golang:1.19.5-alpine3.17
COPY --from=build /sidecarinjector/sidecarinjector /sidecarinjector
ENV PATH="/:${PATH}"
CMD ["/sidecarinjector"]
