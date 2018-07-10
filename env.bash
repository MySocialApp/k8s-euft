#!/usr/bin/env bash
export PATH="$HOME/.kubeadm-dind-cluster:/tmp/linux-amd64:$PATH"
export GOPATH=/root GOROOT=/usr/lib/go GOBIN=/usr/bin
export DIND_CLUSTER_SH="dind-cluster-v${K8S_VERSION}.sh"
export DIND_URL=https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/${GIT_REV}/fixed/${DIND_CLUSTER_SH}