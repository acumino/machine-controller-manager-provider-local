FROM golang:1.21.1 AS builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /go/src/github.com/gardener/machine-controller-manager-provider-local
COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
      go build \
      -mod=vendor \
      -o /usr/local/bin/machine-controller \
      cmd/machine-controller/main.go

FROM alpine:3.17.3 AS machine-controller
WORKDIR /
COPY --from=builder /usr/local/bin/machine-controller /machine-controller
ENTRYPOINT ["/machine-controller"]
