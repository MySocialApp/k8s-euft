#!/usr/bin/env bash

set -e

source tests/k8s-euft/env.bash

ptitle "Prepare cluster"
bats tests/play/prepare.bats

#ptitle "Regular deploy"
#bats tests/play/deploy.bats
#bats tests/play/remove_chart.bats

#ptitle "Upgrade from previous commit"
#last_commit=$(git rev-parse HEAD)
#ptask "Checkout previous commit"
#git checkout HEAD~ 2>/dev/null
#bats tests/play/deploy.bats
##ptask "Checkout latest commit and upgrade"
#git checkout $last_commit 2>/dev/null
#bats tests/play/upgrade.bats

echo "All tests passed :)"