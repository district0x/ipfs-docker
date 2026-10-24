ARG KUBO_VERSION=v0.43.1

# the official image is multi-arch, so this builds for amd64 and arm64
FROM ipfs/kubo:${KUBO_VERSION} AS kubo

FROM ubuntu:24.04

ENV IPFS_PATH=/data/ipfs
ENV IPFS_LOGGING=""

WORKDIR /

COPY --from=kubo /usr/local/bin/ipfs /usr/local/bin/ipfs
COPY start_ipfs.sh /usr/local/bin/start_ipfs

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && chmod a+x /usr/local/bin/start_ipfs \
  && mkdir -p $IPFS_PATH

# swarm tcp/udp (quic)
EXPOSE 4001 4001/udp

# api
EXPOSE 5001

# gateway
EXPOSE 8080

# Expose the fs-repo as a volume.
# start_ipfs initializes an fs-repo if none is mounted.
VOLUME $IPFS_PATH

# This just makes sure that:
# 1. There's an fs-repo, and initializes one if there isn't.
# 2. The API and Gateway are accessible from outside the container.
ENTRYPOINT ["/usr/local/bin/start_ipfs"]

# Execute the daemon subcommand by default
CMD ["daemon", "--migrate=true"]
