#!/bin/bash

# Navigate to the WordPress directory
# Somehow this fixes the error: HP Warning:  file_get_contents(phar://wp-cli.phar/vendor/wp-cli/wp-cli/templates/phar://usr/local/bin/wp/vendor/wp-cli/config-command/templates/wp-config.mustache): failed to open stream: phar error: "vendor/wp-cli/wp-cli/templates/phar:/usr/local/bin/wp/vendor/wp-cli/config-command/templates/wp-config.mustache" is not a file in phar "wp-cli.phar" in phar:///usr/local/bin/wp/vendor/wp-cli/wp-cli/php/utils.php on line 608
cd /var/www/html

# Check if WordPress is already installed
if [ -f wp-login.php ]
then
    echo "WordPress is already installed"
else
    wp core download --path="/var/www/html" --allow-root
fi

# Check if WordPress is already configured
if [ -f wp-config.php ]; then
    echo "WordPress is already configured"
else
    echo "Creating Wordpress config..."

    timeout=0

    while true ; do

        # attempt to create the wp-config.php
        wp config create --path="/var/www/html" \
                        --dbname="$DB_NAME" \
                        --dbuser="$DB_USER" \
                        --dbpass="$DB_PASS" \
                        --dbhost="$DB_HOST" \
                        --allow-root

        # check the $? for the return value, if its not 0 retry,
        # most likely because db has not started yet
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

        echo "Wordpress config failed... Retrying..."
        sleep 3

    done

    # installing Wordpress core
    wp core install --path="/var/www/html" \
                    --title="wordpress" \
                    --admin_user="$WP_ADMIN_NAME" \
                    --admin_password="$WP_ADMIN_PASS" \
                    --admin_email="admin@admin.com" \
                    --url="https://rvan-mee.42.fr/" \
                    --skip-email \
                    --allow-root


    # creating a regular user
    wp user create "$WP_USER_NAME" user@user.com \
                    --path="/var/www/html" \
                    --user_pass="$WP_USER_PASS" \
                    --allow-root
fi

echo "executing php-fpm"
exec /usr/sbin/php-fpm7.4 -F
