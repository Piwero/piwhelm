# PiwHelm

PiwHelm is a reusable Helm template chart designed to streamline the deployment of various Kubernetes objects, including deployments, configmaps, secrets, and ingress configurations. This Helm library is specifically tailored for deploying applications with Traefik through Cloudflare tunnels within Kubernetes environments.

## TL;DR

PiwHelm simplifies the deployment process of Kubernetes applications with Traefik and Cloudflare tunnels, enabling efficient and consistent setup of essential resources.

## Usage

1. Incorporate PiwHelm as a dependency in your Helm chart's `Chart.yaml` file:

    ```yaml
    dependencies:
      - name: piwhelm
        version: "0.0.6" # or specify the latest version 
        repository: "https://raw.githubusercontent.com/Piwero/piwhelm/master" 

    ```

2. Update dependencies using `helm dependency build` or `helm dependency update` if the version is updated.
3. Create a `config/` directory within your chart and populate it with your `config.yaml`, containing the necessary configmap keys and values.
4. Duplicate the existing `values.tpl` file and rename it to `values.yaml` in your desired directory.
5. Customize the values in `values.yaml` to match the requirements of your application. Ensure to replace the `piwhelm` value under `global` with the name of your new repository.
6. Selectively copy required files from `piwhelm/usable-templates/` to `your-chart/templates/` directory based on your application's needs.
7. Rebuild dependencies with `helm dependency build`.
8. Install your new application using Helm with the following command:

    ```bash
    helm install <NAME_OF_NEW_APP> . --namespace <NAME_OF_NEW_NS> --create-namespace
    ```

## Development

1. Grant execution permissions to all shell scripts within the project:

    ```bash
    find . -name '*.sh' | xargs git update-index --chmod=+x
    ```

2. Set up pre-commit hooks for consistent code quality:

    ```bash
    sh tools/pre-commit-setup.sh
    ```

By following these steps, you can seamlessly integrate PiwHelm into your Helm charts, ensuring smooth and efficient deployment of Kubernetes applications with Traefik and Cloudflare tunnels.

Feel free to contribute and improve PiwHelm by submitting pull requests or reporting issues on the GitHub repository. Your feedback and contributions are greatly appreciated!
