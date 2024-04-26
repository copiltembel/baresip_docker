docker buildx build --no-cache --build-arg VERSION=v3.11.0 --platform linux/amd64,linux/arm64 -t ghcr.io/copiltembel/barsesip_docker/libre:v3.11.0  --push .
