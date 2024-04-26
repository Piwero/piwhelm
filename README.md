# PiwHelm

Reusable Helm template chart to deploy different K8s objects like deployments, configmaps, secrets, ingress ...

## TL;DR

## Usage

1. Create a `Chart.yaml` file for your new app and add

    ```yaml
    dependencies:
      - name: piwhelm
        version: "0.0.6" # or latest version 
        repository: "https://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@raw.githubusercontent.com/Piwero/helm_git_repo/master" 
    ```

2. Run `helm dependency build` or `helm dependency update` if version is updated
3. Create a `config/` directory and add your config.yaml with your configmaps keys and values
4. Copy the existing `values.tpl` file to your desired directory with name `values.yaml`
5. Replace the values from `values.yaml` with the required data for running your application (Don't forget to rename the piwhelm value under global with the name of your new repository)
6. Copy ONLY the files you want to add to your app from `piwhelm/usable-templates/` tp `your-chart/templates/`
7. Run `helm dependency build`
8. Then run `helm install <NAME_OF_NEW_APP> . --namespace <NAME_OF_NEW_NS> --create-namespace

## Development

1. Give execution permissions to all sh files
`find . -name '*.sh' | xargs git update-index --chmod=+x`
2. Install pre-commit
`sh tools/pre-commit-setup.sh`
