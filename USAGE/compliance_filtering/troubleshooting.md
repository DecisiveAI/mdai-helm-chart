# Troubleshooting - Compliance and filtering

## Known issues

### Collector issues

#### Issue - measure volumes must be enabled

```
Error from server (Forbidden): error when creating "./example_collector.yaml": admission webhook "vmydecisiveengine.kb.io" denied the request: measure volumes must be enabled for managed filters, filter: mute-noisy-services, cluster: mydecisiveengine-sample
```

To fix this, you must choose what your objective is.

##### Option 1 - Disable Manged Filters and Volume measurement

Verify/change the [example_collector.yaml](../../files/example_collector.yaml) `measureVolumes` and managed filters flag(s) are set to `false`.

```yaml
collectors:
  -
    name: "gateway"
    enabled: true
    measureVolumes:
      enabled: false  ----> enabled: false
```

and 

```yaml
telemetryFiltering:
  filters:
    - name: mute-noisy-services
      enabled: true   ----> enabled: false
      description: filter noisy services
      managedFilter:
```

##### Option 2 - Disable Volume measurement without managed filters

Verify/change the [example_collector.yaml](../../files/example_collector.yaml) `measureVolumes` is set to `true`, and that the managed filter flags(s) are set to `false`.

```yaml
collectors:
  -
    name: "gateway"
    enabled: true
    measureVolumes:
      enabled: false  --> enabled: true
```

and 

```yaml
telemetryFiltering:
  filters:
    - name: mute-noisy-services
      enabled: true   ----> enabled: false
      description: filter noisy services
      managedFilter:
```

##### Option 3 - Enable both volume measurement and managed filters

Verify/change the [example_collector.yaml](../../files/example_collector.yaml) `measureVolumes` and managed filter flag(s) are set to `true`.

```yaml
collectors:
  -
    name: "gateway"
    enabled: true
    measureVolumes:
      enabled: false  --> enabled: true
```

and 

```yaml
telemetryFiltering:
  filters:
    - name: mute-noisy-services
      enabled: true   ----> enabled: true
      description: filter noisy services
      managedFilter:
```
