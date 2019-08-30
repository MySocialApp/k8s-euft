#!/bin/bash

set -e

function install() {
    if [ ! -f /tmp/linux-amd64 ] ; then
        echo "Install helm binary"
        wget -q https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O /tmp/helm.tgz
        tar xzfv /tmp/helm.tgz -C /tmp
    fi
}

function clean() {
    echo "Cleaning old helm config"
    rm -Rf ~/.helm
}

function wait_ready() {
    while [ "$(kubectl -n kube-system get pod -l app=helm | grep -c Running)" != "1" ] ; do
        sleep 2
    done
    echo "Helm ready"
    sleep 30
}

function init_local() {
    echo "Deploying helm locally only"
    helm init --client-only
}

function init() {
    echo "Deploy helm on K8S cluster"
    kubectl apply -f tiller.yaml
    helm init --service-account tiller --wait
    wait_ready
}

case "$1" in
    local_install)
        clean
        install
        init_local
    ;;
    install)
        clean
        install
        init
    ;;
    *)
        echo "Usage: $0 <local_install|install>"
        exit 1
esac
