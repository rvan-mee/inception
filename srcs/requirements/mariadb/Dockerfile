FROM debian:bullseye
EXPOSE 3306

ENV MYSQL_DATABASE=$DB_NAME
ENV MYSQL_USER=$DB_USER
ENV MYSQL_PASSWORD=$DB_PASS
ENV MYSQL_ROOT_PASSWORD=$DB_ROOT_PASS
# CHANGE THIS ^^^^ TO BE SET IN THE COMPOSE FILE, wont be inside the image then and is more secure

# update apt and install mariadb
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install mariadb-server

# copy the entrypoint script and give it execute rights
COPY tools/boot.sh /boot.sh
RUN chmod +x /boot.sh

RUN mkdir -p /var/run/mysqld; chown -R mysql:root /var/run/mysqld

RUN sed 's/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/' \
	-i /etc/mysql/mariadb.conf.d/50-server.cnf

# we set the script as entrypoint
ENTRYPOINT [ "/boot.sh" ]

# this will be the arugment for the script
CMD [ "mysqld" ]
