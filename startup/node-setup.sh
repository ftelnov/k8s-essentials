#!/bin/bash

sudo head -n -1 /etc/fstab > temp_fstab; sudo mv temp_fstab /etc/fstab
echo "Swap is disabled"

sudo apt update > /dev/null
sudo apt install curl > /dev/null

curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null
sudo sh get-docker.sh

echo "{"exec-opts": ["native.cgroupdriver=systemd"]}" > /etc/docker/daemon.json
sudo systemctl restart docker

curl -fsSL https://raw.githubusercontent.com/ftelnov/k8s-essentials/master/startup/kubeadm_install.sh -o get-kubeadm.sh > /dev/null

sudo sh get-kubeadm.sh
echo "You need to reboot ur system now in order to disable swap completely and continue using kubeadm. Pls make it using 'sudo reboot'"
