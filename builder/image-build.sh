#!/usr/bin/env bash

set -e # Exit immediately on non-zero result

# https://www.raspberrypi.org/software/operating-systems/#raspberry-pi-os-32-bit
SOURCE_IMAGE="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip"

export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:='noninteractive'}
export LANG=${LANG:='C.UTF-8'}
export LC_ALL=${LC_ALL:='C.UTF-8'}

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

BUILDER_DIR="/builder"
REPO_DIR="${BUILDER_DIR}/repo"
SCRIPTS_DIR="${REPO_DIR}/builder"
IMAGES_DIR="${REPO_DIR}/images"

[[ ! -d ${SCRIPTS_DIR} ]] && (echo_stamp "Directory ${SCRIPTS_DIR} doesn't exist" "ERROR"; exit 1)
[[ ! -d ${IMAGES_DIR} ]] && mkdir ${IMAGES_DIR} && echo_stamp "Directory ${IMAGES_DIR} was created successfully" "SUCCESS"

if [[ -z ${TRAVIS_TAG} ]]; then IMAGE_VERSION="$(cd ${REPO_DIR}; git log --format=%h -1)"; else IMAGE_VERSION="${TRAVIS_TAG}"; fi
REPO_URL="$(cd ${REPO_DIR}; git remote --verbose | grep origin | grep fetch | cut -f2 | cut -d' ' -f1 | sed 's/git@github\.com\:/https\:\/\/github.com\//')"
REPO_NAME="$(basename -s '.git' ${REPO_URL})"
IMAGE_NAME="${REPO_NAME}_${IMAGE_VERSION}.img"
IMAGE_PATH="${IMAGES_DIR}/${IMAGE_NAME}"

get_image() {
  local BUILD_DIR=$(dirname $1)
  local RPI_ZIP_NAME=$(basename $2)
  local RPI_IMAGE_NAME=$(echo ${RPI_ZIP_NAME} | sed 's/zip/img/')

  if [ ! -e "${BUILD_DIR}/${RPI_ZIP_NAME}" ]; then
    echo_stamp "Downloading original Linux distribution"
    wget --progress=dot:giga -O ${BUILD_DIR}/${RPI_ZIP_NAME} $2
    echo_stamp "Downloading complete" "SUCCESS"
  else
    echo_stamp "Linux distribution already downloaded"
  fi

  echo_stamp "Unzipping Linux distribution image"
  unzip -p ${BUILD_DIR}/${RPI_ZIP_NAME} ${RPI_IMAGE_NAME} > $1
  echo_stamp "Unzipping complete" "SUCCESS"
}

get_image ${IMAGE_PATH} ${SOURCE_IMAGE}

# Make free space
${BUILDER_DIR}/image-resize.sh ${IMAGE_PATH} max '7G'

${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/init_rpi.sh' '/root/'
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} exec ${SCRIPTS_DIR}'/image-init.sh' ${IMAGE_VERSION} ${SOURCE_IMAGE}

# Ensure the target directory exists
TARGET_DIR='/home/pi/catkin_ws/src/drone'
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} mkdir -p ${TARGET_DIR}

# Copy cloned repository to the image
shopt -s dotglob
for dir in ${REPO_DIR}/*; do
  if [[ $dir != *"images" && $dir != *"imgcache" ]]; then
    echo "Copying contents of $dir to ${IMAGE_PATH}$TARGET_DIR"
    ${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy $dir ${TARGET_DIR}
  fi
done

# Копирование файла службы File Browser
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/filebrowser.service' '/etc/systemd/system/'
# Настройка оборудования и установка File Browser
echo_stamp "Setting up hardware and installing File Browser"
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} exec ${SCRIPTS_DIR}'/assets/hardware-setup.sh'
if [ $? -ne 0 ]; then
    echo "Hardware setup or File Browser installation failed. Stopping build."
    exit 1
fi

# Monkey
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/monkey' '/root/'
# rsyslog config
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/rsyslog.conf' '/etc'
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/rsysrot.sh' '/etc/rsyslog.d'
# Butterfly
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/butterfly.service' '/lib/systemd/system/'
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/butterfly.socket' '/lib/systemd/system/'
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/monkey.service' '/lib/systemd/system/'
# software install
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} exec ${SCRIPTS_DIR}'/image-software.sh'
# network setup
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} exec ${SCRIPTS_DIR}'/image-network.sh'
# avahi setup
${BUILDER_DIR}/image-chroot.sh ${IMAGE_PATH} copy ${SCRIPTS_DIR}'/assets/avahi-services/sftp-ssh.service' '/etc/avahi/services'
${BUILDER_DIR}/image-resize.sh ${IMAGE_PATH}

echo_stamp "Build completed successfully. File Browser will be started on first boot."
