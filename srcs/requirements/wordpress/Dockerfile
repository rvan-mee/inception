FROM debian:bullseye
EXPOSE 9000

# fpm -> (FastCGI Proccess Manager)
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y mariadb-client php7.4-mysql php7.4-fpm curl

RUN curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o wp-cli.phar \
     && chmod +x wp-cli.phar \
     && mv wp-cli.phar /usr/local/bin/wp
RUN mkdir /run/php

RUN sed -i "s/listen.*/listen = 9000/g" /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/boot.sh .
RUN chmod +x ./boot.sh

CMD ["./boot.sh"]
