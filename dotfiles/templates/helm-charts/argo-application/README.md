# Argo-application

Chart to deploy argocd applications with kubernetes resources in a helm chart instead of creating each argo application on the interface.

## Docs

- [Declarative setup](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#applications)
- [App of apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern)

```bash
kubectl explain applications.argoproj.io
```

## Deployment

### This deployment should be run by the cloudops team on the cluster hosting argocd

To easily deploy argocd applications, deploy the app-of-apps chart using the following commands:

```bash
ENV='dev'
APP='app-of-apps'
ARGO_NAMESPACE="argocd"

helm upgrade --install -n "${ARGO_NAMESPACE}" project-${ENV}-argocd-application-${APP} . -f "${APP}.values.${ENV}.yaml"

kubectl get applications.argoproj.io --all-namespaces
```

Using this app-of-apps pattern, you can easily deploy multiple applications on the same cluster and manage argocd applications with argocd.
