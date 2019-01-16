#!/usr/bin/env bash

function ptitle() {
    echo -e '\n########################################'
    echo "$1"
    echo -e '########################################\n'
}

function ptask() {
    echo -e "\n=> $1\n"
}

export PATH="$HOME/.kubeadm-dind-cluster:/tmp/linux-amd64:$PATH"
export GOPATH=/root GOROOT=/usr/lib/go GOBIN=/usr/bin
export DIND_CLUSTER_SH="dind-cluster-v${K8S_VERSION}.sh"
export DIND_URL=https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/${GIT_REV}/fixed/${DIND_CLUSTER_SH}
export DIND_URL_NEW=https://github.com/kubernetes-sigs/kubeadm-dind-cluster/releases/download/${GIT_REV}/${DIND_CLUSTER_SH}
