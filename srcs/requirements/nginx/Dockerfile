FROM alpine:3.21.4

RUN apk update && apk upgrade \
     && apk add nginx

COPY conf/nginx.conf /etc/nginx/
COPY tools/private.key /etc/ssl/
COPY tools/cert.crt /etc/ssl/

ENTRYPOINT ["nginx", "-g", "daemon off;"]