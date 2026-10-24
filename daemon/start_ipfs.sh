#!/bin/sh

user=$(whoami)
repo="$IPFS_PATH"

# Test whether the mounted directory is writable
if [ ! -w "$repo" 2>/dev/null ]; then
  echo "error: $repo is not writable for user $user (uid=$(id -u $user))"
  exit 1
fi

ipfs version

if [ -e "$repo/config" ]; then
  echo "Found IPFS fs-repo at $repo"
else
  ipfs init
fi

ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST"]'
ipfs config --json Pubsub.Enabled true

# Only the plain daemon invocation gets our flags; any other command runs as given.
if [ "$1" = "daemon" ]; then
  shift
  exec env IPFS_LOGGING=$IPFS_LOGGING ipfs daemon --enable-gc "$@"
fi

exec ipfs "$@"
