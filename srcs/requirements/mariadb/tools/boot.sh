#!bin/bash

mysql_install_db    --user=mysql --datadir=/var/lib/mysql

{
    echo "FLUSH PRIVILEGES;"
    echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    echo "CREATE USER IF NOT EXISTS $DB_USER@'%' IDENTIFIED BY '$DB_PASS';"
    echo "GRANT ALL ON *.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASS';"
    echo "FLUSH PRIVILEGES;"
} | mysqld --bootstrap

# using exec allows child processes to recieve the sigterm from docker stop,
# allowing for clean shutdowns

# $@ expands to whatever the arugment is for the script:
# so for: "script.sh foo bar", $@ expands to "foo bar"
exec "$@"
