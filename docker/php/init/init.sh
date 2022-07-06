#!/bin/bash

# Only do this once.
CONTAINER_ALREADY_STARTED="/tmp/CONTAINER_ALREADY_STARTED"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
	echo "Performing initial WinterCMS setup..."

    # Migrate WinterCMS to the actual database and reset it.
    echo "Migrating WinterCMS to the actual database..."
    php artisan winter:up
    echo "Resetting WinterCMS and removing demo assets..."
    php artisan winter:fresh
    echo "Resetting WinterCMS admin account..."
    php artisan winter:passwd admin admin

    # Install plugins.
    echo "Installing required October/Winter plugins..."
    # TODO: Pin plugin versions.
    php artisan plugin:install "paulvonzimmerman.patreon"
    php artisan plugin:install "pikanji.agent"
    php artisan plugin:install "rainlab.blog"
    php artisan plugin:install "sobored.rss"

    echo "Updating file permissions for newly created files..."
    chown www-data:www-data -R .

    echo "Godot Website is READY to use!"
else
	echo "Skipped initial WinterCMS setup."
fi

exec docker-php-entrypoint apache2-foreground
