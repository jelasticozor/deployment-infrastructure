#! /bin/sh

NAMESPACE=graylog

helm uninstall --namespace ${NAMESPACE} mongodb
helm uninstall --namespace ${NAMESPACE} elasticsearch
helm uninstall --namespace ${NAMESPACE} graylog
  
kubectl delete namespace ${NAMESPACE}