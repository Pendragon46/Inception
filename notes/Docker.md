#Docker


Docker est un outil pour faire de la ***virtualisation*** d'application grace a des container , tout ca en utilisant les le kernel de la machine hote . ca permet une **uniformite** et une **portabilite** sur l'environnement de travail.

## Basics

### Dockerfile

Le dockerfile c'est le code  pour creer l'environnement de travail . c'est la qu'on installe toute les dependances . Le dockerfile utilise un systeme de **layer** cad chaque instruction cree une couche qui est stocker en cache , ce qui facilite la modification vu que c'est seulement la couche modifie et plus qui est reconstruite et ca reduit la consommation de memoire .

[command dockerfile](https://docs.docker.com/reference/dockerfile/)
```Dockerfile
FROM debian:bullseye

# Installer nginx + outils utiles
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Créer dossier web (optionnel)
RUN mkdir -p /var/www/html

# Copier ta config nginx (si tu en as une)
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Copier site web (optionnel)
COPY ./html /var/www/html

# Créer dossier SSL (si HTTPS)
RUN mkdir -p /etc/nginx/ssl

# Générer certificat auto-signé (utile pour Inception)
RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Student/CN=localhost" \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

# Permissions
RUN chmod 600 /etc/nginx/ssl/nginx.key

# Exposer le port HTTPS
EXPOSE 443

# Lancer nginx en foreground (IMPORTANT Docker)
CMD ["nginx", "-g", "daemon off;"]
```
### Images

C'est comme le programme genere a partir du dockerfile . on peut trouver des images officiel pour plein d'application sur [dockerhub](https://hub.docker.com/) .

### Container
C'est une instance d'une image . Doit toujours etre lance en premier plan ne fonctionne pas avec les process daemon , le conteneur s'arretera tout de suite 

### Commande

```Bash
########################################
# 🐳 IMAGES
########################################

docker images
# Liste toutes les images

docker pull nginx
# Télécharge une image depuis Docker Hub

docker build -t myimage .
# Construit une image depuis un Dockerfile

docker rmi IMAGE_ID
# Supprime une image

docker image prune -a
# Supprime toutes les images inutilisées


########################################
# 📦 CONTENEURS
########################################

docker ps
# Conteneurs actifs

docker ps -a
# Tous les conteneurs (actifs + arrêtés)

docker run nginx
# Lance un conteneur

docker run -d nginx
# Lance en arrière-plan

docker run --name mycontainer nginx
# Lance avec un nom

docker run -p 8080:80 nginx
# Map port host:container

docker stop CONTAINER_ID
# Arrête un conteneur

docker start CONTAINER_ID
# Redémarre un conteneur

docker rm CONTAINER_ID
# Supprime un conteneur arrêté

docker rm -f CONTAINER_ID
# Force stop + suppression


########################################
# 🔍 DEBUG / LOGS
########################################

docker logs CONTAINER_ID
# Affiche les logs

docker logs -f CONTAINER_ID
# Logs en temps réel

docker exec -it CONTAINER_ID bash
# Entrer dans un conteneur (bash)

docker exec -it CONTAINER_ID sh
# Entrer dans un conteneur (sh minimal)


########################################
# 🧱 DOCKER COMPOSE
########################################

docker compose up
# Lance les services

docker compose up -d
# Lance en arrière-plan

docker compose up --build
# Reconstruit + lance

docker compose down
# Arrête et supprime les conteneurs

docker compose down --rmi all --volumes
# Nettoyage complet du projet


########################################
# 💾 VOLUMES
########################################

docker volume ls
# Liste les volumes

docker volume rm VOLUME_NAME
# Supprime un volume

docker volume prune
# Supprime volumes inutilisés


########################################
# 🌐 NETWORK
########################################

docker network ls
# Liste les réseaux

docker network create mynetwork
# Crée un réseau

docker network rm mynetwork
# Supprime un réseau


########################################
# 🧹 NETTOYAGE GLOBAL
########################################

docker system df
# Espace utilisé par Docker

docker system prune
# Nettoyage simple

docker system prune -a --volumes -f
# ⚠️ Nettoyage COMPLET (images + conteneurs + volumes)

```

### Volume

Les donnees contenu dans un containeur ne sont pas permanent . Pour consever les donnee ont utilise le systeme volume .

```docker
docker volume create my_volume #creation du volume

docker volume inspect my_volume #inspection 

docker volume rm my_volume # suppression

docker run -v my_volume:/var/lib/mysql mysql #utiliser le volume dans un container 
```
### Network 
Pour pouvoir communiquer entre eux les containeur doivent avoir un reseau .

```docker

docker network create my_network 
docker network inspect my_network
docker network rm my_network

docker run --network=my_network nginx #utiliser le network dans un container
```


### HealthCheck

C'est une commande pour verifier l'etat d'un conteneur a partir d'un test . Un conteneur peut dependre d'un autre , donc on verifie juste si le conteneur recquis est healthy .

```docker

 healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

```
# Docker Compose

C'est un outil qui permet de manipuler et gerer plusieur conteneur en meme temps grace a un seul fichier yml .
learn more at [compose] (https://docs.docker.com/reference/compose-file) 

```docker compose

version: "3.9"

services:

  nginx:
    build:
      context: ./nginx
      dockerfile: Dockerfile
    container_name: nginx_container
    restart: always

    ports:
      - "443:443"
      - "80:80"

    volumes:
      - nginx_data:/var/www/html
      - ./nginx/conf:/etc/nginx/conf.d:ro

    environment:
      NGINX_ENV: production
      DEBUG: "false"

    env_file:
      - .env

    networks:
      - app_network

    depends_on:
      - wordpress

    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s

    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"


  wordpress:
    build:
      context: ./wordpress
    container_name: wordpress_container
    restart: on-failure

    ports:
      - "9000:9000"

    environment:
      WORDPRESS_DB_HOST: mariadb
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: wp_pass
      WORDPRESS_DB_NAME: wp_db

    volumes:
      - wp_data:/var/www/html

    networks:
      - app_network

    depends_on:
      mariadb:
        condition: service_healthy


  mariadb:
    build:
      context: ./mariadb
    container_name: mariadb_container

    restart: unless-stopped

    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: wp_db
      MYSQL_USER: wp_user
      MYSQL_PASSWORD: wp_pass

    volumes:
      - db_data:/var/lib/mysql

    networks:
      - app_network

    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5


# 🌐 NETWORKS
networks:
  app_network:
    driver: bridge
    name: app_network_custom


# 💾 VOLUMES
volumes:
  nginx_data:
    driver: local

  wp_data:
    driver: local

  db_data:
    driver: local
```

## env file and secret file

Ce sont des fichiers cache sur lequel on stoque des information qu'on ne peut sensible .

