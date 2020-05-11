# district0x/ipfs-docker

Dockerized ipfs. Example of using (with docker-compose):

```yaml
version: "3"
services:

  ipfs-daemon:
    image: district0x/ipfs-daemon:latest
    container_name: my_ipfs-daemon
    volumes:
      - /home/$USER/ipfs-docker:/data/ipfs
    networks:
      - ipfs-net

  ipfs-server:
    image: district0x/ipfs-server:latest
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
2. api is availiable at: http://localhost:80/api/api/v0
