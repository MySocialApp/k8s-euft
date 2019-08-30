#!/usr/bin/env bash

#set -x

num_nodes_set() {
    echo "Ensure number of nodes is set: $NUM_NODES"
    [ ! -z $NUM_NODES ]
}

num_nodes_are_labeled_as_node() {
    label='node-role.kubernetes.io/node=true'

    counter=1
    for node in $(kubectl get nodes | awk '/kind-worker/{ print $1 }') ; do
        if [ $counter -gt $NUM_NODES ] ; then
            exit 0
        fi
        kubectl label nodes $node node-role.kubernetes.io/node=true --overwrite
        counter=$((counter + 1))
    done
}

