# syntax=docker/dockerfile:1

# Build on the host's native platform and cross-compile to the target platform,
# so multi-arch builds don't run the Go toolchain under QEMU.
FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETOS
ARG TARGETARCH

WORKDIR /usr/src/app

# Copy the module definition first so dependency resolution can be cached,
# then the source code.
COPY go.mod ./
COPY main.go ./

# Build a static binary for the requested platform and place it at a fixed path.
# CGO_ENABLED=0 keeps it statically linked so it runs on scratch.
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /app .

FROM scratch

# Links the GHCR package to the repo.
LABEL org.opencontainers.image.source=https://github.com/tony-nyagah/kubernetes-mooc

# Copy the compiled binary from the build stage.
COPY --from=build /app /app

ENTRYPOINT ["/app"]
