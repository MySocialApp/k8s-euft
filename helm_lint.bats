#!/usr/bin/env bats

@test "Rename Chart name to avoid linting error and enable all features" {
    cp kubernetes/Chart.yaml{,.orig}
    cp kubernetes/values.yaml{,.orig}
    sed -ri 's/^(name:)\s*\w+/\1 kubernetes/' kubernetes/Chart.yaml
    sed -ri 's/(\s*enable\w+):\s*false/\1: true/g' kubernetes/values.yaml
}

@test "Checking helm lint" {
    helm lint kubernetes
}

@test "Restore original files" {
    mv kubernetes/Chart.yaml{.orig,}
    mv kubernetes/values.yaml{.orig,}
}