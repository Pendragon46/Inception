FROM alpine:3.21.4

RUN apk update && apk upgrade \
     && apk add nginx

RUN adduser -D -H -S -G www-data www-data

COPY conf/nginx.conf /etc/nginx/

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]