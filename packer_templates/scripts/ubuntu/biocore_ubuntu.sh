#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive

echo "update the package list"
apt-get -y update;

echo "install desktop packages"
apt-get -y install lightdm ubuntu-desktop firefox;

echo "install deps for bioinformatics tools"
apt-get -y install default-jre default-jdk perl python3 git wget curl;

echo "install Docker CE"
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker
# apt-get -y remove docker docker-engine docker.io containerd runc;
apt-get -y install apt-transport-https ca-certificates curl software-properties-common;

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -aG docker $USER
usermod -aG docker vagrant

echo "install Apptainer"
apt-get -y install \
    squashfs-tools \
    squashfuse \
    fuse2fs \
    fuse-overlayfs \
    fakeroot \
    cryptsetup \
    uidmap

TEMP_DEB="$(mktemp)" &&
wget -O "$TEMP_DEB" 'https://github.com/apptainer/apptainer/releases/download/v1.1.7/apptainer_1.1.7_amd64.deb' &&
dpkg -i "$TEMP_DEB"
rm -f "$TEMP_DEB"
