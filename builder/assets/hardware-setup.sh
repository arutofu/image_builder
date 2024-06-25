#!/usr/bin/env bash

set -e # Exit immediately on non-zero result

echo_stamp() {
  # TEMPLATE: echo_stamp <TEXT> <TYPE>
  # TYPE: SUCCESS, ERROR, INFO

  TEXT="$(date '+[%Y-%m-%d %H:%M:%S]') $1"
  TEXT="\e[1m$TEXT\e[0m" # BOLD

  case "$2" in
    SUCCESS)
    TEXT="\e[32m${TEXT}\e[0m";; # GREEN
    ERROR)
    TEXT="\e[31m${TEXT}\e[0m";; # RED
    *)
    TEXT="\e[34m${TEXT}\e[0m";; # BLUE
  esac
  echo -e ${TEXT}
}

##################################################
# Configure hardware interfaces
##################################################

# 1. Enable sshd
echo_stamp "#1 Turn on sshd"
touch /boot/ssh

# 2. Enable GPIO
echo_stamp "#2 GPIO enabled by default"

# 3. Enable I2C
echo_stamp "#3 Turn on I2C"
/usr/bin/raspi-config nonint do_i2c 0

# 4. Enable SPI
echo_stamp "#4 Turn on SPI"
/usr/bin/raspi-config nonint do_spi 0

# 5. Enable raspicam
echo_stamp "#5 Turn on raspicam"
/usr/bin/raspi-config nonint do_camera 0

# 6. Enable hardware UART
echo_stamp "#6 Turn on UART"
/usr/bin/raspi-config nonint do_serial 1
/usr/bin/raspi-config nonint set_config_var enable_uart 1 /boot/config.txt
echo dtoverlay=pi3-disable-bt >> /boot/config.txt
systemctl disable hciuart.service

# 7. Enable V4L driver
echo_stamp "#7 Turn on v4l2 driver"
if ! grep -q "^bcm2835-v4l2" /etc/modules; then
    printf "bcm2835-v4l2\n" >> /etc/modules
fi

# 8. Установка File Browser
echo_stamp "#8 Installing File Browser"
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Проверка успешности установки
if [ ! -f /usr/local/bin/filebrowser ]; then
    echo "Error: File Browser installation failed."
    exit 1
fi

# Создание файла базы данных и установка прав
echo_stamp "#9 Создание файла базы данных и установка прав"
touch /home/pi/filebrowser.db
chown pi:pi /home/pi/filebrowser.db
chmod 644 /home/pi/filebrowser.db

echo "File Browser installed successfully."

echo_stamp "#10 End of configure hardware interfaces"
