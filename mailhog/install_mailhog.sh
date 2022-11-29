#! /bin/sh

if [ "$#" -ne "3" ] ; then
  echo "Usage: $0 <baseUrl> <namespace> <release-name>"
  exit 1
fi

BASE_URL=$1

helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

NAMESPACE=$2
RELEASE_NAME=$3

wget "${BASE_URL}/mailhog/mailhog-values.yaml" -O /tmp/mailhog-values.yaml
helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} codecentric/mailhog \
  -f /tmp/mailhog-values.yaml
