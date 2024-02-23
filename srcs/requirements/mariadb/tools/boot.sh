#!bin/bash


# Check if the specified database (defined in .env) directory exists
if [ -d "/var/lib/mysql/$DB_NAME" ]; then 
    echo "Database already exists"
else
    # Start MySQL service if the database directory doesn't exist
    service mariadb start

    # Wait until MySQL service is accessible before proceeding
    until mysqladmin ping -hlocalhost --silent; do
        echo "Waiting for MySQL service to start..."
        sleep 5
    done

    # Create commands to initialize the database
    echo "CREATE DATABASE IF NOT EXISTS $DB_NAME ;" > init_db.cmd
    echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS' ;" >> init_db.cmd
    echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' ;" >> init_db.cmd
    # Uncomment the line below to change the root password if needed
    # echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '12345' ;" >> init_db.cmd
    echo "FLUSH PRIVILEGES;" >> init_db.cmd

    # Execute the initialization commands using the MySQL client
    mysql < init_db.cmd

    # Wait for a few seconds before stopping MySQL service
    sleep 3

    # Stop the MySQL service
    service mariadb stop
fi

# Start the MySQL daemon
echo "executing mysql daemon"
exec mysqld


# if [ -d "/var/lib/mysql/$DB_NAME" ]; then 
#     echo "Database already exists"
# else
#     mysql_install_db    --user=mysql --datadir=/var/lib/mysql

#     {
#         echo "FLUSH PRIVILEGES;"
#         echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
#         echo "CREATE USER IF NOT EXISTS $DB_USER@'%' IDENTIFIED BY '$DB_PASS';"
#         echo "GRANT ALL ON *.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASS';"
#         echo "FLUSH PRIVILEGES;"
#     } | mysqld --bootstrap

#     # using exec allows child processes to recieve the sigterm from docker stop,
#     # allowing for clean shutdowns

#     # $@ expands to whatever the arugment is for the script:
#     # so for: "script.sh foo bar", $@ expands to "foo bar"
# fi

# echo "executing mysql daemon"
# exec mysqld
