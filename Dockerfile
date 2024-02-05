# Gunakan gambar Ubuntu 20.04 sebagai dasar
FROM ubuntu:20.04

# Update dan install dependensi
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl zip unzip git

# Instal Node.js dan npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Instal Panel Pterodactyl
RUN mkdir -p /var/www/pterodactyl && \
    curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz && \
    tar --strip-components=1 -xzvf panel.tar.gz -C /var/www/pterodactyl && \
    chmod -R 755 /var/www/pterodactyl/storage /var/www/pterodactyl/bootstrap/cache && \
    npm install -g yarn && \
    cd /var/www/pterodactyl && \
    yarn install --production --frozen-lockfile && \
    php artisan key:generate --force && \
    php artisan p:environment:setup --force && \
    php artisan migrate --force && \
    php artisan db:seed --force && \
    php artisan p:user:make

# Instal Ngrok
RUN mkdir -p /ngrok && \
    curl -Lo /ngrok/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip /ngrok/ngrok.zip -d /ngrok && \
    rm /ngrok/ngrok.zip

# Set direktori kerja
WORKDIR /var/www/pterodactyl

# Jalankan Panel Pterodactyl dan Ngrok
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"] && ["/ngrok/ngrok", "http", "8000"]
