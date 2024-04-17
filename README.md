# PiwHelm

Reusable Helm template chart to deploy different K8s objects like deployments, configmaps, secrets, ingress ...

## TL;DR

## Usage

* For configmaps:

1. Create a `config/` directory and add your config.yaml there

## Development

1. Give execution permissions to all sh files
`find . -name '*.sh' | xargs git update-index --chmod=+x`
2. Install pre-commit
`sh tools/pre-commit-setup.sh`
