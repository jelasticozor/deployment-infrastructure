#! /bin/sh

NAMESPACE=graylog
RELEASE_NAME=graylog

helm uninstall --namespace ${NAMESPACE} mongodb
helm uninstall --namespace ${NAMESPACE} elasticsearch
helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}
  
kubectl delete namespace ${NAMESPACE}