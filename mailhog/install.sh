#! /bin/sh

cd "${0%/*}"

helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

NAMESPACE=mail
RELEASE_NAME=mailhog

helm upgrade --install --create-namespace --namespace ${NAMESPACE} ${RELEASE_NAME} codecentric/mailhog \
  -f values.yaml