#! /bin/sh

NAMESPACE=database

helm uninstall --namespace ${NAMESPACE} postgresql

kubectl delete namespace ${NAMESPACE}