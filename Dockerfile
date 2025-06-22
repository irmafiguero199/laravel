FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip sqlite3 \
    && docker-php-ext-install pdo mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . /var/www

RUN composer install --optimize-autoloader --no-dev

RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www

CMD php artisan config:cache \
    && php artisan migrate --force \
    && php artisan serve --host=0.0.0.0 --port=10000
