# Bootstraping a new cluster easily with argocd

TODO

- create a values.x.yaml for each application you want to deploy on your new environment
- create an argo-application/values.x.yaml containing applications you want to deploy and their value files to use
- create an argo-application/app-of-apps.values.x.yaml to deploy your argo applications
- ask your beloved cloudops team to deploy your argo app of apps on the cloudops argocd and sync the argo applications
