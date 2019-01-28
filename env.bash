#!/usr/bin/env bash

# Detect OS
export os=''
if [ $(grep -i centos /etc/*-release | wc -l) -gt 0 ] ; then
  os=centos
elif [ $(grep -i ubuntu /etc/*-release | wc -l) -gt 0 ] ; then
  os=ubuntu
elif [ $(grep -i debian /etc/*-release | wc -l) -gt 0 ] ; then
  os=debian
else
  echo "OS type not detected"
  exit 1
fi

# Environment variables
export PATH="$HOME/.kubeadm-dind-cluster:/tmp/linux-amd64:$PATH"
export GOPATH=/root GOROOT=/usr/lib/go GOBIN=/usr/bin
export DIND_CLUSTER_SH="dind-cluster-v${K8S_VERSION}.sh"
export DIND_URL=https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/${GIT_REV}/fixed/${DIND_CLUSTER_SH}
export DIND_URL_NEW=https://github.com/kubernetes-sigs/kubeadm-dind-cluster/releases/download/${GIT_REV}/${DIND_CLUSTER_SH}
if [ "$os" == 'centos' ] ; then
  export GOROOT=/usr/lib/golang GOBIN=/bin
fi

# Common useful functions
function ptitle() {
    echo -e '\n########################################'
    echo "$1"
    echo -e '########################################\n'
}

function ptask() {
    echo -e "\n=> $1\n"
}

function check_pod_is_running() {
    KIND="$1"
    POD_FILTERS="$2"
    ROLE=$3
    CURRENT_NODES=0
    READY_NODES=0
    NUM_NODES=$(kubectl get $KIND $POD_FILTERS | tail -1 | awk '{ print $2 }')

    # Ensure the number of desired pod has been bootstraped
    while [ "$CURRENT_NODES" != "$NUM_NODES" ] ; do
        sleep 15
        CURRENT_NODES=$(kubectl get pod $POD_FILTERS | grep Running | wc -l)
        echo "$APP_NAME $ROLE running nodes: $CURRENT_NODES/$NUM_NODES, waiting..." >&3
    done

    # Ensure the state of each pod is fully ready
    while [ "$READY_NODES" != "$NUM_NODES" ] ; do
        sleep 15
        READY_NODES=$(kubectl get po $POD_FILTERS | awk '{ print $2 }' | grep -v READY | awk -F'/' '{ print ($1 == $2) ? "true" : "false" }' | grep true | wc -l)
        echo "$APP_NAME $ROLE running ready nodes: $READY_NODES/$NUM_NODES, waiting..." >&3
    done
}
