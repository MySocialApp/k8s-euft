#!/usr/bin/env bash

set -e
set -x

if [ -f /tmp/bootstrap.done ] ; then
  echo "Kubernetes is already installed, skipping install step"
  exit 0
fi

if [ -z $K8S_VERSION ] ; then
    echo "Please set K8S_VERSION variable"
    exit 1
fi

if [ -z $NUM_NODES ] ; then
    echo "Please set NUM_NODES variable"
    exit 1
elif [ $NUM_NODES -lt 1 ]; then
    echo "NUM_NODES variable value should be at least equal to 1"
    exit 1
fi

if [ $(kind get clusters | grep -c kind) == 1 ] ; then
    echo "Kubernetes is already installed, skipping install"
    exit 0
fi

# Load env vars
source $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.bash

# Download and run k8s
echo "Downloading Kind and kubectl"
curl -sLo ./kind https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-$(uname)-amd64
curl -sLo ./kubectl https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl
chmod +x ./kind ./kubectl
mv kind kubectl /usr/bin/

echo "Generating kind config"
echo 'kind: Cluster
apiVersion: kind.sigs.k8s.io/v1alpha3
nodes:
- role: control-plane' > kind.config
for i in `seq 1 $NUM_NODES`; do
    echo '- role: worker' >> kind.config
done

echo "Launching Kubernetes install"
kind create cluster --config kind.config --image kindest/node:v${K8S_VERSION}
if [ $? == 0 ] ; then
    touch /tmp/bootstrap.done
    rm -f kind.config
else
    echo "Error during Kubernetes bootstrap"
    exit 1
fi

echo "Set this cluster as default one"
if [ ! -f ~/.kube/config ] ; then
    cp $(kind get kubeconfig-path --name="kind") ~/.kube/config
else
    echo "Can't copy kube config to default location because you already have one"
fi

echo "Setup bashrc for kubectl and helm"
echo PATH="$PATH" >> ~/.bashrc