# Base image
FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    unzip \
    git \
    curl \
    libicu-dev \
    libxml2-dev \
    libpq-dev \
    libzip-dev \
    libssl-dev \
    libbrotli-dev \
    build-essential \
    locales \
    && apt-get clean

# Install SQL Server drivers
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18 unixodbc-dev && \
    pecl install pdo_sqlsrv sqlsrv && \
    docker-php-ext-enable pdo_sqlsrv sqlsrv

# Install PHP extensions
RUN docker-php-ext-install intl zip opcache pcntl

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Laravel Octane dependencies
RUN composer global require laravel/octane && \
    composer global require swoole/ide-helper && \
    pecl install swoole && \
    docker-php-ext-enable swoole

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose the Octane port
EXPOSE 8000

# Start Octane server
CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=8000"]
