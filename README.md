# K8s End User Funtional Testing (k8s-euft)

We've made this repository to be able to replicate a kubernetes cluster and run functional tests.

We're using [Kubeadm DIND Cluster](https://github.com/kubernetes-sigs/kubeadm-dind-cluster) to quickly deploy a Kubernetes testing cluster.

To perform automatic tests, you can use:
* [Travis CI](https://travis-ci.org/) for remote testing
* [Vagrant](https://www.vagrantup.com/) for local testing

## Install

Simply create a `tests` folder inside your repository and add this repository as a submodule (or simply clone it if you don't want to use submodules):

```bash
mkdir tests && cd tests
git submodule add git@github.com:MySocialApp/k8s-euft.git
```

## Usage with Travis

First, of all, setup a travis-ci account, link it to your repository and create `.travis.yml` file in the root directory of your repository with this content:

```yaml

---
language: go
sudo: required

env:
  - K8S_VERSION=1.9 HELM_VERSION=2.9.1 NUM_NODES=3 SKIP_SNAPSHOT=y PATH="$HOME/.kubeadm-dind-cluster:/tmp/linux-amd64:$PATH"
  - K8S_VERSION=1.8 HELM_VERSION=2.9.1 NUM_NODES=3 SKIP_SNAPSHOT=y PATH="$HOME/.kubeadm-dind-cluster:/tmp/linux-amd64:$PATH"

install:
  - tests/k8s-euft/helm.sh local_install
  - bats tests/k8s-euft/helm_lint.bats
  - tests/k8s-euft/bootstrap_k8s.sh
  - tests/k8s-euft/helm.sh install

script:
  - **run your_tests here**
```

The `env` section describes the environment variables for:
* K8S_VERSION: the Kubernetes version you want to deploy
* HELM_VERSION: the helm version you want to deploy
* NUM_NODES: the number of non master nodes you need in your cluster

The `install` section will perform helm linting checks, Kubernetes install and deploy helm on this newly create Kubernetes cluster.

Finally, in the `script` section, set all your tests files or folders you want to apply.

## Usage with Vagrant

If you want to also run those tests locally, a basic go script helps to read travis config and run it. So you'll need a travis.yaml file as well that wee be deployed inside your VM.

Here is an example of a basic `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|

  config.vm.box = "deimos_fr/debian-stretch"
  config.vm.synced_folder "..", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
      vb.cpus = 4
      vb.memory = "8096"
  end

  config.vm.network "private_network", type: "dhcp"

  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant_data
    source tests/k8s-euft/env.bash
    tests/k8s-euft/prerequisites.sh
    go run tests/k8s-euft/travis-exec.go .travis.yml
  SHELL
end
```
To perform tests, simply run `Vagrant up`.

## Projects using k8s-euft
* [MySocialApp Cassandra Helm chart](https://github.com/MySocialApp/kubernetes-helm-chart-cassandra)
* [MySocialApp Traefik Helm chart](https://github.com/MySocialApp/kubernetes-helm-chart-traefik)
