#!/usr/bin/env bash

# Load env vars
source $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.bash

# Remove Kubernetes
kind delete cluster