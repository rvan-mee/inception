#!/bin/bash

# check if Wordpress is already installed
if [ -f wp-login.php ]
then
    echo "Wordpress is already installed"
else
    wp core download --allow-root
fi

# check if wp is already configured
if [ -f wp-config.php ]
then
    echo Wordpress is already configured.
else
    echo creating Wordpress config...

    timeout=0

    while true ; do

        wp config create --dbname="$DB_NAME" \
                 --dbuser="$DB_USER" \
                 --dbpass="$DB_PASS" \
                 --dbhost="$DB_NAME" \
                 --allow-root

        # check the $? for the return value, if its not 0,
        # retry most likely because db has not started yet
        if [ $? -eq 0 ]; then
            break
        fi

        # increase the timeout
        let "timeout=timeout+1"
    
        # check for a timeout
        if [ $timeout -eq 5 ]; then
            echo "Configuring Wordpress timed out... Exiting"
            exit 1
        fi

        echo "Wordpress config failed... Retrying"
        sleep 3

    done

    # installing Wordpress core
    wp core install --title="wordpress" \
                    --admin_user="$WP_ADMIN_NAME" \
                    --admin_password="$WP_ADMIN_PASS" \
                    --admin_email="admin@admin.com" \
                    --skip-email \
                    --url="https://rvan-mee.42.fr/" \
                    --allow-root


    # creating a regular user
    wp user create "$WP_USER_NAME" user@user.com \
                    --user_pass="$WP_USER_PASS" \
                    --allow-root

fi

exec php-fpm7.4 -F
