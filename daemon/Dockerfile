FROM ubuntu:20.04 as download_ipfs

ENV IPFS_VERSION 0.4.23
# install ipfs
ADD https://dist.ipfs.io/go-ipfs/v${IPFS_VERSION}/go-ipfs_v${IPFS_VERSION}_linux-amd64.tar.gz go-ifs.tar.gz
RUN tar xvfz go-ifs.tar.gz


FROM ubuntu:20.04

ENV IPFS_PATH=/data/ipfs
ENV IPFS_LOGGING=""

WORKDIR /

# add start_ipfs script
COPY --from=download_ipfs /go-ipfs/ipfs /usr/local/bin/ipfs
COPY start_ipfs.sh /usr/local/bin/start_ipfs

RUN chmod a+x /usr/local/bin/start_ipfs

# swarm tcp
#EXPOSE 4001

# swarm uTP
#EXPOSE 4002/udp

# api
EXPOSE 5001

# gateway
EXPOSE 8080

# websocket
#EXPOSE 8081

# Expose the fs-repo as a volume.
# start_ipfs initializes an fs-repo if none is mounted.
# Important this happens after the USER directive so permissions are correct.
VOLUME $IPFS_PATH

# This just makes sure that:
# 1. There's an fs-repo, and initializes one if there isn't.
# 2. The API and Gateway are accessible from outside the container.
ENTRYPOINT ["/usr/local/bin/start_ipfs"]

# Execute the daemon subcommand by default
CMD ["daemon", "--migrate=true"]
