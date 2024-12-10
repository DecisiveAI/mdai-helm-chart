## Reduce data flow via Managed Filters

We mentioned we planted an excess amount of data to flow through your telemetry pipelines. 

### What's a managed filter?

MDAI has create a construct known as, *Managed Filters*. They enable our infrastructure to monitor and react to your data streams via configuration. This use case monitors services by a service identifier, `service.name` and a tolerance threshold over a rolling time window using Prometheus' promql. When a given service surpasses your configured threshold, log data that is deemed non-critical (< level `WARN`) will be suppressed and dropped on the floor. 

### Where and how do I modify my managed filter?

If you view the [example_collector.yaml](../../files/example_collector.yaml), you'll notice that there is a block in the config under filters where the filter `mute-noisy-services` is false. 

```yaml
telemetryFiltering:
  filters:
    - name: mute-noisy-services
      enabled: false
      description: filter noisy services
      managedFilter:
        pipelines:
          - logs/customer_pipeline
        filterProcessorConfig:
          logs:
            log_record:
              - 'IsMatch(resource.attributes["service.name"], "<<SERVICE_LIST>>") and attributes["log_level"] == "INFO"'
        alertingRules:
          - name: noisy-service-threshold
            alert_query: 'increase(mdai_log_bytes_received_total{service_name!=""}[6m]) > 5 * 1024 * 1024'
            for: 1m
            severity: warning
            action: manageFilter
```

### Enable your managed filter

Let's enable the filter in [example_collector.yaml](../../files/example_collector.yaml) by changing `enabled: false` to `enabled: true` (approximately ln. 21).


### Update the config in your collector

```bash
kubectl apply -f ./files/example_collector.yaml --namespace mdai
```

### Validate

You can validate that your collector config changed by running the following command

```bash
kubectl -n mdai get configmaps --selector app.kubernetes.io/name=gateway-collector -o yaml
```

You should a similar block to the following under the `processors` section in the yaml output.

```yaml
filter/mdai_mute-noisy-services:
  logs:
    log_record:
      - IsMatch(resource.attributes["service.name"], "service1234|service4321") and attributes["log_level"] == "INFO"
filter/severity:
  error_mode: ignore
  logs:
    log_record:
      - attributes["log_level"] == "INFO"
```

>Note: it is possible the values for the `resource.attributes["service.name"]` will be different if the data generator scripts were changed.

### Let's see it in action

You should be able to jump back over to prometheus and start an investigation for offending service. 

---- 

Next up: [Enabling Managed Filters ➡](./investigate_alerts.md)



