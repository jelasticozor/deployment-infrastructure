#! /bin/sh

NAMESPACE=message-queue
RELEASE_NAME=rabbitmq

kubectl -n ${NAMESPACE} delete pvc data-rabbitmq-* --ignore-not-found

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}