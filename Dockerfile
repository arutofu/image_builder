# Используем официальный образ Ubuntu
FROM ubuntu:20.04

# Устанавливаем переменную окружения для автоматического выбора временной зоны
ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем временную зону и необходимые пакеты
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y tzdata wget unzip parted kmod dosfstools debootstrap udev sudo qemu-user-static && \
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean

# Копируем скрипты в контейнер
COPY scripts/ /workspace/scripts/

# Делаем скрипт исполняемым
RUN chmod +x /workspace/scripts/build_image.sh

# Устанавливаем рабочую директорию
WORKDIR /workspace
