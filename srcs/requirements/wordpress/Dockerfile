FROM debian:bullseye
EXPOSE 9000

# fpm -> (FastCGI Proccess Manager)
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y mariadb-client php7.4-mysql php7.4-fpm curl
    # apt-get install -y mariadb-client php-mysql php-fpm curl

# creates the directory for php to be able to bind the socket
# error would be: "unable to bind listening socket for address '/run/php/php8.2-fpm.sock': No such file or directory (2)"
RUN mkdir /run/php

COPY tools/boot.sh /boot.sh
RUN chmod +x /boot.sh

# install the wordpress command line interface
# https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
     && chmod +x wp-cli.phar \
     && mv wp-cli.phar /usr/local/bin/wp

RUN sed -i "s/listen.*/listen = 0.0.0.0:9000/" /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT [ "bash", "/boot.sh" ]
