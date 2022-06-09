#! /bin/sh

helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

NAMESPACE=mail

kubectl create namespace ${NAMESPACE}

wget "${BASE_URL}/mailhog/mailhog-values.yaml" -O /tmp/mailhog-values.yaml
helm install --namespace ${NAMESPACE} mailhog codecentric/mailhog \
  -f /tmp/mailhog-values.yaml
