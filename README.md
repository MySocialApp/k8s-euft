# K8s End User Funtional Testing (k8s-euft)

We've made this repository to be able to replicate a kubernetes cluster and run functional tests as simply as possible with the less dependencies as possible.

You know that it can be hard to test and this is can be critic for some services like stateful applications.
That's why this tooling exist, to perform automatic tests, you can use:
* [Travis CI](https://travis-ci.org/) for remote testing
* [Vagrant](https://www.vagrantup.com/) for local testing

We're using [Kubeadm DIND Cluster](https://github.com/kubernetes-sigs/kubeadm-dind-cluster) to quickly deploy a Kubernetes testing cluster.

Then you can use your favorite framework/language to perform your tests.

## Install

Simply create a `tests` folder inside your repository and add this repository as a submodule (or simply clone it if you don't want to use submodules):

```bash
mkdir tests && cd tests
git submodule add git@github.com:MySocialApp/k8s-euft.git
cat k8s-euft/examples/.gitignore >> ../.gitignore
```

## Usage with Travis

First, of all, setup a travis-ci account, link it to your repository and create `.travis.yml` file in the root directory of your repository.

You can use the [travis example file](examples/.travis.yaml):

```bash
cp k8s-euft/examples/.travis.yaml ../.travis.yaml
```

The `env` section describes the environment variables for:
* K8S_VERSION: the Kubernetes version you want to deploy
* GIT_REV: the git commit/tag/branch to pin on Kubeadm DIND Cluster
* HELM_VERSION: the helm version you want to deploy
* NUM_NODES: the number of non master nodes you need in your cluster

The `install` section will perform helm linting checks, Kubernetes install and deploy helm on this newly create Kubernetes cluster.

Finally, in the `script` section, set all your tests files or folders you want to apply.

## Usage with Vagrant

If you want to also run those tests locally, a basic go script helps to read travis config and run it. So you'll need a travis.yaml file as well that will be deployed inside your VM.

You can use the [Vagrant example config](examples/Vagrantfile):

```bash
cp k8s-euft/examples/Vagrantfile .
```

To perform tests, simply run `Vagrant up`.

## Make basic tests

In the examples folder, you'll find a simple use case to start. To initialize it, simply copy those files:

```bash
cp k8s-euft/examples/run_tests.sh .
```

## Projects using k8s-euft

* [MySocialApp Cassandra Helm chart](https://github.com/MySocialApp/kubernetes-helm-chart-cassandra)
* [MySocialApp Traefik Helm chart](https://github.com/MySocialApp/kubernetes-helm-chart-traefik)
* [MySocialApp Elasticsearch Helm chart](https://github.com/MySocialApp/kubernetes-helm-chart-elasticsearch)
* [MySocialApp RabbitMQ Helm chart](https://github.com/MySocialApp/kubernetes-helm-chart-rabbitmq)
