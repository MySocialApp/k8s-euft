#!/usr/bin/env bash

# Install prerequisite for Docker and yq
apt-get update
apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common \
                   bats golang jq
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update

# Install Docker and yq
apt-get -y install docker-ce

# Grab go dependencies
cd /vagrant_data/tests/k8s-euft
source env.bash
go get
