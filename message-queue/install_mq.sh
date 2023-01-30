#! /bin/sh

if [ "$#" -ne "2" ] ; then
  echo "Usage: $0 <baseUrl> <0-dev|1-prod>"
  exit 1
fi

BASE_URL=$1
CLUSTER_TYPE=$2

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

NAMESPACE=message-queue
RELEASE_NAME=rabbitmq

REPLICA_COUNT=1
if [ "${CLUSTER_TYPE}" = "1-dev" ] ; then 
  REPLICA_COUNT=2
fi

# Install separate production rabbitmq instance
wget ${BASE_URL}/message-queue/values-production.yaml -O values-production.yaml
sed -i s/REPLICA_COUNT/${REPLICA_COUNT}/g values-production.yaml

helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} bitnami/rabbitmq \
  -f https://raw.githubusercontent.com/bitnami/charts/master/bitnami/rabbitmq/values.yaml -f values-production.yaml --wait
