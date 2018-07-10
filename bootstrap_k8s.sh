#!/usr/bin/env bash

set -e

if [ -z $K8S_VERSION ] ; then
    echo "Please set K8S_VERSION variable"
    exit 1
fi

# Kubernetes info

GIT_REV=${GIT_REV:-master}
echo "K8S_VERSION: $K8S_VERSION"
echo "GIT_REV: $GIT_REV"

# Load env vars
source $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.bash

# Download and run k8s
echo "Downloading $DIND_CLUSTER_SH"
rm -f ${DIND_CLUSTER_SH}
wget ${DIND_URL}
chmod +x ${DIND_CLUSTER_SH}
echo "Launching Kubernetes install"
./${DIND_CLUSTER_SH} up