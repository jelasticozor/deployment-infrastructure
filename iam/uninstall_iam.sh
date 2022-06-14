#! /bin/sh

NAMESPACE=iam

helm uninstall --namespace ${NAMESPACE} fusionauth

kubectl delete namespace ${NAMESPACE}