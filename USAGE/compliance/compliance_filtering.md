# Use Case: Compliance and Dynamic Filtering

## The tech stack
This sets up a cluster with the following technologies: 
- MDAI infra
- Fluentd
- MinIO


## What does this use case provide?

An end-to-end mocked example for collecting log data from services/infrastructure, stream processing and forwarding of that log data to either a compliance store or an `otlp-http` endpoint.

### Log data generation and forwarding

- Spins up small batches of log generators that will appear to send logs for 1001 services
  - Service with `service.name` attribute of `service9999` will be really noisy
  - More can be spun up using the `example_log_generator` manifests

### Compliance
- All data collected will be filtered down to ERROR/WARNING logs and stored in MinIO.
  - MinIO can be accessed for verification of logs at rest

### Dynamic Filtering
- Filters any service's INFO logs that sends more than 5MB in the last 6 minutes


## Setup

### Create a new cluster via kind

*Note: you will need kind and docker installed to run the following step*

```sh
kind create cluster --name mdai
```
## Add helm repos

```sh
# add MinIO
helm repo add minio https://charts.min.io/

# add Fluent
helm repo add fluent https://fluent.github.io/helm-charts

# update helm repo
helm repo update
```

## Install min.io

```sh
helm install minio minio/minio --values values_minio.yaml
```

### Install MDAI without cert-manager 

*If you have already done this from our [Installation steps](../README.md#without-cert-manager) feel free to skip to the next step.*

```sh
helm upgrade --install --create-namespace --namespace mdai --cleanup-on-fail --dependency-update --wait-for-jobs -f values.yaml -f values_prometheus.yaml mdai .
```

### Validate 

You can verify that your pods are all up and running with the following command

```sh
kubectl get pods -A
```

The output should look something like...
![get pods](../media/get_pods.png)


## Congrats

You've now installed the `mdai` infrastructure and are ready to generate data to send to your new telemetry pipelines.


----


Next step: [Generating data](generate_data.md)