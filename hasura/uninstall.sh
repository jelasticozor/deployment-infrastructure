#! /bin/sh

NAMESPACE=api
RELEASE_NAME=hasura

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}