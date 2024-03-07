FROM debian:bullseye
EXPOSE 3306

# update apt and install mariadb
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install mariadb-server

RUN mkdir -p /var/run/mysqld; chown -R mysql:root /var/run/mysqld

COPY config/50-server.cnf /etc/mysql/mariadb.conf.d/
# copy the entrypoint script and give it execute rights
COPY tools/boot.sh /boot.sh
RUN chmod +x /boot.sh



# Allows wordpress to connect using the name mariadb otherwise error establishing database connection
# RUN sed 's/bind-address .*/bind-address = mariadb/' -i /etc/mysql/mariadb.conf.d/50-server.cnf

# RUN sed 's/pid-file .*/pid-file        = /run/mysqld/mysqld.pid socket          = /var/run/mysqld/mysqld.sock port            = 3306/' -i /etc/mysql/mariadb.conf.d/50-server.cnf


# we set the script as entrypoint
# ENTRYPOINT [ "/boot.sh" ]

# this will be the arugment for the script
# CMD [ "mysqld" ]

ENTRYPOINT [ "./boot.sh" ]
