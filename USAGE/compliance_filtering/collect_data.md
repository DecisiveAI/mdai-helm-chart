# Start collecting data

> Note: must be in `mdai` namespace with the datalyzer

## Create the collector 

```bash
# add a collector definition 
kubectl apply -f ./files/example_collector.yaml --namespace mdai
```

>Note: If you were unable to successfully run this command, see our troubleshooting guide, [collector issues](./troubleshooting.md#collector-issues).


## Ensure your collector pod is up and running. 

```bash
kubectl -o wide -n mdai get pods --selector app.kubernetes.io/name=gateway-collector
```

## Review your configmap

You can review your collector config by running the following command: 

```bash
kubectl -n mdai get configmaps --selector app.kubernetes.io/name=gateway-collector -o yaml
```

## Collector ready for use!

You now have fake data that's being generated and logged. Your next step will be to set up a collector that the logs can be sent to.

----

<br />
<br />

[Next step: Forward logs to OTel!](./forward_data.md)
