# MDAI Helm chart

This is the official Helm chart for [MyDecisive.ai](https://www.mydecisive.ai/), an open-core solution for monitoring and managing OpenTelemetry pipelines on Kubernetes.

## Install MDAI

### Without cert-manager

To install via Helm, run the following command.

```sh
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --dependency-update --wait-for-jobs -f values.yaml -f values_prometheus.yaml -f values_grafana.yaml mdai .
```

Alternatively, add the Helm repository first and scan for updates

```bash
helm repo add mdai https://decisiveai.github.io/mdai-helm-charts
helm repo update
```

### With cert-manager

```sh
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --dependency-update --wait-for-jobs --set mdai-operator.webhooks.certManager.enabled=true --set mdai-operator.webhooks.autoGenerateCert.enabled=false -f values.yaml -f values_prometheus.yaml -f values_grafana.yaml mdai .
```

### Without cleanup on uninstall

```sh
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --dependency-update --wait-for-jobs --set cleanup=false -f values.yaml -f values_prometheus.yaml -f values_grafana.yaml mdai .
```

see `values.yaml` for other options.

## Use Cases

- [Compliance and Dynamic Filtering](./usage/compliance_filtering/start_here.md)

_Stay tuned! More coming soon!_

## Learn more

- Visit our [solutions page](https://www.mydecisive.ai/solutions) for more details MyDecisive's approach to composable observability.
- Head to our [docs](https://docs.mydecisive.ai/) to learn more about MyDecisive's tech.

## Info and Support

- Contact [support@mydecisive.ai](mailto:support@mydecisive.ai) for assistance or to talk to with a member of our support team
- Contact [info@mydecisive.ai](mailto:info@mydecisive.ai) if you're interested in learning more about our solutions
