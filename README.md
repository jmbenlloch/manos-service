This repository contains the necessary files to run the MANOS web service using docker compose. It requires the following elements:

- Docker image with ruby to run the web itself. The `Dockerfile` is included in this repository. The built image is in [Docker Hub](https://hub.docker.com/jmbenlloch/manos-web)
- `nginx` as reverse proxy (with SSL) to redirect requests to rails.
- `elasticsearch`: as search engine to query the database.
- `postgresql`: database to store and retrieve manuscripts data.

This repository includes a docker compose file with the definition of all those services with their required versions.

# Deployment
To run the service three elements are required:
- A clone of the [manos repository](https://github.com/alreidy/manos)
- A clone of this repository
- The latest backup of the database. Can be found in [this repository](https://github.com/alreidy/manos-backups).
- A file `.env` with all the passwords and tokens required

These are the steps to run the service:
1. Adapt the paths in the compose file. 
	1. The folder with MANOS source code **must be mounted** on the ruby image in `/manos`. 
	2. The folder with database backups must be mounted on `/data` in the `postgresql`  container.
2. Copy a `.env` file with the environment variables used for configuration.
3. Create the SSL certificate using Let's Encrypt. To do that, the script `renew_ssl.sh` can be run.
4. Start the services running: `docker compose -f docker-compose.yml up -d nginx`
5. Import the database backup:
	```
	docker exec -ti manos-service-database-1 bash
	psql  -h localhost -U user -d manos < manos_database_dump.sql
	```
6. Precompile assets:
	```
	docker exec -ti manos-web-1 bash
	RAILS_ENV=production rake assets:precompile
	```
7. Reconstruct the Elasticsearch index:
	``` 
	docker exec -ti manos-service-web-1 bash
	RAILS_ENV=production rake chewy:reset:all
	```
8. Restart web service:
	```
	docker stop manos-service-web-1
	docker compose -f docker-compose.yml up -d nginx
	```

# Maintenance
## Database backups
The script `backup_database.sh` creates a compressed backup of the database and uploads it to a private [Github repository](https://github.com/alreidy/manos-backups).

The easiest way to do that is to set up a deploy key with write access to the relevant repository.

## SSL certificate
This service uses Let's Encrypt to get a certificate for https://manos.net. This certificates are free but only last 3 months, the script `renew_ssl.sh` can be used to update it. 

## Cron jobs
The two previous scripts must be run periodically. Cron can be used for that. A sample `crontab` config file is included in this repository.
