FROM ubuntu:latest

#definir a instalação sem interação
ENV DEBIAN_FRONTEND noninteractive

#atualiza e instala os pacotes
RUN apt-get update && apt upgrade -y && \
    apt-get install -y ca-certificates supervisor apt-transport-https software-properties-common nginx git

#add o repositorio do php e instala com os módulos necessários
RUN add-apt-repository ppa:ondrej/php && apt-get update && \
    apt-get install -y php8.3 php8.3-fpm php8.3-curl php8.3-zip php8.3-mbstring composer && \
    apt-get clean

#cria o diretório padrao para o php run
RUN mkdir -p /run/php/

#copia o arquivo de configuração do nginx
COPY nginx.conf /etc/nginx/sites-available/default

WORKDIR /var/www/html

#clona o repositorio do WebPanel
RUN git clone https://github.com/unrealircd/unrealircd-webpanel

#Cria a pasta vendor e define o owner
RUN mkdir -p /var/www/html/unrealircd-webpanel/vendor && \
    mkdir -p /var/www/.cache/composer/files && \
    chown -R www-data:www-data /var/www/html/unrealircd-webpanel && \
    chown -R www-data:www-data /var/www/.cache/composer

#instala usando o composer
WORKDIR /var/www/html/unrealircd-webpanel
USER www-data
RUN composer install

#cria o supervisord.conf para iniciar o nginx e php-fpm
USER root
RUN echo "[supervisord]" > /etc/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisord.conf && \
    echo "[program:nginx]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/nginx -g 'daemon off;'" >> /etc/supervisord.conf && \
    echo "[program:php-fpm]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/php-fpm8.3 -F" >> /etc/supervisord.conf
EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]