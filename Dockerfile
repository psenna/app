FROM php:7.3-apache
RUN apt-get update -yqq && apt-get install -y libxml2-dev libicu-dev libfreetype6-dev libmcrypt-dev libjpeg62-turbo-dev libcurl4-gnutls-dev libbz2-dev libssl-dev libpq-dev libxslt1.1 libxslt1-dev libzip-dev -yqq && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install json
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

COPY docker/apache-vhost.conf /etc/apache2/sites-available/custom-vhost.conf

COPY docker/ports.conf /etc/apache2/ports.conf

RUN a2dissite 000-default.conf && a2ensite custom-vhost.conf && a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www/html

RUN mkdir -p vendor && chmod 777 -R vendor

USER appuser

RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
    
RUN composer install --no-ansi --no-interaction --no-progress --optimize-autoloader
    
EXPOSE 8080

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

