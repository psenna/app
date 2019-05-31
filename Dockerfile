FROM php:7.3
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

COPY ./ /app/root/
CMD ["php","-S","0.0.0.0:80","-t","/app/root"]
