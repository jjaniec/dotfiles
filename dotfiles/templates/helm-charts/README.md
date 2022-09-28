# helm-charts-xxx

This repository is used to store helm charts configurations deployed in xxx clusters.

The clusters are deployed with the following terraform repositories:

- [terraform-repo-xyz]()

All applications configurations stored in this chart are deployed under the *GitOps* methodology using ArgoCD deployed in the clusters

Helm charts can also deployed be manually without using ArgoCD using the helm cli, and required tools installed on your machine, but this is not the recommended method and should be used only for testing purposes.

## Requirements

- [awscli](https://aws.amazon.com/cli): To fetch credentials from aws to connect to the eks control-plane.
- [kubectl](https://kubernetes.io/docs/tasks/tools/): To execute commands like `kubectl get pods` on your clusters.
- [helm](https://helm.sh/docs/intro/install/): The 'kubernetes package manager', used to deploy applications on kubernetes while benefiting from the work of the community.
- [sops](https://github.com/mozilla/sops): To encrypt/decrypt files with credentials, this is needed to push credentials on this git repository. To be able to encrypt/decrypt files, you'll need access to the kms key corresponding to your environment on aws.
- [helm secrets](https://github.com/jkroepke/helm-secrets): To use helm value files encrypted by sops

## What is ArgoCD and GitOps ?

[ArgoCD] is a *GitOps* Continous Delivery tool, in short it's goal is to deploy applications using git as it's source of truth.
The main advantage of doing so is that you can have the history of all the configuration of your applications in your git repository, which means you can easily rollback to a previous version, or deploy a new version just by changing the configuration and doing a `git commit -m '...'; git push`.
ArgoCD monitors your git repository and watches for changes, when a change occurs, it sets your application as `Not Synced` and can automatically deploy the new version of your application using the new configuration in git.

[ArgoCD] can work with Kubernetes manifests specified in several ways like kustomize applications, helm charts, plain directory of YAML/json manifests.

## Contributing

Each application deployed on a cluster will have the following files in it's own subdirectory:

- a `values.yaml` file per environment, containing the configuration of the application for each cluster where the application is deployed excluding sensitive values.
- an optional `secrets.yaml` file, containing sensitive values encrypted with [helm-secrets]().
- a Chart.yaml file, containing chart `version`, `appVersion` and `dependencies` of the charts for example.
- a README.md to briefly describe what the application does and links to usefull documentations.

Ideally, each application should have 4 `values.yaml` files (1 per environment), to ensure the clusters are similiar to each other.

The goal of having a monorepo for all applications is to get a global view of what's deployed on the clusters of a same tenant (here clusters), easily having the same configuration for all the environments and easily spot difference in deployments with a simple `diff` command.

### Changing an application configuration

Upgrading an application configuration can be done for various things, deploying a new version of an app, changing overprovisioning replicas, changing an API environment variable / ...

If your application only uses a `values.yaml` file and is already deployed by argocd, simply edit the configuration corresponding to the environement you want to change and push your changes in a separate branch.

```bash
# Create a new branch
> git checkout -b feat/dev/app-x-feat-y

> vim app-x/values.dev.yaml

> git add app-x/values.dev.yaml

> git commit -m 'Update app-x/values.dev.yaml: ...'

> git push origin feat/dev/app-x-feat-y

# Then make a PR to the master branch of the repository to have your changes deployed by ArgoCD
```

#### ... with an application using a secrets.yaml file

An additional `secrets.yaml` file might be required to avoid storing credentials in the git repository in plain text.

If you need to change the `secrets` file, you can use the `helm secrets` command to encrypt/decrypt it, under the hood it uses the [sops](https://github.com/mozilla/sops) configured with kms keys on aws in the `.sops.yaml` file at the root of this repository.

The command to achieve this would be for example:

```bash
# Required by sops to use the dev account's kms key used for helm secrets
> export AWS_PROFILE="aws-dev" # or aws-prod

# Create a new branch
> git checkout -b feat/dev/app-x-feat-y

# Decrypt the secrets file using helm-secrets
> helm secrets dec ./app-x/secrets.dev.yaml

# Edit the decrypted configuration
> vim app-x/secrets.dev.yaml.dec

# Re-encrypt the secrets file using helm-secrets
> helm secrets enc ./app-x/secrets.dev.yaml # This is not a typo, doing this will encrypt the secrets.dec and rename it to secrets.dev.yaml in the same command

# Git add the newly encrypted secrets file
> git add app-x/secrets.dev.yaml

> git commit -m 'Update app-x/values.dev.yaml: ...'

> git push origin feat/dev/app-x-feat-y
```

ArgoCD will the use the same KMS key as you did to decrypt the secrets file and redeploy the application with the new configuration

### Adding a new application to be deployed by ArgoCD

TODO
