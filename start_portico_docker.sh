#!/bin/bash

# Du trenger en ledig katalog for å holder på databasen: /var/lib/postgresql/data
# Filopplastinger må få en permanent plass: /var/files
# Konfigurasjon av applikasjonen mot database må overleve en omstart: /var/www/html/portico/header.inc.php

## proxy ser ikke ut til å virke...
#export http_proxy=http://proxy.bergen.kommune.no:8080/
#export http_proxy=http://proxy.bergen.kommune.no:8080/
#export http_proxy=http://proxy.bergen.kommune.no:8080/
# Rettelse for Ubuntu settes proxy i filen /etc/default/docker
## 14 og eldre: sudo service docker start
## 15 og nyere: sudo systemctl start docker
## https://docs.docker.com/articles/systemd/
## /etc/systemd/system/docker.service.d/http-proxy.conf

## recover space: docker images --no-trunc| grep none | awk '{print $3}' | xargs -r docker rmi
## https://meta.discourse.org/t/low-on-disk-space-cleaning-up-old-docker-containers/15792

#https://docs.docker.com/engine/userguide/networking/work-with-networks/#connect-containers

#docker network create -d overlay \
#  --subnet=192.168.0.0/16 \
#  --subnet=192.170.0.0/16 \
#  --gateway=192.168.0.100 \
#  --gateway=192.170.0.100 \
#  --ip-range=192.168.1.0/24 \
#  --aux-address="my-router=192.168.1.5" --aux-address="my-switch=192.168.1.6" \
#  --aux-address="my-printer=192.170.1.5" --aux-address="my-nas=192.170.1.6" \
#  my-multihost-network


#docker network create -d bridge --subnet 172.25.0.0/16 isolated_nw

# Clean up
docker stop $(docker ps -a -q)  > /dev/null 2>&1
docker rm $(docker ps -a -q)  > /dev/null 2>&1
docker images --no-trunc| grep none | awk '{print $3}' | xargs -r docker rmi
#docker volume prune -f
#docker system prune -a -f


# build / pull
docker pull postgres:9.6
echo -n "fetch latest app logic? answere yes or no: "

read svar

if [ $svar = "yes" ];then
    docker pull sigurdne/portico_estate_application:latest
fi

# build / pull
echo -n "build docker images? answere yes or no: "

read svar

if [ $svar = "yes" ];then
	echo "webserver må bygges lokalt på grunn av sertifikater"
 #   docker pull sigurdne/portico_estate_webserver:latest
    docker build -t sigurdne/portico_estate_webserver_oracle /home/hc483/docker/webserver_oracle/
fi

# start
echo -n "start docker images? answere yes or no: "

read svar

if [ $svar = "yes" ];then
   docker run --restart=always -d --name sigurdne_portico_estate_application sigurdne/portico_estate_application
   docker run --restart=always -d --name postgres -p 5433:5432 --expose 5432 -e "POSTGRES_PASSWORD=changeme" -v /var/lib/postgresql/data:/var/lib/postgresql/data postgres
#  docker run --restart=always -d --name sigurdne_portico_estate_webserver_oracle --link postgres_96:postgres_96 -p 443:443 -p 8080:80 --expose 80 --expose 443 -v /var/www/html/portico/header.inc.php:/var/www/html/portico/header.inc.php -v /var/files:/var/files --volumes-from "sigurdne_portico_estate_application" sigurdne/portico_estate_webserver_oracle
   docker run --restart=always -d --name sigurdne_portico_estate_webserver --link postgres_96:postgres -p 443:443 -p 8080:80 --expose 80 --expose 443 -v /var/www/html/portico/header.inc.php:/var/www/html/portico/header.inc.php -v /var/files:/var/files --volumes-from "sigurdne_portico_estate_application" sigurdne/portico_estate_webserver

#	docker run --restart=always -d \
#	 --name sigurdne_portico_estate_application sigurdne/portico_estate_application
#
#    docker run --restart=always -d\
#     --name postgres_96\
#     --network=isolated_nw\
#     --expose 5432\
#     -e "POSTGRES_PASSWORD=changeme"\
#     -v /var/lib/postgresql/data:/var/lib/postgresql/data postgres
#
#	docker run --restart=always -d\
#	 --name sigurdne_portico_estate_webserver_oracle\
#	 -p 443:443\
#	 -p 8080:80\
#	 --expose 80\
#	 --expose 443\
#	 -v /var/www/html/portico/header.inc.php:/var/www/html/portico/header.inc.php\
#	 -v /var/files:/var/files\
#	 --volumes-from "sigurdne_portico_estate_application" sigurdne/portico_estate_webserver_oracle
#
#	docker network connect isolated_nw sigurdne_portico_estate_webserver_oracle

    else
    echo "Skip start"
fi

