# Inspecting your data pipelines

We are using Prometheus to aggregate metrics that provide summaries of your data based on the data type and service identifiers.

## Choose your adventure...

You can view this data in Grafana, or directly in Prometheus.

1. [Grafana](#grafana) (\*recommended\*\*\*)
2. [Prometheus](#prometheus)

## Grafana

### Install Grafana + dashboard

To see Grafana dashboards for filtering data, first port forward your grafana instance

```sh
kubectl -n mdai port-forward svc/mdai-grafana 3000:80
```

> Use the username `admin`. The login password for your Grafana instance is defined in `values_grafana.yaml`

### Grafana dashboard

View summaries of you metric using the [MDAI Data Monitoring Dashboard](http://localhost:3000/d/de3xf8bc3h6v4b/mdai-data-management?from=now-5m&to=now&timezone=browser&showCategory=Tooltip) in Grafana. You will need that password you generated earlier

---

Skip ahead! [E2E data flowing](#data-is-now-flowing-end-to-end)

---

## Prometheus

## Port-forward Prometheus service

We will use the Prometheus expression browser to run queries.

> Note: The pod name `prometheus-mdai-kube-prometheus-stack-prometheus-0` should work however, to ensure a valid pod name, you should be able to use autocomplete to find the Prometheus pod.

```bash
kubectl -n mdai port-forward prometheus-mdai-kube-prometheus-stack-prometheus-0 9090:9090
```

You can now navigate to [localhost:9090](http://localhost:9090).

You should see the Expression Browser ready for use, as shown below.

![prom_expression_browser](../../media/prometheus_expr_window.png)

## Start querying

> Note: You must have your prometheus pod port-forwarded to port 9090 for the following links to work.

**Choose your adventure:**

1. [Manual Query](#manual-query) - Go through adding queries step by step.
2. [Auto Query](#auto-query) - Automatically view all queries from manual query process.

### Manual Query

_Before you start querying using these promQL queries, see to use an autopopulated link containing all the queries. If you prefer to go step by step_

Report metrics from all services.

```promql
increase(
  sum by (service_name) (
    mdai_log_bytes_sent_total
  )[6m:]
)
```

Report metrics from non-noisy services

```promql
increase(
  sum by (service_name) (
    mdai_log_bytes_sent_total{service_name!~"service1234|service4321"}
  )[6m:]
)
```

Report metrics from only noisy (`service1234`) and extra noisy (`service4321`) services.

```promql
increase(
  sum by (service_name) (
    mdai_log_bytes_sent_total{service_name=~"service1234|service4321"}
  )[6m:]
)
```

### Auto Query

These are preloaded links with panels populated from the above queries

#### Link 1 - <a href="http://localhost:9090/graph?g0.expr=increase(%0A%20%20sum%20by%20(service_name)%20(%0A%20%20%20%20mdai_log_bytes_sent_total%0A%20%20)%5B6m%3A%5D%0A)&g0.tab=0&g0.display_mode=lines&g0.show_exemplars=0&g0.range_input=15m&g1.expr=increase(%0A%20%20sum%20by%20(service_name)%20(%0A%20%20%20%20mdai_log_bytes_sent_total%7Bservice_name!~%22service1234%7Cservice4321%22%7D%0A%20%20)%5B6m%3A%5D%0A)&g1.tab=0&g1.display_mode=lines&g1.show_exemplars=0&g1.range_input=15m&g2.expr=increase(%0A%20%20sum%20by%20(service_name)%20(%0A%20%20%20%20mdai_log_bytes_sent_total%7Bservice_name%3D~%22service1234%7Cservice4321%22%7D%0A%20%20)%5B6m%3A%5D%0A)&g2.tab=0&g2.display_mode=lines&g2.show_exemplars=0&g2.range_input=15m" target="_blank">All queries</a>

This link has the following panels

- Panel 1 - Metrics for all services together
- Panel 2 - Metrics for all non-noisy services
- Panel 3 - Metrics for noisy service (`service1234`) and extra noisy service (`service4321`)

<br />

#### Additional auto-query links

Check back for more dashboards soon.

## Data is now flowing end-to-end

You can now see data flowing through your telemtery pipelines.

_...but wait... is there too much!?_

We've planted a minor issue in the generators where they are emitting more data than you would potentially want. Let's reduce their data flow!

---

Next up: [Enabling Managed Filters ➡](./managed_filters.md)
