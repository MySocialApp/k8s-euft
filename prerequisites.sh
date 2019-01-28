#!/usr/bin/env bash

if [ -f /tmp/bootstrap.done ] ; then
  echo "Kubernetes is already installed, skipping prerequisites step"
  exit 0
fi

# Install prerequisite for Docker
if [ "$os" == 'debian' ] || [ "$os" == 'ubuntu' ] ; then
  apt-get update
  apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common bats golang jq socat
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  apt-get update
  apt-get -y install docker-ce
elif [ "$os" == 'centos' ] ; then
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  yum install -y yum-utils device-mapper-persistent-data lvm2 bats golang jq socat
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum install -y docker-ce
  systemctl start docker
fi

# Grab go dependencies
cd /vagrant_data/tests/k8s-euft
source env.bash
go get
