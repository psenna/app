FROM infradev.ufms.br:8084/agetic/php-apache:latest

WORKDIR /var/www/html

COPY . /var/www/html

RUN mkdir -p vendor && chmod 777 -R vendor && chmod 777 -R logs && chmod 777 -R tmp

USER appuser

RUN composer install --no-ansi --no-interaction --no-progress --optimize-autoloader
    
EXPOSE 8080

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
