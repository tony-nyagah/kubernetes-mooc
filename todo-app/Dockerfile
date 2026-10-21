FROM golang:alpine AS build

WORKDIR /usr/src/app

# Copy the module definition first so dependency resolution can be cached,
# then the source code.
COPY go.mod ./
COPY main.go ./

# Build a static binary and place it at a fixed path.
# CGO_ENABLED=0 keeps it statically linked so it runs on scratch.
RUN CGO_ENABLED=0 go build -o /app .

FROM scratch

# Links the GHCR package to the repo.
LABEL org.opencontainers.image.source=https://github.com/tony-nyagah/kubernetes-mooc

# Copy the compiled binary from the build stage.
COPY --from=build /app /app

ENTRYPOINT ["/app"]
