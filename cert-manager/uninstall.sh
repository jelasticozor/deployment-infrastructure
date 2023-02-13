#! /bin/sh

set +e

NAMESPACE=cert-manager
RELEASE_NAME=cert-manager

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}