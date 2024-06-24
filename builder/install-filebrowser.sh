#!/bin/bash

# Установка File Browser
echo "Installing File Browser"
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Проверка успешности установки
if [ ! -f /usr/local/bin/filebrowser ]; then
    echo "Error: File Browser installation failed."
    exit 1
fi

echo "File Browser installed successfully."
