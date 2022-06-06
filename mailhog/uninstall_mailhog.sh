#! /bin/sh

NAMESPACE=mail

helm uninstall --namespace ${NAMESPACE} mailhog

kubectl delete namespace ${NAMESPACE}