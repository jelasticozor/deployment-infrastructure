#! /bin/sh

if [ "$#" -ne "2" ] ; then
  echo "Usage: $0 <namespace> <release-name>"
  exit 1
fi

NAMESPACE=$1
RELEASE_NAME=$2

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}