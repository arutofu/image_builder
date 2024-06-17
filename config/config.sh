#!/bin/bash

set -e

# Обновление системы и установка необходимых пакетов
apt-get update
apt-get upgrade -y
apt-get install -y python3 python3-pip python3-venv nginx libffi-dev build-essential python3-dev git supervisor

# Установка butterfly
pip3 install pipx
pipx install butterfly

# Настройка nginx для запуска butterfly
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:57575/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Перезапуск nginx
service nginx restart

# Настройка supervisor для управления butterfly
cat <<EOF > /etc/supervisor/conf.d/butterfly.conf
[program:butterfly]
command=/root/.local/bin/butterfly.server.py --host=0.0.0.0 --port=57575 --unsecure
autostart=true
autorestart=true
stderr_logfile=/var/log/butterfly.err.log
stdout_logfile=/var/log/butterfly.out.log
EOF

# Перезапуск supervisor для применения настроек
service supervisor restart
