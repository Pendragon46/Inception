FROM alpine:3.21.4

RUN apk update && apk upgrade \
     && apk add nginx

COPY nginx.conf /etc/nginx/
COPY index.html /var/www/html/
COPY private.key /etc/ssl/
COPY cert.crt /etc/ssl/

ENTRYPOINT ["nginx", "-g", "daemon off;"]