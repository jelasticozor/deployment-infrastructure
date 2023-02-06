#! /bin/sh

cd "${0%/*}"

helm repo add openfaas https://openfaas.github.io/faas-netes/
helm repo update

NAMESPACE=openfaas
RELEASE_NAME=openfaas

kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml

helm upgrade ${RELEASE_NAME} --install openfaas/openfaas \
  --namespace ${NAMESPACE} \
  --set generateBasicAuth=true \
  --set serviceType=ClusterIP \
  --set clusterRole=true \
  --set functionNamespace=openfaas-fn
