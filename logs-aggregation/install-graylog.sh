#! /bin/sh

helm repo add elastic https://helm.elastic.co
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kongz https://charts.kong-z.com
helm repo update

NAMESPACE=graylog

kubectl create namespace ${NAMESPACE}

wget "${BASE_URL}/logs-aggregation/mongodb-values.yaml" -O mongodb-values.yaml
helm install --namespace ${NAMESPACE} mongodb bitnami/mongodb \
  -f mongodb-values.yaml
wget "${BASE_URL}/logs-aggregation/elasticsearch-values.yaml" -O elasticsearch-values.yaml
helm install --namespace ${NAMESPACE} elasticsearch elastic/elasticsearch \
  -f elasticsearch-values.yaml

wget "${BASE_URL}/logs-aggregation/graylog-values.yaml" -O graylog-values.yaml
helm install --namespace ${NAMESPACE} graylog kongz/graylog \
  -f graylog-values.yaml