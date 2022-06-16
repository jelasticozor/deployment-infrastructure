#! /bin/sh

if [ "$#" -ne "2" ] ; then
  echo "Usage: $0 release-name namespace"
  exit 1
fi

RELEASE_NAME=$1
NAMESPACE=$2

helm uninstall --namespace ${NAMESPACE} ${RELEASE_NAME}

kubectl delete namespace ${NAMESPACE}