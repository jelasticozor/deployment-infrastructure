#! /bin/sh

NAMESPACE=mail
RELEASE_NAME=mailhog

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}