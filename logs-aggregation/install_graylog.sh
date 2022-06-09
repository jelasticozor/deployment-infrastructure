#! /bin/sh

if [ "$#" -ne "1" ] ; then
  echo "Usage: $0 <baseUrl>"
  exit 1
fi

BASE_URL=$1

helm repo add elastic https://helm.elastic.co
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kongz https://charts.kong-z.com
helm repo update

NAMESPACE=graylog

kubectl create namespace ${NAMESPACE}

wget "${BASE_URL}/logs-aggregation/mongodb-values.yaml" -O /tmp/mongodb-values.yaml
helm install --namespace ${NAMESPACE} mongodb bitnami/mongodb \
  -f /tmp/mongodb-values.yaml
wget "${BASE_URL}/logs-aggregation/elasticsearch-values.yaml" -O /tmp/elasticsearch-values.yaml
helm install --namespace ${NAMESPACE} elasticsearch elastic/elasticsearch \
  -f /tmp/elasticsearch-values.yaml

wget "${BASE_URL}/logs-aggregation/graylog-values.yaml" -O /tmp/graylog-values.yaml
helm install --namespace ${NAMESPACE} graylog kongz/graylog \
  -f /tmp/graylog-values.yaml