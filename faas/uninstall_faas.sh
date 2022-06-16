#! /bin/sh

NAMESPACE=openfaas
RELEASE_NAME=openfaas

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}