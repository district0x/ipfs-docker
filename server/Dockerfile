FROM nginx:stable-alpine
# replace nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# setup error page
# RUN wget --no-check-certificate -O X0X.html https://raw.githubusercontent.com/district0x/X0X/master/X0X.html \
#   && mv X0X.html /usr/share/nginx/html/X0X.html

# replace default server
COPY default.conf /etc/nginx/conf.d/default.conf

# setup server config
COPY ipfs.server.conf /etc/nginx/conf.d/ipfs.server.conf

EXPOSE 80
