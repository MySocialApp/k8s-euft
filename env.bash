#!/usr/bin/env bash

# Environment variables
export PATH="$HOME/.kubeadm-dind-cluster:/tmp/linux-amd64:$PATH"
export GOPATH=/root GOROOT=/usr/lib/go GOBIN=/usr/bin
export DIND_CLUSTER_SH="dind-cluster-v${K8S_VERSION}.sh"
export DIND_URL=https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/${GIT_REV}/fixed/${DIND_CLUSTER_SH}
export DIND_URL_NEW=https://github.com/kubernetes-sigs/kubeadm-dind-cluster/releases/download/${GIT_REV}/${DIND_CLUSTER_SH}

# Common useful functions
function ptitle() {
    echo -e '\n########################################'
    echo "$1"
    echo -e '########################################\n'
}

function ptask() {
    echo -e "\n=> $1\n"
}

check_pod_is_running() {
    ROLE=$1
    POD_FILTERS="$2"
    KIND="$3"
    CURRENT_NODES=0
    READY_NODES=0
    NUM_NODES=$(kubectl get $KIND $POD_FILTERS | tail -1 | awk '{ print $2 }')

    # Ensure the number of desired pod has been bootstraped
    while [ "$CURRENT_NODES" != "$NUM_NODES" ] ; do
        sleep 15
        CURRENT_NODES=$(kubectl get pod $POD_FILTERS | grep Running | wc -l)
        echo "$app_name $ROLE running nodes: $CURRENT_NODES/$NUM_NODES, waiting..." >&3
    done

    # Ensure the state of each pod is fully ready
    while [ "$READY_NODES" != "$NUM_NODES" ] ; do
        sleep 15
        READY_NODES=$(kubectl get po $POD_FILTERS | awk '{ print $2 }' | grep -v READY | awk -F'/' '{ print ($1 == $2) ? "true" : "false" }' | grep true | wc -l)
        echo "$app_name $ROLE running ready nodes: $READY_NODES/$NUM_NODES, waiting..." >&3
    done
}