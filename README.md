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
        repository: "https://raw.githubusercontent.com/Piwero/piwhelm/gh-pages" 

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

## Secrets and Image Pull Secrets

PiwHelm now uses Helm best practices for secrets management:

- **Required fields**: If a required value (e.g., secret name, image credentials) is missing, Helm will fail fast with a clear error message.
- **Enabled flags**: Only secrets with `enabled: true` are rendered.
- **Defaults**: Secret types default to `Opaque` if not specified.
- **Base64 encoding**: All secret data is automatically base64 encoded.
- **External secrets**: Now defaults to 1Password integration. The `storeName` for external secrets is set to `1password` by default, making it easy to use 1Password as your secret manager. You can override this if needed.
- **Image pull secrets**: Docker registry credentials are securely encoded and rendered only if `imageCredentials.enabled` is true.

### Example values.yaml

```yaml
global:
  <chartName>:
    secrets:
      imageCredentials:
        name: my-credentials # required if enabled
        enabled: true
        registry: quay.io # required if enabled
        username: someone # required if enabled
        password: sillyness # required if enabled
        email: someone@host.com # required if enabled
      otherSecrets:
        - name: secret1
          enabled: true
          type: Opaque
          data:
            secretkey1: value1
            secretkey2: value2
      externalSecrets:
        - name: external-secret-1
          apiVersion: external-secrets.io/v1
          kind: ClusterSecretStore
          storeName: 1password # default for 1Password integration
          data:
            - secretKey: API_TOKEN
              remoteRef:
                key: my-1password-item-id # 1Password item ID
                property: credential # 1Password field name
            - secretKey: EMAIL
              remoteRef:
                key: my-1password-item-id
                property: email
```

### Error Handling

If any required field is missing, Helm will fail with a descriptive error. This ensures robust and predictable deployments.

Refer to the templates in `charts/piwhelm/templates/` for more details on how secrets are rendered.

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
