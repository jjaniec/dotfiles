# metrics-server

Metrics Server collects resource metrics from Kubelets and exposes them in Kubernetes apiserver through Metrics API for use by Horizontal Pod Autoscaler and Vertical Pod Autoscaler for example.

Metrics API can also be accessed by kubectl top, to see the consumption of resources by each pod.

## Documentations

- [Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/metrics-server)

## Manual deployment

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

ENV='dev'
NAMESPACE="tooling"

helm dependency build
helm upgrade --install -n "${NAMESPACE}" metrics-server . -f "values.${ENV}.yaml"
```
