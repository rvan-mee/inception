FROM debian:bullseye
EXPOSE 3306

# update apt and install mariadb
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install mariadb-server

RUN mkdir -p /var/run/mysqld; chown -R mysql:root /var/run/mysqld

COPY config/50-server.cnf /etc/mysql/mariadb.conf.d/
# copy the entrypoint script and give it execute rights
COPY tools/boot.sh /boot.sh
RUN chmod +x /boot.sh

ENTRYPOINT [ "./boot.sh" ]
