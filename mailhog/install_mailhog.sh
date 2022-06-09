#! /bin/sh

if [ "$#" -ne "1" ] ; then
  echo "Usage: $0 <baseUrl>"
  exit 1
fi

BASE_URL=$1

helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

NAMESPACE=mail

kubectl create namespace ${NAMESPACE}

wget "${BASE_URL}/mailhog/mailhog-values.yaml" -O /tmp/mailhog-values.yaml
helm install --namespace ${NAMESPACE} mailhog codecentric/mailhog \
  -f /tmp/mailhog-values.yaml
