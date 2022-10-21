#!/bin/bash

docker compose -f /home/manos/manos-service/docker-compose.yml stop nginx
docker compose -f /home/manos/manos-service/docker-compose.yml up create_certs
docker compose -f /home/manos/manos-service/docker-compose.yml stop nginx_get_ssl
docker compose -f /home/manos/manos-service/docker-compose.yml up -d nginx
