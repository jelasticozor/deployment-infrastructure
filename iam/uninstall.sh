#! /bin/sh

RELEASE_NAME=fusionauth
NAMESPACE=iam

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}