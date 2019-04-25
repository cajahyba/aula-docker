#!/bin/bash
sudo apt-get update

sudo apt-get -y install git build-essential

sudo apt-get -y install curl apt-transport-https ca-certificates software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

sudo apt-get -y install  docker-compose docker docker-ce

sudo groupadd docker

sudo usermod -aG docker $USER
