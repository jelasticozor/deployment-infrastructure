#! /bin/sh

helm repo add openfaas https://openfaas.github.io/faas-netes/
helm repo update

kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml

helm upgrade openfaas --install openfaas/openfaas \
  --namespace openfaas \
  --set generateBasicAuth=true \
  --set serviceType=ClusterIP \
  --set clusterRole=true \
  --set functionNamespace=openfaas-fn
