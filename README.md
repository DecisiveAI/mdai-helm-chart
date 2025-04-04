# MDAI Helm chart

This is the official Helm chart for [MyDecisive.ai](https://www.mydecisive.ai/), an open-core solution for monitoring and managing OpenTelemetry pipelines on Kubernetes. 

_After initial checkout, switching branches or modifying `Chart.yaml`, run `helm dependency update . --repository-config /dev/null`_

## Prerequisites
- Kubernetes 1.24+
- Helm 3.9+
- [cert-manager](https://cert-manager.io/docs/)

## Add Helm repository
```bash
helm repo add mdai https://decisiveai.github.io/mdai-helm-charts
helm repo update
```
_See [`helm repo`](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install MDAI helm chart
> mdai-hub is not released yet, until then you can use older mdai-cluster chart
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs mdai mdai/mdai-hub
```

### Without Prometheus operator/CRDs
If you already have Prometheus operator installed and would like to use it for your mdai hub:
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set kubeprometheusstack.crds.enabled=false --set kubeprometheusstack.prometheusOperator.enabled=false --set kubeprometheusstack.nodeExporter.enabled=false mdai mdai/mdai-hub
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

```shell
helm upgrade mdai mdai/mdai-cluster
```
A major chart version change (like 0.6.5 to 0.7.0) indicates that there are incompatible breaking changes needing manual actions.

>With Helm v3, CRDs created by this chart are not updated by default and should be manually updated.
Consult also the [Helm Documentation on CRDs](https://helm.sh/docs/chart_best_practices/custom_resource_definitions).

### Upgrade from 0.6.x to 0.7.0
Run these commands to update the CRDs before applying the upgrade:
```shell
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/DecisiveAI/mdai-helm-chart/refs/heads/main/upgrade/0.7/mdaihub-crd.yaml
```
Deploy 0.7.x helm chart
```shell
helm upgrade --install --namespace mdai --wait-for-jobs --set [YOUR-ADDITIONAL-SETTINGS] mdai mdai/mdai-cluster
```
### Upgrade from 0.7.0 to 0.7.1
Run these commands to update the CRDs before applying the upgrade:
```shell
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/DecisiveAI/mdai-helm-chart/refs/heads/main/upgrade/0.7.1/mdaihub-crd.yaml
```
>**Important**: Starting with the 0.7.1 release, the minimum supported observer image is `0.1.3`. If you are using custom `observerResources` that override the default image, please update them to at least 0.1.3.  

Deploy 0.7.1 helm chart
```shell
helm upgrade --install --namespace mdai --wait-for-jobs --set [YOUR-ADDITIONAL-SETTINGS] mdai mdai/mdai-cluster
```
## Use Cases

- [Compliance and Dynamic Filtering](./USAGE/compliance_filtering/start_here.md)

*Stay tuned! More coming soon!*

## Learn more

* Visit our [solutions page](https://www.mydecisive.ai/solutions) for more details MyDecisive's approach to composable observability. 
* Head to our [docs](https://docs.mydecisive.ai/) to learn more about MyDecisive's tech.

## Info and Support 

* Contact [support@mydecisive.ai](mailto:support@mydecisive.ai) for assistance or to talk to with a member of our support team
* Contact [info@mydecisive.ai](mailto:info@mydecisive.ai) if you're interested in learning more about our solutions
