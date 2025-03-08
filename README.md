# MDAI Helm chart

This is the official Helm chart for [MyDecisive.ai](https://www.mydecisive.ai/), an open-core solution for monitoring and managing OpenTelemetry pipelines on Kubernetes. 

> After initial checkout, switching branches or modifying `Chart.yaml`, run `helm dependency update . --repository-config /dev/null`

## Prerequisites
- Kubernetes 1.24+
- Helm 3.9+
- [cert-manager](https://cert-manager.io/docs/)

## Add repository
```bash
helm repo add mdai https://decisiveai.github.io/mdai-helm-charts
helm repo update
```
_See [`helm repo`](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install MDAI helm chart

```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs mdai .
```

### Without Prometheus operator/CRDs
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set kubeprometheusstack.crds.enabled=false --set kubeprometheusstack.prometheusOperator.enabled=false --set kubeprometheusstack.nodeExporter.enabled=false mdai .
```
When this option is chosen, make sure existing Prometheus Operator's configuration allows to manage Custom Resources in the above namespace
Prometheus NodeExporter  installation is disabled as it's considered deployed along with the Prometheus Operator.

### Without Prometheus CRDs. Prometheus Operator will be installed.
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set kubeprometheusstack.crds.enabled=false --set kubeprometheusstack.nodeExporter.enabled=false mdai .
```
When this option is chosen, make sure existing Prometheus Operator's configuration allows to manage Custom Resources in the above namespace
Prometheus NodeExporter  installation is disabled as it's considered deployed along with the Prometheus Operator.


### Without Grafana
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs -f without_grafana.yaml mdai .
```

### Without cleanup on uninstall

```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set cleanup=false mdai .
```

### With persistent storage for Prometheus and Valkey.

[Persistent storage](./PV.md)

see `values.yaml` for other options.

## Upgrading Chart

```console
helm upgrade [RELEASE_NAME] prometheus-community/kube-prometheus-stack
```

With Helm v3, CRDs created by this chart are not updated by default and should be manually updated.
Consult also the [Helm Documentation on CRDs](https://helm.sh/docs/chart_best_practices/custom_resource_definitions).

## Use Cases

- [Compliance and Dynamic Filtering](./USAGE/compliance_filtering/start_here.md)

*Stay tuned! More coming soon!*

## Learn more

* Visit our [solutions page](https://www.mydecisive.ai/solutions) for more details MyDecisive's approach to composable observability. 
* Head to our [docs](https://docs.mydecisive.ai/) to learn more about MyDecisive's tech.

## Info and Support 

* Contact [support@mydecisive.ai](mailto:support@mydecisive.ai) for assistance or to talk to with a member of our support team
* Contact [info@mydecisive.ai](mailto:info@mydecisive.ai) if you're interested in learning more about our solutions
