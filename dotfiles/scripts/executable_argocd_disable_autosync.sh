#!/bin/bash

#u argocd_disable_autosync.sh app-name1 app-name2 app-name3 ...
#d Disable auto-sync for a given list of ArgoCD applications

KUBECTL_OPTS="--context app-cloudops-prod-eks"
APPS=$@

if [ -z "${APPS}" ]; then
  echo "Usage: argocd_disable_autosync.sh app-name1 app-name2 app-name3 ..."
  exit 1
fi

kubectl ${KUBECTL_OPTS} get applications -A -o name | cut -d '/' -f 2 > /tmp/argocd_apps.txt

# Check if all apps exists
for APP in ${APPS}; do
  echo "Checking if app [${APP}] exists"
  if ! grep -q -E "^${APP}$" /tmp/argocd_apps.txt; then
    echo "App ${APP} not found in ArgoCD"
    exit 1
  fi
done


echo "Disabling auto-sync for apps:"
echo "${APPS}" | tr ' ' '\n'
echo "Press any key to continue or CTRL+C to cancel"
read -n 1 -s

for APP in ${APPS}; do
  echo "Disabling auto-sync for app: ${APP}"
  if ! grep -q ${APP} /tmp/argocd_apps.txt; then
    echo "App ${APP} not found in ArgoCD"
    exit 1
  fi
  # kubectl ${KUBECTL_OPTS} patch applications ${APP} -n argocd --type merge --patch "{\"spec\":{\"syncPolicy\":null}}"
  kubectl ${KUBECTL_OPTS} patch applications ${APP} -n argocd --type merge --patch "{\"spec\":{\"syncPolicy\": {\"automated\": {}}}}"
done

