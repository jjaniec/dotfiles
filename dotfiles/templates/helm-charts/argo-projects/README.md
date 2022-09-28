# Argo-projects

Projects provide a logical grouping of applications, which is useful when Argo CD is used by multiple teams.

Projects provide the following features:

- restrict what may be deployed (trusted Git source repositories)
- restrict where apps may be deployed to (destination clusters and namespaces)
- restrict what kinds of objects may or may not be deployed (e.g. RBAC, CRDs, DaemonSets, NetworkPolicy etc...)
- defining project roles to provide application RBAC (bound to OIDC groups and/or JWT tokens)

## Documentations

- [Projects documentation](https://argoproj.github.io/argo-cd/user-guide/projects/)
- [example yaml](https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/project.yaml)

## Deploy a project manually

### This deployment should be run by the cloudops team on the cluster hosting argocd

```bash
ENV='dev'
PROJECT='tooling'
ARGO_NAMESPACE='argocd'

helm upgrade --install -n "${ARGO_NAMESPACE}" "argocd-project-${ENV}-${PROJECT}" . -f "${ENV}/values.${PROJECT}.yaml"
```

## Install / Upgrade multiple projects

```bash
for project in tooling ... ;
do
	helm upgrade --install -n "${ARGO_NAMESPACE}" "argocd-project-${ENV}-${project}" . -f "./${ENV}/values.${project}.yaml";
done;
```
