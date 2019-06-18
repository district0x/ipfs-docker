FROM debian:stretch-slim
MAINTAINER "Filip Bielejec" <filip@district0x.io>

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
    -q wget

# ENV variables
ENV IPFS_LOGGING ""
ENV IPFS_VERSION 0.4.21
ENV IPFS_PATH /data/ipfs

# install ipfs
RUN wget --no-check-certificate https://dist.ipfs.io/go-ipfs/v${IPFS_VERSION}/go-ipfs_v${IPFS_VERSION}_linux-amd64.tar.gz
RUN tar xvfz go-ipfs_v${IPFS_VERSION}_linux-amd64.tar.gz
WORKDIR go-ipfs
RUN bash install.sh

WORKDIR /

# add start_ipfs script
ADD start_ipfs.sh /usr/local/bin/start_ipfs
RUN chmod a+x /usr/local/bin/start_ipfs

# swarm tcp
#EXPOSE 4001

# swarm uTP
#EXPOSE 4002/udp

# api
#EXPOSE 5001

# gateway
#EXPOSE 8080

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
