#!/bin/bash

# Установка File Browser
echo "Installing File Browser"
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Проверка успешности установки
if [ ! -f /usr/local/bin/filebrowser ]; then
    echo "Error: File Browser installation failed."
    exit 1
fi

# Проверка запуска File Browser
echo "Starting File Browser for initial check"
/usr/local/bin/filebrowser -r /home/pi --port 9090 &
sleep 5

# Проверка, что File Browser запущен и слушает порт
if ! netstat -tuln | grep 9090; then
    echo "Error: File Browser is not running correctly. Checking logs..."

    # Проверка процессов и логов
    ps aux | grep filebrowser
    sudo journalctl -u filebrowser.service

    pkill filebrowser
    exit 1
fi

# Остановка временного процесса File Browser
pkill filebrowser
echo "File Browser installed and running correctly."