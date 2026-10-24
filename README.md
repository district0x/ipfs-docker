# district0x/ipfs-docker

Dockerized [Kubo](https://github.com/ipfs/kubo) (IPFS) v0.43.1 behind an nginx proxy/cache. Example of using (with docker-compose):

```yaml
version: "3"
services:

  ipfs-daemon:
    image: <registry>/ipfs-daemon:latest
    container_name: my_ipfs-daemon
    volumes:
      - /home/$USER/ipfs-docker:/data/ipfs
    networks:
      - ipfs-net

  ipfs-server:
    image: <registry>/ipfs-server:latest
    container_name: my_ipfs-server
    depends_on:
      - ipfs-daemon
    ports:
      - 80:80
    volumes:
      - /home/$USER/nginx-docker/cache:/etc/nginx/cache
    networks:
      - ipfs-net

networks:
  ipfs-net:
    driver: "bridge"
```

1. ipfs gateway is exposed at: http://localhost:80/gateway/ipfs/
2. api is availiable at: http://localhost:80/api/v0

## Building

```sh
./docker-push.sh                                   # build locally
REGISTRY=<account>.dkr.ecr.<region>.amazonaws.com/<ns> PUSH=1 ./docker-push.sh   # multi-arch build + push to ECR
```

`TAG` (default `v0.43.1`) is the Kubo version and the image tag.
