#! /bin/sh

NAMESPACE=vault
RELEASE_NAME=vault

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}