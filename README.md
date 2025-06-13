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
```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs mdai mdai/mdai-hub
```

### ⚠️ Required Step: Self-observability setup ⚠️

The mdai-helm-chart-installed mdai-operator and mdai-gateway expect a destination to send their logs to, but this chart does not manage deploying the logs destination for those services. 

The mdai-operator can manage an opinionated and configured collector called mdai-collector that will send logs from these services to S3.

#### Option A: Using mdai-collector to collect component telemetry

You will need to set up an [AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/GetStartedWithS3.html) bucket for this.


> ℹ️ AWS S3 are the only supported destinations for sending logs through the mdai-collector. You will need to provide a AWS access key with PutObject permissions to the destination S3 bucket in a secret present in the same namespace as the mdai-collector.

In order to send telemetry to a managed mdai-collector, you will want to deploy the MdaiCollector custom resource and a Secret containing AWS credentials. 

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: aws-credentials
  namespace: mdai
type: Opaque
stringData:
  AWS_ACCESS_KEY_ID: <secret-key-id-here>
  AWS_SECRET_ACCESS_KEY: <secret-access-key-here>
---
apiVersion: hub.mydecisive.ai/v1
kind: MdaiCollector
metadata:
  namespace: mdai
  name: hub-monitor
spec:
  aws:
   awsAccessKeySecret: aws-credentials
  logs:
   s3:
     s3Region: "us-east-1"
     s3Bucket: "mdai-hub-logs"
```

> ℹ️ The above name (`hub-monitor`) must correspond to the beginning of the host name in the `values.yaml` for the [operator](https://github.com/DecisiveAI/mdai-helm-chart/blob/422e1c345806f634ed92db2a67a672ed7e9c7101/values.yaml#L52) and [mdai-gateway](https://github.com/DecisiveAI/mdai-helm-chart/blob/422e1c345806f634ed92db2a67a672ed7e9c7101/values.yaml#L59). So if the MdaiCollector resource name is `hub-monitor`, the corresponding service endpoint created is `http://hub-monitor-mdai-collector-service.mdai.svc.cluster.local:4318`.

#### Option B: Send hub component logs to a custom OTLP HTTP destination

You can update the `values.yaml` for the [operator](https://github.com/DecisiveAI/mdai-helm-chart/blob/422e1c345806f634ed92db2a67a672ed7e9c7101/values.yaml#L52) and [mdai-gateway](https://github.com/DecisiveAI/mdai-helm-chart/blob/422e1c345806f634ed92db2a67a672ed7e9c7101/values.yaml#L59) to send logs to a destination of your choosing that accepts OTLP HTTP logs.

#### Option C: Disable OTEL Logging for components in this chart

If you do not want to send logs from these components, you can disable sending logs by updating the `values.yaml` by setting `mdai-operator.manager.env.otelSdkDisabled` and `mdai-gateway.otelSdkDisabled` to `"true"` (a string value, not boolean).

> ℹ️ To stop logs from sending to s3, you will need to delete the MdaiCollector Custom Resource
---

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


### Without cleanup on uninstall

```bash
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --wait-for-jobs --set cleanup=false mdai .
```

### With persistent storage for Prometheus and Valkey.

[Persistent storage](./PV.md)

see `values.yaml` for other options.

## Upgrading Chart

```shell
helm upgrade mdai mdai/mdai-hub
```
A major chart version change (like 0.6.5 to 0.7.0) indicates that there are incompatible breaking changes needing manual actions.

>With Helm v3, CRDs created by this chart are not updated by default and should be manually updated.
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
