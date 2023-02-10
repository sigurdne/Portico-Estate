#
# Apache/php-server with xsl, postgres, mysql, mssql and oracle
# Local build only
#

FROM sigurdne/portico_estate_webserver:latest
LABEL maintainer="Sigurd Nes <sigurdne@online.no>"

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y build-essential
RUN apt-get install -y unzip re2c

ADD php/app.ini /etc/php/8.1/apache2/conf.d/92-app.ini
ADD php/app.ini /etc/php/8.1/cli/conf.d/92-app.ini


# Oracle support
ENV LD_LIBRARY_PATH "/usr/local/lib/instantclient_12_2"
ENV TNS_ADMIN "/usr/local/lib/instantclient_12_2"
ENV ORACLE_BASE "/usr/local/lib/instantclient_12_2"
ENV ORACLE_HOME "/usr/local/lib/instantclient_12_2"

#  https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
COPY oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/
COPY oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/

RUN unzip -o /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/lib/
RUN unzip -o /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /usr/local/lib/

RUN ln -s /usr/local/lib/instantclient_12_2/libclntsh.so.12.1 /usr/local/lib/instantclient_12_2/libclntsh.so

RUN mkdir -p /usr/local/lib/instantclient_12_2/lib/oracle/12.2
RUN ln -s /usr/local/lib/instantclient_12_2/sdk/ /usr/local/lib/instantclient_12_2/lib/oracle/12.2/client
RUN ln -s /usr/local/lib/instantclient_12_2 /usr/local/lib/instantclient_12_2/lib/oracle/12.2/client/lib


#RUN ln -s /usr/include/php7 /usr/include/php



WORKDIR /tmp/

RUN pecl download oci8
RUN tar xzvf oci8-3.2.1.tgz

WORKDIR /tmp/oci8-3.2.1
RUN phpize && \
 ./configure -with-oci8=shared,instantclient,/usr/local/lib/instantclient_12_2 && \
 make && \
 make install

# clean up
WORKDIR /tmp/
RUN rm oci8-3.2.1.tgz
RUN rm oci8-3.2.1 -rf
RUN rm instantclient-sdk-linux.x64-12.2.0.1.0.zip
RUN rm instantclient-basic-linux.x64-12.2.0.1.0.zip


# Others
ENV HOME /root
WORKDIR /root


# Command on startup
CMD ["/run.sh"]


# NOTE TO SELF:
# docker build -t sigurdne/portico_estate_webserver_oracle .
# docker run --name sigurdne_portico_estate_webserver_oracle -i -t sigurdne/portico_estate_webserver_oracle
# docker exec -i -t sigurdne_portico_estate_webserver_oracle bash #by Name
# docker rm $(docker ps -a -q)
