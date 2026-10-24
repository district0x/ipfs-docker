FROM nginx:stable-alpine

RUN mkdir -p /etc/nginx/cache

# replace default server with the ipfs one
RUN rm -f /etc/nginx/conf.d/default.conf
COPY ipfs.server.conf /etc/nginx/conf.d/ipfs.server.conf

EXPOSE 80
