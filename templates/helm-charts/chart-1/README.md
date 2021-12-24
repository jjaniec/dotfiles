# chart-name

## Manual installation

```
helm repo add repo https://x.github.io/charts

NAMESPACE="tooling"
CHART="chart-name"
helm upgrade --install "${CHART}" --namespace "${NAMESPACE}" repo/"${CHART}"
```
