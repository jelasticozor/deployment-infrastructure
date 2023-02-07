#! /bin/sh

if [ "$#" -ne "3" ] ; then 
  echo "Usage: $0 <cluster-name> <api-endpoint> <access-token>"
  exit 1
fi 

CLUSTER_NAME=$1
API_ENDPOINT=$2
TOKEN=$3
CLUSTER_USERNAME=${CLUSTER_NAME}

kubectl config set-cluster "${CLUSTER_NAME}" --server="${API_ENDPOINT}"
kubectl config set-context "${CLUSTER_NAME}" --cluster="${CLUSTER_NAME}"
kubectl config set-credentials "${CLUSTER_USERNAME}" --token="${TOKEN}"
kubectl config set-context "${CLUSTER_NAME}" --user="${CLUSTER_USERNAME}"
kubectl config use-context "${CLUSTER_NAME}"