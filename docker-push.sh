#!/bin/bash
set -euo pipefail

#--- ARGS

# Kubo version the daemon image is built from (also used as the image tag)
TAG=${TAG:-v0.43.1}

# Target registry, e.g. 123456789012.dkr.ecr.eu-west-1.amazonaws.com/district0x
# Required for pushing; without it images are only built locally.
REGISTRY=${REGISTRY:-}

# Set PUSH=1 to push after building
PUSH=${PUSH:-0}

PLATFORMS=${PLATFORMS:-linux/amd64,linux/arm64}

#--- FUNCTIONS

function login {
  # ECR host looks like <account>.dkr.ecr.<region>.amazonaws.com
  local host=${REGISTRY%%/*}
  local region
  region=$(echo "$host" | cut -d "." -f 4)
  aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$host"
}

function build {
  local service=$1
  local name=ipfs-$service
  local img=${REGISTRY:+$REGISTRY/}$name

  echo "============================================="
  echo "[$service] Building: $img:$TAG"
  echo "============================================="

  local args=(-t "$img:$TAG" -t "$img:latest")
  if [ "$service" = "daemon" ]; then
    args+=(--build-arg "KUBO_VERSION=$TAG")
  fi

  if [ "$PUSH" = "1" ]; then
    # multi-arch build, pushed straight to the registry
    docker buildx build --platform "$PLATFORMS" "${args[@]}" --push "$service/"
  else
    docker build "${args[@]}" "$service/"
  fi
}

#--- EXECUTE

if [ "$PUSH" = "1" ]; then
  [ -n "$REGISTRY" ] || { echo "REGISTRY must be set when PUSH=1"; exit 1; }
  login
fi

for service in daemon server; do
  build $service
done
