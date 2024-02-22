FROM debian:buster
EXPOSE 3306

# update apt and install mariadb
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install mariadb-server

# copy the entrypoint script and give it execute rights
COPY tools/boot.sh /boot.sh
RUN chmod +x /boot.sh

RUN mkdir -p /var/run/mysqld; chown -R mysql:root /var/run/mysqld

# Allows wordpress to connect using the name mariadb otherwise error establishing database connection
RUN sed 's/bind-address .*/bind-address = mariadb/' -i /etc/mysql/mariadb.conf.d/50-server.cnf

# we set the script as entrypoint
ENTRYPOINT [ "/boot.sh" ]

# this will be the arugment for the script
CMD [ "mysqld" ]
