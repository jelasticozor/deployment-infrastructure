#! /bin/sh

NAMESPACE=message-queue
RELEASE_NAME=rabbitmq

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}