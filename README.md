# MDAI Helm chart

This is the official Helm chart for [MyDecisive.ai](https://www.mydecisive.ai/), an open-core solution for monitoring and managing OpenTelemetry pipelines on Kubernetes. 

## Install MDAI

### Without cert-manager

To install via Helm, run the following command.

```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs mdai .
```

Alternatively, add the Helm repository first and scan for updates

```bash
helm repo add mdai https://decisiveai.github.io/mdai-helm-charts
helm repo update
```

### With cert-manager

```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set mdai-operator.webhooks.certManager.enabled=true --set mdai-operator.webhooks.autoGenerateCert.enabled=false mdai .
```

### Without Prometheus operator/CRDs
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set kube-prometheus-stack.crds.enabled=false --set kube-prometheus-stack.prometheusOperator.enabled=false mdai .
```

### With Grafana GUI externally exposed
AWS ALB managed by the AWS Load Balancer Controller will be provisioned. Plain HTTP Listener will be configured by default. See `values.yaml` `grafana.ingress.annotations` section for ALB Listener SSL configuration.
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set kubeprometheusstack.grafana.ingress.enabled=true mdai .
```

### Without Grafana
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs -f without_grafana.yaml mdai .
```

### Without cleanup on uninstall

```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set cleanup=false mdai .
```

see `values.yaml` for other options.

## Use Cases

- [Compliance and Dynamic Filtering](./USAGE/compliance_filtering/start_here.md)

*Stay tuned! More coming soon!*

## Learn more

* Visit our [solutions page](https://www.mydecisive.ai/solutions) for more details MyDecisive's approach to composable observability. 
* Head to our [docs](https://docs.mydecisive.ai/) to learn more about MyDecisive's tech.

## Info and Support 

* Contact [support@mydecisive.ai](mailto:support@mydecisive.ai) for assistance or to talk to with a member of our support team
* Contact [info@mydecisive.ai](mailto:info@mydecisive.ai) if you're interested in learning more about our solutions
